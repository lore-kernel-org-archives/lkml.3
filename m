Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab3HINIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:08:37 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:60238 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab3HINIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:08:34 -0400
Message-ID: <5204EA04.9060109@linux.vnet.ibm.com>
Date: Fri, 09 Aug 2013 18:39:24 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH  V12 0/14] Paravirtualized ticket spinlocks
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com> <52044013.3010202@zytor.com>
In-Reply-To: <52044013.3010202@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080913-8256-0000-0000-000008B93757
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 06:34 AM, H. Peter Anvin wrote:
> The kbuild test bot is reporting some pretty serious errors for this
> patchset.  I think these are serious enough that the patchset will need
> to be respun.
>

There were two problems:
(1) we were including spinlock_types.h in 
arch/x86/include/asm/paravirt_types.h.

This was resulting in redefinition of arch_spinlock_t for non SMP kernel

solution was :
conditional inclusion of spinlock_types.h like below

#ifdef CONFIG_SMP
#include <asm/spinlock_types.h>
#else
typedef u16 __ticket_t;
#endif

(we needed __ticket_t declaration for UP)

(2) we had forward declaration of atomic_read in jumpl_label.
It was causing problem for alpha, which has macro for atomic_read
instead of static inline.

Solution was to remove forward declaration and have atomic.h included.

Peter,
  the above two changes needs small changes in patch 1 and patch 9.
I 'll be resending only those two patches.

I am happy to resend the whole series if it is better and easier for
you.


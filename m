Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbaJaKNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:13:43 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:44504 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbaJaKNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:13:42 -0400
Date: Fri, 31 Oct 2014 11:13:37 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, tianyu.lan@intel.com,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH v3] xen/smp: Use die_complete completion when
 taking CPU down
Message-ID: <20141031101337.GA24204@gmail.com>
References: <1413997748-29808-1-git-send-email-boris.ostrovsky@oracle.com>
 <54514211.9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54514211.9@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Boris Ostrovsky <boris.ostrovsky@oracle.com> wrote:

> On 10/22/2014 01:09 PM, Boris Ostrovsky wrote:
> >Commit 2ed53c0d6cc9 ("x86/smpboot: Speed up suspend/resume by avoiding
> >100ms sleep for CPU offline during S3") introduced completions to CPU
> >offlining process. These completions are not initialized on Xen kernels
> >causing a panic in play_dead_common().
> >
> >Move handling of die_complete into common routines to make them
> >available to Xen guests.
> >
> >(While at it, move die_complete definition under #ifdef CONFIG_HOTPLUG_CPU)
> >
> >Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> >Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> >---
> >
> >v3: Don't #ifdef function prototypes in smp.h
> >v2: Keep die_complete private to smpboot.c
> >
> >
> >  arch/x86/include/asm/smp.h |  1 +
> >  arch/x86/kernel/smpboot.c  | 13 +++++++++++--
> >  arch/x86/xen/smp.c         |  3 +++
> >  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> 
> Does anything else need to be done in this patch? We have CPU 
> hotplug broken currently in Xen and it would be nice to have it 
> fixed in rc3.

There's a build warning fix that this change conflicts with:

 db6a00b4bed3 x86/smpboot: Move data structure to its primary usage scope

it would be nice if you could rebase it to tip:master or 
tip:x86/urgent so I can push it upstream ASAP.

Thanks,

	Ingo

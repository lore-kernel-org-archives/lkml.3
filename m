Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966040Ab3DQLPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:15:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965117Ab3DQLPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:15:49 -0400
Date: Wed, 17 Apr 2013 13:16:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Victor Miasnikov <vvm@tut.by>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        JBeulich@suse.com, bp@alien8.de
Subject: Re: KVM  "Hyper-V emulation"   -- this can be related "Linux on
 Hyper-V" ? Or  "KVM emulates Hyper-V" as  "Hyper-V emulates Hyper-V" ? Re:
 [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Message-ID: <20130417101617.GF3881@redhat.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
 <39D7C3658A5B4979A3F025E1D944E743@local.st.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39D7C3658A5B4979A3F025E1D944E743@local.st.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 12:10:01PM +0300, Victor Miasnikov wrote:
> Question is very simple:  Hyper-V users/sysadmins need wait patch a-la this:
> 
> ==
> KVM emulates Hyper-V to host enlightened Windows. Looks like this
> emulation may be turned on by default even for Linux guests. Check and
> fail Hyper-V detection if we are on KVM.

> [ hpa: the problem here is that KVM doesn't emulate Hyper-V well
>  enough, and if the KVM support isn't compiled in, we end up stubling
>  over the Hyper-V emulation and try to activate it -- and it fails. ]
> 
> . . .

What's emulated not well enough?

> + /*
> +  * KVM emulates Hyper-V to support enlightened Windows.
> +  * Check to see first if we are on a KVM Hypervisor.
> +  */

If the hypervisor says it's Hyper-V, that's because it wants
guests to use Hyper-V. I don't see why is guest second-guessing
this a good idea.

> + if (KVM_cpuid_base())
> +  return false;
> +
> ==
> 
> 
> Or  "KVM emulates Hyper-V" as  "Hyper-V emulates Hyper-V" ?
> 
> 
> Best regards, Victor Miasnikov
> Blog:  http://vvm.blog.tut.by/
> 
> P.S.

No.  You are using Hyper-V, not the KVM emulation of it.  No patches
dealing with this emulation should have any effect on you.

-- 
MST

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab3CYTnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 15:43:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841Ab3CYTnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 15:43:00 -0400
Date: Mon, 25 Mar 2013 15:42:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
Message-ID: <20130325194245.GA7357@redhat.com>
References: <20130320163131.GE2273@redhat.com>
 <1363807329-24975-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363807329-24975-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 12:22:09PM -0700, Yinghai Lu wrote:
> We can extend kexec-tools to support multiple "Crash kernel" in /proc/iomem
> instead.
> 
> So we can use "Crash kernel" instead of "Crash kernel low" in /proc/iomem.
> 
> Suggested-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Hi Yinghai,

This patch along with second version of kexec-tools patch works for me.
I had a small concern.

- Older version of kexec-tools do not work when multiple "Crash Kernel"
  entries show up in /proc/iomem. They error out with following.

Memory for crashkernel is not reserved
Please reserve memory by passing "crashkernel=X@Y" parameter to the kernel

I am assuming that crashkernel=X changes will break older kexec-tools
anyway on most of the machines (As it reserves memory as high as possible
by default) and older kexec-tools will not be able to load kernel that
high.

So it is a forgone conclusion that these new kernel changes to 
crashkernel=X in 3.9 are incompatible with older kexec-tools and one
needs to upgrade kexec-tools.

Other syntax of crashkernel=X@Y will continue to work though.

Thanks
Vivek

> 
> ---
>  kernel/kexec.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.orig/kernel/kexec.c
> +++ linux-2.6/kernel/kexec.c
> @@ -55,7 +55,7 @@ struct resource crashk_res = {
>  	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
>  };
>  struct resource crashk_low_res = {
> -	.name  = "Crash kernel low",
> +	.name  = "Crash kernel",
>  	.start = 0,
>  	.end   = 0,
>  	.flags = IORESOURCE_BUSY | IORESOURCE_MEM

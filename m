Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591Ab3DDOQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:16:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760960Ab3DDOQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:16:16 -0400
Date: Thu, 4 Apr 2013 10:16:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] x86, kdump: Retore crashkernel= to allocate low
Message-ID: <20130404141604.GD16459@redhat.com>
References: <1365035906-3208-1-git-send-email-yinghai@kernel.org>
 <1365035906-3208-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365035906-3208-4-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 05:38:25PM -0700, Yinghai Lu wrote:
> Vivek found old kexec-tools does not work new kernel anymore.
> 
> So change back crashkernel= back to old behavoir, and add crashkernel_high=
> to let user decide if buffer could be above 4G, and also new kexec-tools will
> be needed.
> 
> v2: let crashkernel=X override crashkernel_high=
>     update description about _high will be ignored by crashkernel=X
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  Documentation/kernel-parameters.txt |   11 +++++++++--
>  arch/x86/kernel/setup.c             |   24 +++++++++++++++++++-----
>  include/linux/kexec.h               |    2 ++
>  kernel/kexec.c                      |    9 +++++++++
>  4 files changed, 39 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6/Documentation/kernel-parameters.txt
> @@ -603,9 +603,14 @@ bytes respectively. Such letter suffixes
>  			a memory unit (amount[KMG]). See also
>  			Documentation/kdump/kdump.txt for an example.
>  
> +	crashkernel_high=size[KMG]
> +			[KNL, x86_64] range could be above 4G. Allow kernel
> +			to allocate physical memory region from top, so could
> +			be above 4G if system have more than 4G ram installed.

Also specify "otherwise memory will be allocated below 4G, if available".

> +			It will be ignored if crashkernel=X is specified.
>  	crashkernel_low=size[KMG]
> -			[KNL, x86_64] range under 4G. When crashkernel= is
> -			passed, kernel allocate physical memory region
> +			[KNL, x86_64] range under 4G. When crashkernel_high= is
> +			passed, kernel could allocate physical memory region
>  			above 4G, that cause second kernel crash on system
>  			that need swiotlb later. Kernel would try to allocate
>  			some region below 4G automatically. This one let
> @@ -614,6 +619,8 @@ bytes respectively. Such letter suffixes
>  			0: to disable low allocation on systems that do not
>  			need swiotlb, that will save 72M low ram in first
>  			kernel.
> +			It will be ignored when crashkernel_high=X is not used
> +			or return from that is below 4G.

Replace "return from that" with "memory reserved".

Vivek

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3HYQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 12:16:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37687 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3HYQQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 12:16:52 -0400
Date: Sun, 25 Aug 2013 18:16:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, opensuse-kernel@opensuse.org,
        David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH 09/18] Secure boot: Add a dummy kernel parameter that
 will switch on Secure Boot mode
Message-ID: <20130825161649.GF5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-10-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377169317-5959-10-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You may want to check subject. If it does something, it is not dummy.

> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2784,6 +2784,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Note: increases power consumption, thus should only be
>  			enabled if running jitter sensitive (HPC/RT) workloads.
>  
> +	secureboot_enable=
> +			[KNL] Enables an emulated UEFI Secure Boot mode.  This
> +			locks down various aspects of the kernel guarded by the
> +			CAP_COMPROMISE_KERNEL capability.  This includes things
> +			like /dev/mem, IO port access, and other areas.  It can
> +			be used on non-UEFI machines for testing purposes.
> +
>  	security=	[SECURITY] Choose a security module to enable at boot.
>  			If this boot parameter is not specified, only the first
>  			security module asking for security registration will be
> diff --git a/kernel/cred.c b/kernel/cred.c
> index e0573a4..c3f4e3e 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -565,6 +565,23 @@ void __init cred_init(void)
>  				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
>  }
>  
> +void __init secureboot_enable()
> +{
> +	pr_info("Secure boot enabled\n");
> +	cap_lower((&init_cred)->cap_bset, CAP_COMPROMISE_KERNEL);
> +	cap_lower((&init_cred)->cap_permitted, CAP_COMPROMISE_KERNEL);
> +}

OTOH you don't implement CAP_COMPROMISE_KERNEL, so it is dummy after
all. But CAP_COMPROMISE_KERNEL is infeasible to implement, right?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

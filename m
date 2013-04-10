Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3DJFbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:31:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab3DJFbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:31:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,444,1363104000"; 
   d="scan'208";a="7026143"
Message-ID: <5164F9E9.3010909@cn.fujitsu.com>
Date: Wed, 10 Apr 2013 13:34:33 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH v3 02/22] x86, microcode: Use common get_ramdisk_image()
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org> <1365119186-23487-3-git-send-email-yinghai@kernel.org>
In-Reply-To: <1365119186-23487-3-git-send-email-yinghai@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/10 13:30:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/10 13:30:31,
	Serialize complete at 2013/04/10 13:30:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 07:46 AM, Yinghai Lu wrote:
> Use common get_ramdisk_image() to get ramdisk start phys address.
>
> We need this to get correct ramdisk adress for 64bit bzImage that
> initrd can be loaded above 4G by kexec-tools.
>
> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
> Cc: Fenghua Yu<fenghua.yu@intel.com>
> Acked-by: Tejun Heo<tj@kernel.org>
> ---
>   arch/x86/kernel/microcode_intel_early.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
> index d893e8e..ea57bd8 100644
> --- a/arch/x86/kernel/microcode_intel_early.c
> +++ b/arch/x86/kernel/microcode_intel_early.c
> @@ -742,8 +742,8 @@ load_ucode_intel_bsp(void)
>   	struct boot_params *boot_params_p;
>
>   	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
> -	ramdisk_image = boot_params_p->hdr.ramdisk_image;
> -	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
> +	ramdisk_image = get_ramdisk_image(boot_params_p);
> +	ramdisk_size  = get_ramdisk_image(boot_params_p);

Shoule be get_ramdisk_size(boot_params_p) ?

>   	initrd_start_early = ramdisk_image;
>   	initrd_end_early = initrd_start_early + ramdisk_size;
>
> @@ -752,8 +752,8 @@ load_ucode_intel_bsp(void)
>   		(unsigned long *)__pa_nodebug(&mc_saved_in_initrd),
>   		initrd_start_early, initrd_end_early,&uci);
>   #else
> -	ramdisk_image = boot_params.hdr.ramdisk_image;
> -	ramdisk_size  = boot_params.hdr.ramdisk_size;
> +	ramdisk_image = get_ramdisk_image(&boot_params);
> +	ramdisk_size  = get_ramdisk_size(&boot_params);
>   	initrd_start_early = ramdisk_image + PAGE_OFFSET;
>   	initrd_end_early = initrd_start_early + ramdisk_size;
>

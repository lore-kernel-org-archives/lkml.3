Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab3IXW4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:56:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60567 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab3IXW4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:56:14 -0400
Message-ID: <5242185C.6070204@zytor.com>
Date: Tue, 24 Sep 2013 15:55:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        holt@sgi.com, rmk+kernel@arm.linux.org.uk, stable@vger.kernel.org,
        tglx@linutronix.de, gxt@mprc.pku.edu.cn, vlee@twitter.com,
        msharbiani@twitter.com
CC: tip-bot for Masoud Sharbiani <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/reboot: Add quirk to make Dell C6100 use
 reboot=pci automatically
References: <1379717947-18042-1-git-send-email-vlee@freedesktop.org> <tip-4f0acd31c31f03ba42494c8baf6c0465150e2621@git.kernel.org>
In-Reply-To: <tip-4f0acd31c31f03ba42494c8baf6c0465150e2621@git.kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 06:37 AM, tip-bot for Masoud Sharbiani wrote:
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 563ed91..5f4ad27 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -358,6 +358,22 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
>  		},
>  	},
> +	{	/* Handle problems with rebooting on the Dell PowerEdge C6100. */
> +		.callback = set_pci_reboot,
> +		.ident = "Dell PowerEdge C6100",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
> +		},
> +	},
> +	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
> +		.callback = set_pci_reboot,
> +		.ident = "Dell PowerEdge C6100",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
> +		},

Aren't these substring matches anyway?  If so, the first entry is redundant.

	-hpa



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab3HNQon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:44:43 -0400
Received: from oproxy1-pub.mail.unifiedlayer.com ([66.147.249.253]:56608 "HELO
	oproxy1-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932908Ab3HNQoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:44:39 -0400
Date: Wed, 14 Aug 2013 09:38:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/1] intel_ips: blacklist ASUSTek G60JX laptops
Message-ID: <20130814093836.57002b77@jbarnes-desktop>
In-Reply-To: <d4635f76028172e872cc4be506bad1c11816f75a.1376494861.git.joseph.salisbury@canonical.com>
References: <cover.1376494861.git.joseph.salisbury@canonical.com>
	<d4635f76028172e872cc4be506bad1c11816f75a.1376494861.git.joseph.salisbury@canonical.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 12:22:49 -0400
Joseph Salisbury <joseph.salisbury@canonical.com> wrote:

> BugLink: http://bugs.launchpad.net/bugs/1210848
> 
> On an ASUSTek G60JX laptop, the intel_ips driver spams the log with a warning message: "ME failed to update for more than 1s, likely hung".  This ME doesn't support the feature, so requesting it be blacklisted for now.   
> 
> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> Tested-by: Nick Jenkins <tech.crew.jenkins@gmail.com> 
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: platform-driver-x86@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  drivers/platform/x86/intel_ips.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
> index 18dcb58..6d8c5e0 100644
> --- a/drivers/platform/x86/intel_ips.c
> +++ b/drivers/platform/x86/intel_ips.c
> @@ -1501,6 +1501,14 @@ static const struct dmi_system_id ips_blacklist[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "HP ProBook"),
>  		},
>  	},
> +	{
> +		.callback = ips_blacklist_callback,
> +		.ident = "G60JX",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "G60JX"),
> +		},
> +	},
>  	{ }	/* terminating entry */
>  };
>  

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Linus, you may want to pick this up directly, as I'm not sure if
Matthew is still looking after the x86 drivers these days.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

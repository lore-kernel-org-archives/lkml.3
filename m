Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaBMJlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:41:06 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:53633 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752367AbaBMJlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:41:01 -0500
Message-ID: <1392284459.30853.17.camel@x220>
Subject: Re: [PATCH] blackfin: bf537: fix typo "CONFIG_SND_SOC_ADV80X_MODULE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Steven Miao <realmz6@gmail.com>
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 13 Feb 2014 10:40:59 +0100
In-Reply-To: <1362744373.5994.57.camel@x61.thuisdomein>
References: <1362744373.5994.57.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 09:40:59.0836 (UTC) FILETIME=[B3CAD7C0:01CF289F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Replaced previous maintainer and list with current maintainer and
list.]

On Fri, 2013-03-08 at 13:06 +0100, Paul Bolle wrote:
> There's a (rather subtle) typo in "CONFIG_SND_SOC_ADV80X_MODULE". Fix it
> once and for all by using IS_ENABLED(), which is designed to avoid
> issues like this.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Has someone ever looked at this trivial patch? The typo is still not
fixed in v3.14-rc2.

> 0) Untested! And this needs build- and runtime testing, especially for
> the MODULE case!
> 
> 1) There are many lines that might be converted to IS_ENABLED() in this
> file. I'm not sure if and how that should be done.
> 
>  arch/blackfin/mach-bf537/boards/stamp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
> index 95114ed..1872d15 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -985,7 +985,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
>  	},
>  #endif
>  
> -#if defined(CONFIG_SND_SOC_ADAV80X) || defined(CONFIG_SND_SOC_ADV80X_MODULE)
> +#if IS_ENABLED(CONFIG_SND_SOC_ADAV80X)
>  	{
>  		.modalias = "adav801",
>  		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */


Paul Bolle


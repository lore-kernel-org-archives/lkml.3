Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaHABNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:13:18 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55387 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751120AbaHABNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:13:17 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jie Yang <yang.jie@intel.com>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, liam.r.girdwood@intel.com,
        vinod.koul@intel.com, mengdong.lin@intel.com
Subject: Re: [PATCH v2] ACPI / LPSS: add lpss device for Wildcat Point PCH
Date: Fri, 01 Aug 2014 03:31:51 +0200
Message-ID: <11756414.44Jc0GixIr@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406855195-14275-1-git-send-email-yang.jie@intel.com>
References: <1406855195-14275-1-git-send-email-yang.jie@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 01, 2014 09:06:35 AM Jie Yang wrote:
> INT3438 is the ADSP device on Wildcat Point platform
> with 2 DW DMA engines built In. The DMA engines are
> used for DSP FW loading and audio data transferring.
> These DMA engine probing need the clock, without it,
> probing may failed and can't go forward.
> 
> Add lpss device "INT3438" for Wildcat Point PCH, to
> provide clock for its ADSP DMA engine probing.
> 
> Signed-off-by: Jie Yang <yang.jie@intel.com>

Looks good, queued up for 3.17, thanks!

> ---
>  drivers/acpi/acpi_lpss.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 9cb65b0..ce06149 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -113,6 +113,14 @@ static void lpss_i2c_setup(struct lpss_private_data *pdata)
>  	writel(val, pdata->mmio_base + offset);
>  }
>  
> +static struct lpss_device_desc wpt_dev_desc = {
> +	.clk_required = true,
> +	.prv_offset = 0x800,
> +	.ltr_required = true,
> +	.clk_divider = true,
> +	.clk_gate = true,
> +};
> +
>  static struct lpss_device_desc lpt_dev_desc = {
>  	.clk_required = true,
>  	.prv_offset = 0x800,
> @@ -226,6 +234,8 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
>  	{ "INT3436", LPSS_ADDR(lpt_sdio_dev_desc) },
>  	{ "INT3437", },
>  
> +	{ "INT3438", LPSS_ADDR(wpt_dev_desc) },
> +
>  	{ }
>  };
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

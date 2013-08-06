Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3HFSfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:35:33 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:42948 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab3HFSfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:35:31 -0400
Message-ID: <520141F2.4060907@cogentembedded.com>
Date: Tue, 06 Aug 2013 22:35:30 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, swarren@wwwdotorg.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu
Subject: Re: [PATCH v2 6/6] usb: host: tegra: Tegra30 support
References: <1375812518-3847-1-git-send-email-ttynkkynen@nvidia.com> <1375812518-3847-7-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1375812518-3847-7-git-send-email-ttynkkynen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/06/2013 10:08 PM, Tuomas Tynkkynen wrote:

> The Tegra30 EHCI controller is mostly compatible with the Tegra20
> controller, except Tegra30 includes the HOSTPC register extension.
> The has_hostpc capability bit must be set in the ehci_hcd structure if
> the controller has such extensions. The new tegra_ehci_soc_config
> structure is added to describe the differences between the SoCs.

> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
>   drivers/usb/host/ehci-tegra.c | 34 +++++++++++++++++++++++++++++-----
>   1 file changed, 29 insertions(+), 5 deletions(-)

> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index db8031f..c0d1f27 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
[...]
>   static int tegra_ehci_probe(struct platform_device *pdev)
>   {
> +	const struct of_device_id *match;
> +	const struct tegra_ehci_soc_config *soc_config;
>   	struct resource *res;
>   	struct usb_hcd *hcd;
>   	struct ehci_hcd *ehci;
> @@ -330,6 +351,13 @@ static int tegra_ehci_probe(struct platform_device *pdev)
>   	int irq;
>   	struct usb_phy *u_phy;
>
> +	match = of_match_device(tegra_ehci_of_match, &pdev->dev);
> +	if (!match) {
> +		dev_err(&pdev->dev, "Error: No device match found\n");
> +		return -ENODEV;
> +	}
> +	soc_config = (struct tegra_ehci_soc_config *)match->data;

    Aren't casts from 'const void *' automatic?

WBR, Sergei


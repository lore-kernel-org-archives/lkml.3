Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3CRNC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:02:28 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:42303 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3CRNC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:02:26 -0400
Message-ID: <5147102F.1060204@cogentembedded.com>
Date: Mon, 18 Mar 2013 17:01:35 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        swarren@wwwdotorg.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 5/7] usb: phy: tegra: get ULPI reset GPIO info using DT.
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <1363609781-4045-6-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1363609781-4045-6-git-send-email-vbyravarasu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 18-03-2013 16:29, Venu Byravarasu wrote:

> As GPIO information is avail through DT, used it to get Tegra ULPI
> reset GPIO number. Added a new member to tegra_usb_phy structure to
> store this number.

> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>   drivers/usb/phy/tegra_usb_phy.c   |   25 +++++++++++--------------
>   include/linux/usb/tegra_usb_phy.h |    1 +
>   2 files changed, 12 insertions(+), 14 deletions(-)

> diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
> index b5b2037..29c5ac4 100644
> --- a/drivers/usb/phy/tegra_usb_phy.c
> +++ b/drivers/usb/phy/tegra_usb_phy.c
[...]
> @@ -622,18 +619,18 @@ static int	tegra_phy_init(struct usb_phy *x)
[...]
> -		gpio_request(ulpi_config->reset_gpio, "ulpi_phy_reset_b");
> -		gpio_direction_output(ulpi_config->reset_gpio, 0);
> +		gpio_request(phy->reset_gpio, "ulpi_phy_reset_b");
> +		gpio_direction_output(phy->reset_gpio, 0);

    Why not use goio_request_one() instead of these two? Thought maybe it's a 
material of another patch...

WBR, Sergei


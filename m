Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab3EWO1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:27:36 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:35286 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558Ab3EWO1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:27:34 -0400
Message-ID: <519E275A.5020200@cogentembedded.com>
Date: Thu, 23 May 2013 18:27:38 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ravi Babu <ravibabu@ti.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH v1 8/9] usb: phy: dts: Adding usbphy DT bindings for am33xx
References: <1369288888-8614-1-git-send-email-ravibabu@ti.com> <1369288888-8614-9-git-send-email-ravibabu@ti.com>
In-Reply-To: <1369288888-8614-9-git-send-email-ravibabu@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-05-2013 10:01, Ravi Babu wrote:

> The am33xx platforms suppors dual musb instance which need two instances
> of usb-phy. Add dual instance usb-phy DT bindings for am333x platform.

> Signed-off-by: Ravi Babu <ravibabu@ti.com>
> ---
>   arch/arm/boot/dts/am33xx.dtsi |   17 +++++++++++++++++
>   1 files changed, 17 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 0957645..b0b4deb 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -322,6 +322,22 @@
>   			status = "disabled";
>   		};
>
> +		phy1: usbphy-gs70@44e10620 {
> +			compatible = "ti,dsps-usbphy";
> +			reg = <0x44e10620 0x8
> +			       0x44e10648 0x4>;
> +			reg-names = "phy_ctrl","phy_wkup";
> +			id = <0>;
> +		};
> +
> +		phy2: usbphy-gs70@44e10628 {
> +			compatible = "ti,dsps-usbphy";
> +			reg = <0x44e10628 0x8
> +			       0x44e10648 0x4>;

    The second register conflicts with phy1.

WBR, Sergei


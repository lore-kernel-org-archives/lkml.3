Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbbASUTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:19:46 -0500
Received: from gloria.sntech.de ([95.129.55.99]:56734 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbbASUTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:19:44 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Romain Perier <romain.perier@gmail.com>,
        David Miller <davem@davemloft.net>
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        roger.chen@rock-chips.com
Subject: Re: [PATCH v1 0/4] net: stmmac: dwmac-rk: Fix phy regulator issues
Date: Mon, 19 Jan 2015 21:19:29 +0100
Message-ID: <1446006.BXnWRvK5p3@phil>
User-Agent: KMail/4.14.2 (Linux/3.16.0-4-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1421690889-11901-1-git-send-email-romain.perier@gmail.com>
References: <1421690889-11901-1-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Romain

Am Montag, 19. Januar 2015, 18:08:05 schrieb Romain Perier:
> This series fixes few issues in dwmac-rk:
> 
> 1. Voltage settings was hardcoded into the driver for the phy regulator.
>    The driver now uses the default voltage settings found in the devicetree,
> which are applied throught the regulator framework.
> 2. The regulator name used to power on or power off the phy was put in the
> devicetree variable "phy_regulator", which is not standard and added a lot
> of code for nothing. The driver now uses the devicetree property
> "phy-supply" and the corresponding functions to manipulate this regulator.
> 
> The corresponding devicetree files are also updated. As, dwmac-rk was
> recently pushed in the development tree, I don't care about devicetree
> backward compatibility issues.

This last sentence is slightly misleading :-) .

The actual fact is, that these new bindings for the rk3288 gmac have not been 
released with any official kernel release yet ... i.e. the will be released with 
3.20 in whatever form, so we don't _need_ to care about keeping compatibility 
still for the next 2.5 weeks or so.

@Dave: it would be good if this series (when fixed) could still go into the 
3.20 material so we don't get stuck with the non-standard regulator property.


As we'll probably need a v2 due to at the issue in patch3, could you also 
switch places of patch1 and 2, which would keep bisecatbility (i.e. regulator 
property before removing the voltage setting from the driver).


Otherwise this series:
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Heiko Stuebner <heiko@sntech.de>


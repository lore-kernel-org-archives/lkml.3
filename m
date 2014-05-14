Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaENHYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:24:33 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:50404 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaENHYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:24:32 -0400
Message-ID: <1400052224.8431.11.camel@iivanov-dev>
Subject: Re: [PATCH v2] usb: phy: msm: reset controller is mandatory now
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 14 May 2014 10:23:44 +0300
In-Reply-To: <4319810.IibMxJ0Qvk@wuerfel>
References: <4319810.IibMxJ0Qvk@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 21:46 +0200, Arnd Bergmann wrote:
> Commit a27345434134 "usb: phy: msm: Use reset framework for LINK
> and PHY resets" introduced a mandatory call to reset_control_get
> into the msm usb phy driver, which means we have to add a Kconfig
> dependency on the API to avoid this build error:
> 
> phy/phy-msm-usb.c: In function 'msm_otg_read_dt':
> phy/phy-msm-usb.c:1461:2: error: implicit declaration of function 'devm_reset_control_get' [-Werror=implicit-function-declaration]
>   motg->link_rst = devm_reset_control_get(&pdev->dev, "link");
>   ^
> 
> Since the usb-ehci-msm driver currently selects the OTG driver,
> we could still get a broken dependency here. To solve that,
> this patch also removes the 'select', which turns out to be
> unnecessary.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Thank you.

Reviewed-by: Ivan T. Ivanov <iivanov@mm-sol.com>


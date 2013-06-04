Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab3FDOXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:23:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40108 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077Ab3FDOXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:23:48 -0400
Message-ID: <51ADF867.8060300@ti.com>
Date: Tue, 4 Jun 2013 09:23:35 -0500
From: Ruchika Kharwar <ruchika@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <benoit.cousson@linaro.org>,
        <anish198519851985@gmail.com>, <pmeerw@pmeerw.net>
Subject: Re: [PATCH 0/5] dwc3: omap: adapt dwc3 to use extcon framework
References: <1370276020-17446-1-git-send-email-kishon@ti.com>
In-Reply-To: <1370276020-17446-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kishon,
What is the expectation when there is no palmas tied to dwc3/dwc3-omap ?
Thank you
Regards
Ruchika

On 06/03/2013 11:13 AM, Kishon Vijay Abraham I wrote:
> The first three patches deals with cleanup of extcon inorder to get
> through compilation without any issues. It also adds an API to get
> extcon device from dt node which I felt was missing.
>
> The next two patches deals with adapt dwc3 to use extcon framework.
> The 4th patch (usb: dwc3: omap: improve error handling of dwc3_omap_probe)
> should have ideally been sent to Felipe, however since
> there will be merge conflicts with the 5th patch
> (usb: dwc3: use extcon fwrk to receive connect/disconnect)
> in this series, I've sent in the same series.
>
> Once this patch series get merged, dwc3 in omap would be functional
> in device mode. However there is still some discussion on modelling
> SMPS10 regulator. Once that gets finalized, dwc3 should be functional
> in host mode as well.
>
> Kishon Vijay Abraham I (5):
>    extcon: Add an API to get extcon device from dt node
>    extcon: Kconfig: Make extcon config type as bool
>    extcon: add EXPORT_SYMBOL_GPL for exported functions
>    usb: dwc3: omap: improve error handling of dwc3_omap_probe
>    usb: dwc3: use extcon fwrk to receive connect/disconnect
>
>   Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
>   drivers/extcon/Kconfig                             |    2 +-
>   drivers/extcon/extcon-class.c                      |   42 +++++++
>   drivers/usb/dwc3/dwc3-omap.c                       |  133 ++++++++++++++++----
>   include/linux/extcon.h                             |    8 ++
>   include/linux/usb/dwc3-omap.h                      |   30 -----
>   6 files changed, 168 insertions(+), 52 deletions(-)
>   delete mode 100644 include/linux/usb/dwc3-omap.h
>


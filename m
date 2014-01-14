Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbaANC5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:57:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47421 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaANC5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:57:07 -0500
Message-ID: <52D4A780.7050907@wwwdotorg.org>
Date: Mon, 13 Jan 2014 19:57:04 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Florian Meier <florian.meier@koalo.de>
CC: linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] BCM2835: Add I2S driver to device tree
References: <52D3CA6E.1010803@koalo.de> <52D3CB18.8040608@koalo.de>
In-Reply-To: <52D3CB18.8040608@koalo.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 04:16 AM, Florian Meier wrote:
> This adds the definitions for the BCM2835 I2S driver
> to the device tree. Some GPIO settings are needed for
> the correct pin functions.

Patch 1/1 and the .dtsi portion of patch 2/2 look fine; I can apply
those after 3.14's merge window closes.

However, I don't think I can apply the change to bcm2835-rpi-b.dts in
this patch; those pins are used for the board ID strapping on rev 1
boards, and even on rev 2 boards, they're simply routed to a generic
header, rather than being dedicated for I2S usage. That part of the
patch would be better kept locally in your own kernel tree. Perhaps if
DT overlays ever take off, we can publish it as part of an I2S-specific
overlay.

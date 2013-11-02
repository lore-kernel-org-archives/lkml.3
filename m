Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab3KBNPC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 09:15:02 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54553 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3KBNO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 09:14:58 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Matt Porter <matt.porter@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v2 1/9] phy: add phy_get_bus_width()/phy_set_bus_width() calls
Date: Sat, 02 Nov 2013 14:14:59 +0100
Message-ID: <2395941.Lp2U7sdS37@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.6-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1383335158-19730-2-git-send-email-matt.porter@linaro.org>
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org> <1383335158-19730-2-git-send-email-matt.porter@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Friday 01 of November 2013 15:45:50 Matt Porter wrote:
> This adds a pair of APIs that allows the generic PHY subsystem to
> provide information on the PHY bus width. The PHY provider driver may
> use phy_set_bus_width() to set the bus width that the PHY supports.
> The controller driver may then use phy_get_bus_width() to fetch the
> PHY bus width in order to properly configure the controller.

I somehow does not like this. If we take this path for any further 
properties that we may need, we will end up with a lot of consumer 
specific properties stored in a PHY object having their own accessor 
functions.

Since this is just an integration detail, what about simply adding this as 
a property in device tree node of the OTG controller (and pdata if 
considering non-DT support)?

Another option would be some framework for retrieving arbitrary properties 
from the PHY, but I'm not really sure there is a need for such.

Best regards,
Tomasz


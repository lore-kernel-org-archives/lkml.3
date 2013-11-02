Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3KBRRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 13:17:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60196 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab3KBRRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 13:17:44 -0400
Message-ID: <52753387.5030202@ti.com>
Date: Sat, 2 Nov 2013 22:46:55 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Matt Porter <matt.porter@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v2 1/9] phy: add phy_get_bus_width()/phy_set_bus_width()
 calls
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org> <1383335158-19730-2-git-send-email-matt.porter@linaro.org> <2395941.Lp2U7sdS37@flatron>
In-Reply-To: <2395941.Lp2U7sdS37@flatron>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Saturday 02 November 2013 06:44 PM, Tomasz Figa wrote:
> Hi Matt,
>
> On Friday 01 of November 2013 15:45:50 Matt Porter wrote:
>> This adds a pair of APIs that allows the generic PHY subsystem to
>> provide information on the PHY bus width. The PHY provider driver may
>> use phy_set_bus_width() to set the bus width that the PHY supports.
>> The controller driver may then use phy_get_bus_width() to fetch the
>> PHY bus width in order to properly configure the controller.
>
> I somehow does not like this. If we take this path for any further
> properties that we may need, we will end up with a lot of consumer
> specific properties stored in a PHY object having their own accessor
> functions.

Only after all of us feel that a property is *generic* enough, we allow 
it to be added in the PHY object.
>
> Since this is just an integration detail, what about simply adding this as
> a property in device tree node of the OTG controller (and pdata if
> considering non-DT support)?

We already had a discussion about this and the dt maintainers suggested 
the property should be in the PHY. [1]

[1] ->  http://www.spinics.net/lists/devicetree/msg08851.html

Thanks
Kishon

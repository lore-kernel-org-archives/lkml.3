Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab3A2Piq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:38:46 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52445 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab3A2Pin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:38:43 -0500
Message-ID: <5107EC56.2000703@openwrt.org>
Date: Tue, 29 Jan 2013 16:35:50 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: davem@davemloft.net, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] net: mvmdio: unmap base register address at driver
 removal
References: <1359473048-26551-1-git-send-email-florian@openwrt.org> <1359473048-26551-2-git-send-email-florian@openwrt.org> <20130129163242.1df2caf5@skate>
In-Reply-To: <20130129163242.1df2caf5@skate>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 04:32 PM, Thomas Petazzoni wrote:
> Dear Florian Fainelli,
>
> On Tue, 29 Jan 2013 16:24:04 +0100, Florian Fainelli wrote:
>> Fix the driver remove callback to unmap the base register address and
>> not leak this mapping after the driver has been removed.
>>
>> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> What about using devm_request_and_ioremap() instead, in order to get
> automatic unmap on error and in the ->remove() path?

Right now, you are using of_iomap() which eases the task of fetching the 
resource and getting an ioremap cookie, which I why I kept that.

>
> But maybe it won't work because this memory range is claimed both by
> the MDIO driver and the Ethernet driver itself. In that case, you could
> use devm_ioremap().
Then we would loose the facility of of_iomap(), but fair enough, it can 
be inserted as a patch in this serie.

Thanks
--
Florian

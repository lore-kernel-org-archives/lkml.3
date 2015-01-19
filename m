Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbbASV6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:58:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56632 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbbASV6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:58:10 -0500
Message-ID: <3ad19b16fe5c58612479f70c052d0045.squirrel@www.codeaurora.org>
In-Reply-To: <2318041.V2OJAPu7gC@wuerfel>
References: <1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
    <5550127.3sXOcCISZN@wuerfel>
    <bca0eaf2183036ff6a913daea6e09ad9.squirrel@www.codeaurora.org>
    <2318041.V2OJAPu7gC@wuerfel>
Date: Mon, 19 Jan 2015 21:58:09 -0000
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
From: wstephen@codeaurora.org
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: wstephen@codeaurora.org, jcliburn@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thursday 15 January 2015 08:12:51 wstephen@codeaurora.org wrote:
>>
>> The nss-gmac driver is for the internal GMAC IP in the Qualcomm IPQ806x
>> SoC. There are 2 ARM cores and 2 NSS cores inside the IPQ806x SoC. The
>> main purpose of these NSS cores is to offload the networking stack from
>> the ARM cores to achieve high performance at routing/ipsec..etc without
>> exhausting the ARM core CPU cycles. There is another nss-drv driver for
>> the NSS cores.
>
> I see.
>
>> The nss-gmac driver is designed to work standalone or with the nss-drv
>> driver so the switchable data plane overlay was implemented. When it
>> worked standalone, the data plane is running on the ARM core as a
>> standard
>> networking driver.
>
> How do you decide which way it gets used on a particular system?
>

By default the GMAC driver uses a native (Host ARM CPU) based data plane. 
If the configuration loads the offload nss-drv driver, the offload driver
registers an overlay with the GMAC.

>> The nss-drv driver can take over the data plane and
>> offload it to the NSS cores. The STMicro stmmac driver does not have
>> this
>> kind of overlay design so is not suitable for IPQ806x. This is why we
>> don't based on the stmmac driver
>
> Which kind of offload is implemented specifically? 'data plane' sounds
> fairly generic and could mean anything, and the code isn't readable enough
> in its current form for me to find out.

The Network Subsystem (NSS core) provides a GMAC pass-through until it is
given a rule to offload work.  Once a rule is given, it is capable of
performing: bridging, IPv4 NAT/FWD, IPv6 NAT/FWD, IPSec, LAG, and other
protocols.
>
> 	Arnd
>

Hope this clarify your question!

Thanks,
Stephen



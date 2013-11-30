Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3K3QT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 11:19:59 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:35549 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3K3QTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 11:19:45 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Sat, 30 Nov 2013 17:24:14 +0100
From: Stefan Agner <stefan@agner.ch>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        sameo@linux.intel.com, dev@lynxeye.de, mark.rutland@arm.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: tegra: set SM2 voltage correct
In-Reply-To: <1385632196.5838.4.camel@weser.hi.pengutronix.de>
References: <cover.1385508112.git.stefan@agner.ch>
 <c9ceead9e3df77b5a33ad654db23c241cd624096.1385508112.git.stefan@agner.ch>
 <5296281C.1060403@wwwdotorg.org>
 <1385632196.5838.4.camel@weser.hi.pengutronix.de>
Message-ID: <ab16891b4a6bcfbb1854aa766e4926a7@agner.ch>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2013-11-28 10:49, schrieb Lucas Stach:
> Am Mittwoch, den 27.11.2013, 10:13 -0700 schrieb Stephen Warren:
>> On 11/26/2013 04:45 PM, Stefan Agner wrote:
>> > Set the requested SM2 voltage to the correct value of 1.8V. The value
>> > before used to work on TPS658623 since the driver applied a wrong
>> > voltage table too. However, the TPS658643 used on newer devices uses
>> > yet another voltage table and those broke that compatibility. The
>> > regulator driver now has the correct voltage table for both regulator
>> > versions and those the correct voltage can be used in this device
>> > tree.
>>
>> One thing you haven't called out explicitly here is that this series is
>> an incompatible change to the DT, since the old buggy driver used to
>> allow old buggy DT content to accidentally work.
>>
> The current (wrong and potentially dangerous) DT content only worked on
> the engineering sample models. So this change definitely does improve
> the situation, even with the risk of breaking a small fraction of
> working boards.
On the released modules, the current value ends in a freeze during
boot-up (since the wrong voltage table results in a too low voltage).

When I use 1.8V in the device tree, the old drivers refuses to set any
voltage. The regulators default/bootloader settings work then better
than the wrongfully applied values (tested on a new device). The probe
just fails:

[    0.243864] tps6586x-regulator tps6586x-regulator: failed to register
regulator REG-SM_2
[    0.244317] tps6586x-regulator: probe of tps6586x-regulator failed
with error -22

So, for newer modules, the incompatible 1.8V DT results in a successful
boot. Since we don't have a regulator driver at all, likely other things
are broken at that situation...

--
Stefan

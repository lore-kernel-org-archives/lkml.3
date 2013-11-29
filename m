Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3K2JFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:05:10 -0500
Received: from plane.gmane.org ([80.91.229.3]:55011 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab3K2JFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:05:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Kai Poggensee <kai.poggensee@avionic-design.de>
Subject: Re: [PATCH 0/3] regulator: tps6586x: add version detection and voltage
 tables
Date: Fri, 29 Nov 2013 09:20:37 +0100
Message-ID: <52984E55.10804@avionic-design.de>
References: <cover.1385508112.git.stefan@agner.ch> <20131128081351.GA26502@ulmo.nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Gmane-NNTP-Posting-Host: p5b3c0a5d.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
In-Reply-To: <20131128081351.GA26502@ulmo.nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.11.2013 09:13, Thierry Reding wrote:
> On Wed, Nov 27, 2013 at 12:45:42AM +0100, Stefan Agner wrote:
>> This patchset adds version detection for the tps6586x mfd family. This is
>> required because some regulator versions use different voltage tables. The
>> regulator driver now uses the right voltage table according to the
>> version.
>> 
>> The required voltage for the SM2 converter on the Colibri T20 is 1.8V,
>> however, the device tree states 3.7V right now. Newer versions (>=V1.2) of
>> the Colibri T20 module use the TPS658643, whereas old ones (<V1.2) use the
>> TPS658623. Both of them have a different voltage table for SM2. The
>> current device tree contains a voltage which results in 1.8V for the older
>> TPS658623. Since the regulator driver has correct voltage tables for both
>> regulator versions now, we can request the correct 1.8V from the device
>> tree.
>> 
>> Tested on Colibri T20 V1.1 and V1.2.
>> 
>> Stefan Agner (3):
>>   mfd: tps6586x: add version detection
>>   regulator: tps6586x: add voltage table for tps658643
>>   ARM: tegra: set SM2 voltage correct
>> 
>>  arch/arm/boot/dts/tegra20-colibri-512.dtsi |  4 +-
>>  drivers/mfd/tps6586x.c                     | 41 +++++++++++--
>>  drivers/regulator/tps6586x-regulator.c     | 97 ++++++++++++++++++++----------
>>  include/linux/mfd/tps6586x.h               |  9 +++
>>  4 files changed, 110 insertions(+), 41 deletions(-)
> 
> Adding Kai Poggensee on Cc. There was a variant of the Tamonten board
> with one of these versions of the chip (or maybe it was even yet another
> one).

Thanks Thierry,

we'll be more than happy to support testing once the
re-spun patch is posted. However, we will probably
do so by back-porting to L4T 16.3.

For the records:
We are using TPS658621C on first variant of Tamonten
Tegra 2 COM (internally called 1373-111), we are using
TPS658640 on variant two (1373-121).

This second variant was created to be 100% compatible
with our TamontenNG Tegra 3 COM (basically omitting some
previously unused interfaces), using TPS658640 was an
opportunistic optimization.

Regards,
Kai


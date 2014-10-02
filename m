Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaJBPxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:53:50 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:54499 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaJBPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:53:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Oct 2014 17:53:37 +0200
From: Stefan Agner <stefan@agner.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, b35083@freescale.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: dts: vf500/vf610: support VF500 SoC
In-Reply-To: <8882221.sfQOLcQs3p@wuerfel>
References: <1412261724-11073-1-git-send-email-stefan@agner.ch>
 <8882221.sfQOLcQs3p@wuerfel>
Message-ID: <20f4e3a1932756c92443d380a7f42f56@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-10-02 17:28, schrieb Arnd Bergmann:
> On Thursday 02 October 2014 16:55:23 Stefan Agner wrote:
>> The VF500 is essentially the same SoC, but with only one core and
>> without L1 cache. The VF610 is therefore a superset of the VF500.
>> Move allmost all periperals to vf500.dtsi which is then included
>> and enhanced by vf610.dtsi.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>> Somehow using -M -B switches create a unapplyable patch, hence I
>> generated one without those options. Sorry about that.
>>
>>  arch/arm/boot/dts/vf500.dtsi | 498 ++++++++++++++++++++++++++++++++++++++++++
>>  arch/arm/boot/dts/vf610.dtsi | 507 +------------------------------------------
>>  2 files changed, 510 insertions(+), 495 deletions(-)
>>  create mode 100644 arch/arm/boot/dts/vf500.dtsi
> 
> I think it would be better to create one extra file that contains the common
> parts and is included by both vf500 and vf610.
> 

I also thought about that. But when looking at the product variants, its
clear that VF500 really contains only features, which are part of all
other Vybrids (VF3xx series excluded, but these series is not really
suitable for Linux due to lack of external memory). So vf500.dtsi would
always be a oneliner (#include <vf.dtsi>).

Also I disliked this idea because of the somewhat unclear naming
(vf.dtsi? vfxxx.dtsi?)

--
Stefan

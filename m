Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbbAHSlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:41:14 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52974 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752022AbbAHSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:41:12 -0500
Date: Thu, 8 Jan 2015 18:40:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Message-ID: <20150108184059.GZ12302@n2100.arm.linux.org.uk>
References: <20141030120127.GC32589@arm.com>
 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
 <20141030135749.GE32589@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
 <20141113235322.GC4042@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103E010D1829B@CNBJMBX05.corpusers.net>
 <20141114095812.GG4042@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103E688B313C6@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313C6@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 10:38:58AM +0800, Wang, Yalin wrote:
> Joe has submitted patches to maintainers,
> So we need wait for them to be accepted .

I ran these patches through my autobuilder, and while most builds didn't
seem to be a problem, the randconfigs found errors:

/tmp/ccbiuDjS.s:137: Error: selected processor does not support ARM mode `rbit r3,r2'
/tmp/ccbiuDjS.s:145: Error: selected processor does not support ARM mode `rbit r0,r1'
make[4]: *** [drivers/iio/amplifiers/ad8366.o] Error 1

/tmp/ccFhnoO3.s:6789: Error: selected processor does not support ARM mode `rbit r2,r2'
make[4]: *** [drivers/mtd/devices/docg3.o] Error 1

/tmp/cckMf2pp.s:239: Error: selected processor does not support ARM mode `rbit ip,ip'
/tmp/cckMf2pp.s:241: Error: selected processor does not support ARM mode `rbit r2,r2'
/tmp/cckMf2pp.s:248: Error: selected processor does not support ARM mode `rbit lr,lr'
/tmp/cckMf2pp.s:250: Error: selected processor does not support ARM mode `rbit r3,r3'
make[5]: *** [drivers/video/fbdev/nvidia/nvidia.o] Error 1

/tmp/ccTgULsO.s:1151: Error: selected processor does not support ARM mode `rbit r1,r1'
/tmp/ccTgULsO.s:1158: Error: selected processor does not support ARM mode `rbit r0,r0'
/tmp/ccTgULsO.s:1164: Error: selected processor does not support ARM mode `rbit ip,ip'
/tmp/ccTgULsO.s:1166: Error: selected processor does not support ARM mode `rbit r3,r3'
/tmp/ccTgULsO.s:1227: Error: selected processor does not support ARM mode `rbit r5,r5'
/tmp/ccTgULsO.s:1229: Error: selected processor does not support ARM mode `rbit lr,lr'
/tmp/ccTgULsO.s:1236: Error: selected processor does not support ARM mode `rbit r0,r0'
/tmp/ccTgULsO.s:1238: Error: selected processor does not support ARM mode `rbit r3,r3'
make[5]: *** [drivers/video/fbdev/nvidia/nv_accel.o] Error 1

The root cause is that the kernel being built is supposed to support
both ARMv7 and ARMv6K CPUs.  However, "rbit" is only available on
ARMv6T2 (thumb2) and ARMv7, and not plain ARMv6 or ARMv6K CPUs.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

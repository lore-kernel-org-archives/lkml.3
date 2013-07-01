Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3GASSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:18:47 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.106]:12930 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856Ab3GASSq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:18:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1372702720!7046773!13
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mark Brown <broonie@kernel.org>, Ryan Mallon <rmallon@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "mika.westerberg@iki.fi" <mika.westerberg@iki.fi>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Date: Mon, 1 Jul 2013 13:17:22 -0500
Subject: RE: [PATCH 1/8] spi: spi-ep93xx: use read,write instead of __raw_*
 variants
Thread-Topic: [PATCH 1/8] spi: spi-ep93xx: use read,write instead of __raw_*
 variants
Thread-Index: Ac52SdqNfF8cE6s4RuWw/PrsZQtZDQAPS7bQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC38FFBA@AUSP01VMBX24.collaborationhost.net>
References: <201306281142.36525.hartleys@visionengravers.com>
 <51CE18FD.8010806@gmail.com> <20130701105750.GI27646@sirena.org.uk>
In-Reply-To: <20130701105750.GI27646@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 01, 2013 3:58 AM, Mark Brown wrote:
> On Sat, Jun 29, 2013 at 09:15:09AM +1000, Ryan Mallon wrote:
>> On 29/06/13 04:42, H Hartley Sweeten wrote:
>
>>> -static inline u8
>>> -ep93xx_spi_read_u8(const struct ep93xx_spi *spi, u16 reg)
>>> -{
>>> -	return __raw_readb(spi->regs_base + reg);
>>> -}
>
>> Is there a particular reason to drop these functions? It's basically just
>> bike-shedding, but they can make the code more readable at very little
>> cost. Even dropping the inline (which is preferred nowdays) the compiler
>> will still inline these, and it would also make this patch much smaller
>> to keep them.
>
> I tend to agree, it's much more normal to have the base + reg in a
> function than not.

OK. I will redo this one to just remove the __raw_.

Regards,
Hartley


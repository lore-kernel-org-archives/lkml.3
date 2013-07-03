Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964853Ab3GCVNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:13:19 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.108]:45653 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756264Ab3GCVNR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:13:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1372885995!7298567!1
X-Originating-IP: [199.119.192.77]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mark Brown <broonie@kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        Ryan Mallon <rmallon@gmail.com>,
        "mika.westerberg@iki.fi" <mika.westerberg@iki.fi>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Date: Wed, 3 Jul 2013 16:12:39 -0500
Subject: RE: [PATCH v2 05/11] spi: spi-ep93xx: use devm_clk_get()
Thread-Topic: [PATCH v2 05/11] spi: spi-ep93xx: use devm_clk_get()
Thread-Index: Ac54GidSSraY9Zz7QqaacZr9NK6VCAAFgi1w
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC39039F@AUSP01VMBX24.collaborationhost.net>
References: <201307021008.22347.hartleys@visionengravers.com>
 <20130703182125.GZ27646@sirena.org.uk>
In-Reply-To: <20130703182125.GZ27646@sirena.org.uk>
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

On Wednesday, July 03, 2013 11:21 AM, Mark Brown wrote:
> On Tue, Jul 02, 2013 at 10:08:21AM -0700, H Hartley Sweeten wrote:
>> Use devm_clk_get() so that the clk_put() happens automatically when
>> the last reference to this driver is dropped.
>
> This doesn't apply against current code - always submit against the
> relevant development tree, in this case topic/ep93xx.  I've applied it
> with a manual fixup.

Hello Mark,

It appears your topic/ep93xx branch is missing this:

commit 24778be20f87d5aadb19624fc768b3159fa43efc
Author: Stephen Warren <swarren@wwwdotorg.org>
Date:   Tue May 21 20:36:35 2013 -0600

    spi: convert drivers to use bits_per_word_mask

This commit is in linux-next which is what the patch series was based on.
I'm not sure what branch you applied that patch to.

If you need to drop my previous patches that you applied to topic/ep93xx
in order to sync things up please let me know how to proceed. There are
four more patches pending for spi-ep93xx to finish the cleanup and convert
it to the SPI queued driver infrastructure.

These are the relevant commits in topic/spi-ep93xx:

kernel / pub/scm/linux/kernel/git/broonie/spi / topic/ep93xx / drivers / spi / spi-ep93xx.c

3051c43  spi: spi-ep93xx: use devm_clk_get() by H Hartley Sweeten - 28 hours ago topic/ep93xx
e5ae625  spi: spi-ep93xx: remove 'dss' from per chip private data by H Hartley Sweeten - 28 hours ago
4af59ef  spi: spi-ep93xx: remove dev_err() for kzalloc() failure by H Hartley Sweeten - 28 hours ago
8b9d957  spi: spi-ep93xx: get platform resources early in (*probe) by H Hartley Sweeten - 28 hours ago
c6b7f14  spi: spi-ep93xx: remove bits_per_word() helper by H Hartley Sweeten - 28 hours ago
75c7444  spi: spi-ep93xx: use read,write instead of __raw_* variants by H Hartley Sweeten - 28 hours ago
eb41eeb  spi: spi-ep93xx: always handle transfer specific settings by H Hartley Sweeten - 5 days ago

Sorry about the trouble. I don't have your tree pulled so I was starting
from linux-next under the assumption that it was current to your tree.

Regards,
Hartley


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaAODrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 22:47:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:41871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaAODrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 22:47:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,660,1384329600"; 
   d="scan'208";a="438995632"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "ethan.kernel@gmail.com" <ethan.kernel@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro and
 cleanup const 63
Thread-Topic: [PATCH 1/2 v2] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro and
 cleanup const 63
Thread-Index: AQHPEaRhaapK9cvKwkyRlUDF4zwoyA==
Date: Wed, 15 Jan 2014 03:46:32 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B7312CEE1@ORSMSX101.amr.corp.intel.com>
References: <1387901568-1762-1-git-send-email-ethan.kernel@gmail.com>
 <1388134966.2183.144.camel@jtkirshe-mobl>
In-Reply-To: <1388134966.2183.144.camel@jtkirshe-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0F3lGLU005990

On Fri, 2013-12-27 at 01:02 -0800, Jeff Kirsher wrote:
> On Wed, 2013-12-25 at 00:12 +0800, Ethan Zhao wrote:
> > Because ixgbe driver limit the max number of VF functions could be
> > enabled
> > to 63, so define one macro IXGBE_MAX_VFS_DRV_LIMIT and cleanup the
> > const 63
> > in code.
> > 
> > v2: fix a typo.
> > 
> > Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  | 4 ++--
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 5 +++--
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h | 5 +++++
> >  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> Added to my queue, thanks Ethan!

Hi Ethan,

Did Jeff contact you about this failing to compile?  I'm currently
providing vacation covering for him and we found this was failing to
compile just before he left.  We captured the failure in our notes for
this but there is no comment on if you were contacted or not.

Regardless, when I apply this patch (with or without 2-2) we get the
following error on a compilation attempt: Here's the error:
--------------------------------------------------------
Here's the error:
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c: In function
"ixgbe_sw_init":
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:5033: error: stray "\357"
in program
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:5033: error: stray "\274"
in program
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:5033: error: stray "\215"
in program
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:5033: error: expected ")"
before numeric constant
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c: In function
"ixgbe_probe":
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:7977: error: stray "\357"
in program
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:7977: error: stray "\274"
in program
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:7977: error: stray "\215"
in program
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:7977: error: expected ")"
before numeric constant
make[5]: *** [drivers/net/ethernet/intel/ixgbe/ixgbe_main.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [drivers/net/ethernet/intel/ixgbe] Error 2
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [drivers/net/ethernet/intel] Error 2
make[2]: *** [drivers/net/ethernet] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2
--------------------------------------------------------

Thanks,
Aaron

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

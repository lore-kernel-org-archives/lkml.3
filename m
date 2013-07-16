Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab3GPR7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:59:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:24933 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933303Ab3GPR7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:59:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,678,1367996400"; 
   d="scan'208";a="371291002"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>
CC: David Lang <david@lang.hm>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: RE: [Ksummit-2013-discuss] When to push bug fixes to mainline
Thread-Topic: [Ksummit-2013-discuss] When to push bug fixes to mainline
Thread-Index: AQHOfpnchIxhw+hMikmzCKg7FbZqFplg9Z2AgAZsFwCAAJzZgIAABUkA//+Wl4A=
Date: Tue, 16 Jul 2013 17:58:58 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com>
References: <20130711214830.611455274@linuxfoundation.org>
	<20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu>
	<alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
	<s5hwqoqv4oo.wl%tiwai@suse.de> <20130716165933.GU22506@sirena.org.uk>
In-Reply-To: <20130716165933.GU22506@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Maybe some QA period before the release might help, but who would
>> care?  (Especially under the situation where everybody has own x.y
>> stable tree?)
>
> Hopefully people tracking the upstream stable trees would be throwing
> any pre-release stuff into their QA processes before it was officially
> released upstream, though I'd not count on it.

Linux testing is (realistically) done by inflicting changes on gradually wider
sets of end users.

We go through these stages (possibly a couple of extra steps where maintainer trees
are nested)
1) Author of a patch tests on their own machine (and perhaps a few others)
2) Patch is posted. A few more people grab and test.
3) Patch is applied to a maintainer tree, which is slurped into linux-next.
    A few hundred brave folks now have this patch in their binary, but most extra testing
    is purely accidental. These users aren't running focused tests on the area touched
    by the patch.
4) Patch is pulled by Linus. Pretty large jump in the number of users running the code
    so we start to get good breadth of testing on different machines with different sets
    of CONFIG options under varying workloads.
5) Linus releases a final 3.x version - another substantial bump in the number of testers
    because there are lots of people who wait for "release" quality kernels.
6) Fedora, Ubuntu etc. use this 3.x kernel as basis for a release. Probably two or three
    orders of magnitude more users (but only a fraction of their problems are reported
    back to LKML).

Thus code does get more and more QA - the longer you wait before taking a patch the
lower the risk that it has some unintended side-effect or outright bug . But of course
you are vulnerable in this whole period to whatever issue the patch was actually
trying to fix. So you have a classic tradeoff.

-Tony

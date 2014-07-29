Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaG2UUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:20:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:8903 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaG2UUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:20:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,759,1400050800"; 
   d="scan'208";a="580818467"
From: "Brown, Aaron F" <aaron.f.brown@intel.com>
To: "rickard_strandqvist@spectrumdigital.se" 
	<rickard_strandqvist@spectrumdigital.se>
CC: "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Linux NICS <Linux-nics@isotope.jf.intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [E1000-devel] [PATCH] net: ethernet: intel: ixgbe:
 ixgbe_main.c: Cleaning up missing null-terminate in conjunction with strncpy
Thread-Topic: [E1000-devel] [PATCH] net: ethernet: intel: ixgbe:
 ixgbe_main.c: Cleaning up missing null-terminate in conjunction with strncpy
Thread-Index: AQHPq2qT1JRz8LTRikmZ324DUp5bpQ==
Date: Tue, 29 Jul 2014 20:20:44 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B73369BE0@ORSMSX104.amr.corp.intel.com>
References: <1406384676-2606-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140728083935.6f4b77c1@samsung-9>
 <CAFo99gacYur41ZPng3v4KUq_6C5vY6hTrXz1fsCJnCGHY5_i0A@mail.gmail.com>
In-Reply-To: <CAFo99gacYur41ZPng3v4KUq_6C5vY6hTrXz1fsCJnCGHY5_i0A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6TKKvwe027400

On Tue, 2014-07-29 at 14:15 +0200, Rickard Strandqvist wrote:
> Den 29 jul 2014 04:40 skrev "Stephen Hemminger" <stephen@networkplumber.org
> >:
> >
> > On Sat, 26 Jul 2014 16:24:36 +0200
> > Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
> >
> > > Replacing strncpy with strlcpy to avoid strings that lacks null
> terminate.
> > >
> > > Signed-off-by: Rickard Strandqvist <
> rickard_strandqvist@spectrumdigital.se>
> > > ---
> >                            hw->mac.type, hw->phy.type, hw->phy.sfp_type,
> >
> > This patch doesn't change anything.
> > Netdev is already zeroed when allocated therefore doing strncpy()
> guarantees
> > it will be null terminated.
> 
> Hi Stephen
> 
> It's not clear that alloc_etherdev_mq() will zero the memory area:
> 
<snip>

Thanks Rickard, given strncpy to strlcpy gets suggested by static code
generators this will probably come up again even if it results in no
real change.  I (covering for Jeff Kirsher) went ahead and added it to
our internal tree.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaAOWiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:38:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:64260 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbaAOWh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:37:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,665,1384329600"; 
   d="scan'208";a="467321541"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Ian Munsie <imunsie@au1.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: manual merge of the akpm-current tree with the
 char-misc tree
Thread-Topic: linux-next: manual merge of the akpm-current tree with the
 char-misc tree
Thread-Index: AQHPEORMLVGycDyIa0SJpsMaYYpbFJqD4+FggAEDIgCAAIAukA==
Date: Wed, 15 Jan 2014 22:36:40 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF462B0@HASMSX106.ger.corp.intel.com>
References: <20140114155104.0ab2772aaa909e49bc89cd61@canb.auug.org.au>
 <5B8DA87D05A7694D9FA63FD143655C1B1AF42F69@HASMSX106.ger.corp.intel.com>
 <1389750036-sup-8437@delenn.ozlabs.ibm.com>
In-Reply-To: <1389750036-sup-8437@delenn.ozlabs.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0FMcDYQ013061



> -----Original Message-----
> From: Ian Munsie [mailto:imunsie@au1.ibm.com]
> Sent: Wednesday, January 15, 2014 03:58
> To: Winkler, Tomas
> Cc: Stephen Rothwell; Andrew Morton; Greg KH; Arnd Bergmann; linux-
> next@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: linux-next: manual merge of the akpm-current tree with the char-
> misc tree
> 
> Excerpts from Winkler, Tomas's message of 2014-01-14 19:31:26 +1100:
> > > Today's linux-next merge of the akpm-current tree got a conflict in
> > > drivers/misc/mei/init.c between commit 33ec08263147 ("mei: revamp mei
> > > reset state machine") from the char-misc tree and commit dd045dab2999
> > > ("drivers/misc/mei: ratelimit several error messages") from the
> > > akpm-current tree.
> > >
> > > I fixed it up (see below) and can carry the fix as necessary (no action
> > > is required).
> >
> > Can we just drop this rete limit stuff, I've never asked that.
> > Tomas
> 
> Hi Tomas,
> 
> So far the problem has only been a one off thing for me, so it would
> seem that whatever circumstances contributed to it are fairly rare, but
> unless the underlying issue has been identified and fixed I would not
> recommend just dropping the patch. When it did hit I ended up with my
> log files (kern.log, syslog & messages) filled up with 15GB of the
> messages mentioned in the commit message within minutes, until my hard
> drive ran out of space bringing my system down.
> 
> Even if the underlying issue is fixed I do not see any advantage in
> dropping the rate limit patch - it is an absolutely trivial* patch, and
> if anything I would expand it to cover all the error messages in the
> driver, not just the three involved in that particular case.
> 
> * It's essentially: sed 's/dev_\(warn\|err\)\>/dev_\1_ratelimited/g'
> 

I think the issue was fixed and also then number  of consecutive resets were limited to 3 so you should
not see this issue anymore in the next release, your patch just conflicted with these fixes. 
Still need to provide a simpler fix for the stable kernel.

Thanks
Tomas
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

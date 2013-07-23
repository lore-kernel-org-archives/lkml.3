Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3GWBRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:17:46 -0400
Received: from mx11.netapp.com ([216.240.18.76]:49662 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab3GWBRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:17:45 -0400
X-IronPort-AV: E=Sophos;i="4.89,723,1367996400"; 
   d="scan'208";a="35693180"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "rydberg@euromail.se" <rydberg@euromail.se>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
Thread-Topic: Linux 3.11-rc2
Thread-Index: AQHOh0Blpp07UcC9oUem7v4bwneG7Zlx67KA
Date: Tue, 23 Jul 2013 01:17:43 +0000
Message-ID: <1374542261.7972.66.camel@leira.trondhjem.org>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <20130723010437.GA570@polaris.bitmath.org>
In-Reply-To: <20130723010437.GA570@polaris.bitmath.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <49BFC5D96C98CE4A82BA3B4596C35993@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6N1Ho8F014833

On Tue, 2013-07-23 at 03:04 +0200, rydberg@euromail.se wrote:
> Hi Trond, Linus,
> 
> On Sun, Jul 21, 2013 at 12:53:10PM -0700, Linus Torvalds wrote:
> > So it's been another week, and -rc2 is out there.
> 
> This one happens to break nfs in a rather blunt-instrument fashion -
> creating files on a nfs4 partition [1] no longer works. Bisection
> yields this commit as the culprit:
> 
> commit b4a2cf76ab7c08628c62b2062dacefa496b59dfd
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Wed Jul 17 16:43:16 2013 -0400
> 
>     NFSv4: Fix a regression against the FreeBSD server
>     
>     Technically, the Linux client is allowed by the NFSv4 spec to send
>     3 word bitmaps as part of an OPEN request. However, this causes the
>     current FreeBSD server to return NFS4ERR_ATTRNOTSUPP errors.
>     
>     Fix the regression by making the Linux client use a 2 word bitmap unless
>     doing NFSv4.2 with labeled NFS.
>     
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> Reverting the patch returns things to normal.

- Can you please provide me with a binary tcpdump or wireshark dump that
demonstrates the problem?

- What server is this?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

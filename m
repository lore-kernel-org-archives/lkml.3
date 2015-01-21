Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbbAUMT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:19:29 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:45799 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAUMTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:19:19 -0500
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
To: David Laight <David.Laight@ACULAB.COM>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Choi, Sy Jong" <sy.jong.choi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hayato Momma <h-momma@ce.jp.nec.com>
Subject: RE: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast promiscuous
	mode control
Thread-Topic: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast
 promiscuous	mode control
Thread-Index: AQHQNRDn9S7pwXLQtk+h+o1qNyzJQpzJuLsg//955YCAATlDQIAAC34ggAADy1A=
Date: Wed, 21 Jan 2015 12:18:23 +0000
Message-ID: <7F861DC0615E0C47A872E6F3C5FCDDBD05E090FE@BPXM14GP.gisp.nec.co.jp>
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05E0734E@BPXM14GP.gisp.nec.co.jp>
	<874mrlu18e.fsf@nemi.mork.no>
 <7F861DC0615E0C47A872E6F3C5FCDDBD05E07B7C@BPXM14GP.gisp.nec.co.jp>
 <F6FB0E698C9B3143BDF729DF222866469129B7F5@ORSMSX110.amr.corp.intel.com>
 <7F861DC0615E0C47A872E6F3C5FCDDBD05E07F09@BPXM14GP.gisp.nec.co.jp>
 <F6FB0E698C9B3143BDF729DF222866469129B844@ORSMSX110.amr.corp.intel.com>
 <7F861DC0615E0C47A872E6F3C5FCDDBD05E08FF6@BPXM14GP.gisp.nec.co.jp>
 <063D6719AE5E284EB5DD2968C1650D6D1CAD01D6@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CAD01D6@AcuExch.aculab.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.205.5.123]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0LCJWEe019554

> Subject: RE: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast promiscuous mode control
> 
> From: Hiroshi Shimamoto
> > My concern is what is the real issue that VF multicast promiscuous mode can cause.
> > I think there is the 4k entries to filter multicast address, and the current ixgbe/ixgbevf
> > can turn all bits on from VM. That is almost same as enabling multicast promiscuous mode.
> > I mean that we can receive all multicast addresses by an onerous operation in untrusted VM.
> > I think we should clarify what is real security issue in this context.
> 
> If you are worried about passing un-enabled multicasts to users then
> what about doing a software hash of received multicasts and checking
> against an actual list of multicasts enabled for that hash entry.
> Under normal conditions there is likely to be only a single address to check.
> 
> It may (or may not) be best to use the same hash as any hashing hardware
> filter uses.

thanks for the comment. But I don't think that is the point.

I guess, introducing VF multicast promiscuous mode seems to add new privilege
to peek every multicast packet in VM and that doesn't look good.
On the other hand, I think that there has been the same privilege in the current
ixgbe/ixgbevf implementation already. Or I'm reading the code wrongly.
I'd like to clarify what is the issue of allowing to receive all multicast packets.

thanks,
Hiroshi

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbbAVTA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:00:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:52182 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbbAVTAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:00:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="443843805"
From: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
To: David Laight <David.Laight@ACULAB.COM>,
        Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
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
Thread-Index: AQHQNQsmhwpg0uFhykOk7liG8gdn8pzJslcQgACW3ID//3rhgIABNXsAgAAFKICAAAYCgP//+z4QgAFtoQCAAAET8A==
Date: Thu, 22 Jan 2015 19:00:51 +0000
Message-ID: <F6FB0E698C9B3143BDF729DF222866469129BFFD@ORSMSX110.amr.corp.intel.com>
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05E0734E@BPXM14GP.gisp.nec.co.jp>
	<874mrlu18e.fsf@nemi.mork.no>
 <7F861DC0615E0C47A872E6F3C5FCDDBD05E07B7C@BPXM14GP.gisp.nec.co.jp>
 <F6FB0E698C9B3143BDF729DF222866469129B7F5@ORSMSX110.amr.corp.intel.com>
 <7F861DC0615E0C47A872E6F3C5FCDDBD05E07F09@BPXM14GP.gisp.nec.co.jp>
 <F6FB0E698C9B3143BDF729DF222866469129B844@ORSMSX110.amr.corp.intel.com>
 <7F861DC0615E0C47A872E6F3C5FCDDBD05E08FF6@BPXM14GP.gisp.nec.co.jp>
 <063D6719AE5E284EB5DD2968C1650D6D1CAD01D6@AcuExch.aculab.com>
 <7F861DC0615E0C47A872E6F3C5FCDDBD05E090FE@BPXM14GP.gisp.nec.co.jp>
 <F6FB0E698C9B3143BDF729DF222866469129BC03@ORSMSX110.amr.corp.intel.com>
 <063D6719AE5E284EB5DD2968C1650D6D1CAD0C8A@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CAD0C8A@AcuExch.aculab.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0MJ11v6028928

> -----Original Message-----
> From: David Laight [mailto:David.Laight@ACULAB.COM]
> Sent: Thursday, January 22, 2015 1:50 AM
> To: Skidmore, Donald C; Hiroshi Shimamoto; BjÃ¸rn Mork
> Cc: e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org; Choi, Sy
> Jong; linux-kernel@vger.kernel.org; Hayato Momma
> Subject: RE: [E1000-devel] [PATCH 1/2] if_link: Add VF multicast promiscuous
> mode control
> 
> From: Skidmore, Donald C
> > > > From: Hiroshi Shimamoto
> > > > > My concern is what is the real issue that VF multicast
> > > > > promiscuous mode
> > > can cause.
> > > > > I think there is the 4k entries to filter multicast address, and
> > > > > the current ixgbe/ixgbevf can turn all bits on from VM. That is
> > > > > almost same as
> > > enabling multicast promiscuous mode.
> > > > > I mean that we can receive all multicast addresses by an onerous
> > > operation in untrusted VM.
> > > > > I think we should clarify what is real security issue in this context.
> > > >
> > > > If you are worried about passing un-enabled multicasts to users
> > > > then what about doing a software hash of received multicasts and
> > > > checking against an actual list of multicasts enabled for that hash entry.
> > > > Under normal conditions there is likely to be only a single address to
> check.
> > > >
> > > > It may (or may not) be best to use the same hash as any hashing
> > > > hardware filter uses.
> > >
> > > thanks for the comment. But I don't think that is the point.
> > >
> > > I guess, introducing VF multicast promiscuous mode seems to add new
> > > privilege to peek every multicast packet in VM and that doesn't look
> good.
> > > On the other hand, I think that there has been the same privilege in
> > > the current ixgbe/ixgbevf implementation already. Or I'm reading the
> > > code wrongly.
> > > I'd like to clarify what is the issue of allowing to receive all multicast
> packets.
> >
> > Allowing a VM to give itself the privilege of seeing every multicast
> > packet could be seen as a hole in VM isolation.
> > Now if the host system allows this policy I don't see this as an issue
> > as someone specifically allowed this to happen and then must not be
> concerned.
> > We could even log that it has occurred, which I believe your patch did do.
> > The issue is also further muddied, as you mentioned above, since some
> > of these multicast packets are leaking anyway (the HW currently uses a 12
> bit mask).
> > It's just that this change would greatly enlarge that hole from a
> > fraction to all multicast packets.
> 
> Why does it have anything to do with VM isolation?
> Isn't is just the same as if the VM were connected directly to the ethernet
> cable?
> 
> 	David

I do see your point. :)

My hang up is more related to: without the nob to enable it (off by default) we are letting one VF dictate policy for all the other VFs and the PF.  If one VF needs to be in promiscuous multicast so is everyone else.  Their stacks now needs to deal with all the extra multicast packets.  As you point out this might not be a direct concern for isolation in that the VM could have 'chosen' to join any Multicast group and seen this traffic.  My concern over isolation is one VF has chosen that all the other VM now have to see this multicast traffic.

This will effect performance as these packets will need to be replicated.  So once again my issue is a VF is making the policy decision that doing this is ok for the entire system.  That should be the PF's job.

Does this give you a better idea where my concerns lay?


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

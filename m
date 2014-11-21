Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbaKUJXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:23:01 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:40316 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaKUJW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:22:58 -0500
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        Hayato Momma <h-momma@ce.jp.nec.com>,
        "Choi, Sy Jong" <sy.jong.choi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] ixgbe: make VLAN filter conditional in SR-IOV case
Thread-Topic: [PATCH] ixgbe: make VLAN filter conditional in SR-IOV case
Thread-Index: AQHQBSp+Sb9IreHfDUu6grdxaM0I4JxqzluQ
Date: Fri, 21 Nov 2014 09:22:19 +0000
Message-ID: <7F861DC0615E0C47A872E6F3C5FCDDBD05DB6636@BPXM14GP.gisp.nec.co.jp>
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05D9D336@BPXM14GP.gisp.nec.co.jp>
 <1416533299.7215.17.camel@decadent.org.uk>
In-Reply-To: <1416533299.7215.17.camel@decadent.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAL9N97f016297

> Subject: Re: [PATCH] ixgbe: make VLAN filter conditional in SR-IOV case
> 
> On Thu, 2014-11-13 at 08:28 +0000, Hiroshi Shimamoto wrote:
> > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> >
> > Disable hardware VLAN filtering if netdev->features VLAN flag is dropped.
> >
> > In SR-IOV case, there is a use case which needs to disable VLAN filter.
> > For example, we need to make a network function with VF in virtualized
> > environment. That network function may be a software switch, a router
> > or etc. It means that that network function will be an end point which
> > terminates many VLANs.
> >
> > In the current implementation, VLAN filtering always be turned on and
> > VF can receive only 63 VLANs. It means that only 63 VLANs can be used
> > and it's not enough at all for building a virtual router.
> >
> > With this patch, if the user turns VLAN filtering off on the host, VF
> > can receive every VLAN packet.
> > The behavior is changed only if VLAN filtering is turned off by ethtool.
> [...]
> 
> What happens when VLAN filtering is turned back on and a VF uses too
> many VLANs?  It seems like that should either be prevented (you can't
> turn it back on) or the driver should log a message saying the VF is now
> broken.

that's reasonable.
Will submit additional patch to take care about that.

thanks,
Hiroshi

> 
> Ben.
> 
> --
> Ben Hutchings
> Beware of bugs in the above code;
> I have only proved it correct, not tried it. - Donald Knuth
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

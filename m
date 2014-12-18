Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaLUXCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 18:02:19 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:48126 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaLUXCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 18:02:16 -0500
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
To: Alexander Duyck <alexander.duyck@gmail.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Choi, Sy Jong" <sy.jong.choi@intel.com>,
        Hayato Momma <h-momma@ce.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [E1000-devel] [PATCH] ixgbe, ixgbevf: Add new mbox API to
 enable MC promiscuous mode
Thread-Topic: [E1000-devel] [PATCH] ixgbe, ixgbevf: Add new mbox API to
 enable MC promiscuous mode
Thread-Index: AQHQD+ngQGOefuMim0OG0YZMPBmEtJyAFDFggBFKsYCAA86AUA==
Date: Thu, 18 Dec 2014 09:47:54 +0000
Message-ID: <7F861DC0615E0C47A872E6F3C5FCDDBD05DE3610@BPXM14GP.gisp.nec.co.jp>
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05DBFDAD@BPXM14GP.gisp.nec.co.jp>
 <54809D57.9060804@gmail.com>  
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.205.5.123]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Subject: Re: [E1000-devel] [PATCH] ixgbe, ixgbevf: Add new mbox API to enable MC promiscuous mode
> > >
> > > On 11/27/2014 02:39 AM, Hiroshi Shimamoto wrote:
> > > > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> > > >
> > > > The limitation of the number of multicast address for VF is not enough
> > > > for the large scale server with SR-IOV feature.
> > > > IPv6 requires the multicast MAC address for each IP address to handle
> > > > the Neighbor Solicitation message.
> > > > We couldn't assign over 30 IPv6 addresses to a single VF interface.
> > > >
> > > > The easy way to solve this is enabling multicast promiscuous mode.
> > > > It is good to have a functionality to enable multicast promiscuous mode
> > > > for each VF from VF driver.
> > > >
> > > > This patch introduces the new mbox API, IXGBE_VF_SET_MC_PROMISC, to
> > > > enable/disable multicast promiscuous mode in VF. If multicast promiscuous
> > > > mode is enabled the VF can receive all multicast packets.
> > > >
> > > > With this patch, the ixgbevf driver automatically enable multicast
> > > > promiscuous mode when the number of multicast addresses is over than 30
> > > > if possible.
> > > >
> > > > This also bump the API version up to 1.2 to check whether the API,
> > > > IXGBE_VF_SET_MC_PROMISC is available.
> > > >
> > > > Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> > > > CC: Choi, Sy Jong <sy.jong.choi@intel.com>
> > > > Reviewed-by: Hayato Momma <h-momma@ce.jp.nec.com>
> > >
> > > This is a REALLY bad idea unless you plan to limit this to privileged VFs.
> > >
> > > I would recommend looking at adding an ndo operation to control this
> > > feature so that it could be disabled by default in the PF and only
> > > enabled on the host side if specifically requested.  Otherwise the

Do you think whether introducing ndo_set_vf_mc_promisc to control the multicast
promiscuous mode of VF from host is good to you?
If that's okay I'm fine to post the new patch.

We need the capability to use thousands IPv6 addresses in VF.
I think setting multicast promiscuous mode on is the easiest way to do it.

thanks,
Hiroshi

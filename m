Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaLELkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:40:20 -0500
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:65198 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLELkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:40:18 -0500
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
Thread-Index: AQHQD+ngQGOefuMim0OG0YZMPBmEtJyAFDFg
Date: Fri, 5 Dec 2014 11:39:30 +0000
Message-ID: <7F861DC0615E0C47A872E6F3C5FCDDBD05DCEB13@BPXM14GP.gisp.nec.co.jp>
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05DBFDAD@BPXM14GP.gisp.nec.co.jp>
 <54809D57.9060804@gmail.com>
In-Reply-To: <54809D57.9060804@gmail.com>
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

> Subject: Re: [E1000-devel] [PATCH] ixgbe, ixgbevf: Add new mbox API to enable MC promiscuous mode
> 
> On 11/27/2014 02:39 AM, Hiroshi Shimamoto wrote:
> > From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> >
> > The limitation of the number of multicast address for VF is not enough
> > for the large scale server with SR-IOV feature.
> > IPv6 requires the multicast MAC address for each IP address to handle
> > the Neighbor Solicitation message.
> > We couldn't assign over 30 IPv6 addresses to a single VF interface.
> >
> > The easy way to solve this is enabling multicast promiscuous mode.
> > It is good to have a functionality to enable multicast promiscuous mode
> > for each VF from VF driver.
> >
> > This patch introduces the new mbox API, IXGBE_VF_SET_MC_PROMISC, to
> > enable/disable multicast promiscuous mode in VF. If multicast promiscuous
> > mode is enabled the VF can receive all multicast packets.
> >
> > With this patch, the ixgbevf driver automatically enable multicast
> > promiscuous mode when the number of multicast addresses is over than 30
> > if possible.
> >
> > This also bump the API version up to 1.2 to check whether the API,
> > IXGBE_VF_SET_MC_PROMISC is available.
> >
> > Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> > CC: Choi, Sy Jong <sy.jong.choi@intel.com>
> > Reviewed-by: Hayato Momma <h-momma@ce.jp.nec.com>
> 
> This is a REALLY bad idea unless you plan to limit this to privileged VFs.
> 
> I would recommend looking at adding an ndo operation to control this
> feature so that it could be disabled by default in the PF and only
> enabled on the host side if specifically requested.  Otherwise the

Do you mean that PF driver should have the flag to enable or disable per VF
and disallow the request from VF?

> problem is I can easily see this leading security issues as the VFs
> might begin getting access to messages that they aren't supposed to.

OK, by the way, I think that the current ixgbe and ixgbevf implementation
has already such issue. The guest can add hash entry to receive MAC and it
can get every multicast MAC frame with the current mbox API.
Does your concern come from the easiness of doing that?

thanks,
Hiroshi

> 
> - Alex

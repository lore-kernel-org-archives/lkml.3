Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbaLDRny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:43:54 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34071 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751AbaLDRnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:43:53 -0500
Message-ID: <54809D57.9060804@gmail.com>
Date: Thu, 04 Dec 2014 09:43:51 -0800
From: Alexander Duyck <alexander.duyck@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Choi, Sy Jong" <sy.jong.choi@intel.com>,
        Hayato Momma <h-momma@ce.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [E1000-devel] [PATCH] ixgbe, ixgbevf: Add new mbox API to enable
 MC promiscuous mode
References: <7F861DC0615E0C47A872E6F3C5FCDDBD05DBFDAD@BPXM14GP.gisp.nec.co.jp>
In-Reply-To: <7F861DC0615E0C47A872E6F3C5FCDDBD05DBFDAD@BPXM14GP.gisp.nec.co.jp>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2014 02:39 AM, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> The limitation of the number of multicast address for VF is not enough
> for the large scale server with SR-IOV feature.
> IPv6 requires the multicast MAC address for each IP address to handle
> the Neighbor Solicitation message.
> We couldn't assign over 30 IPv6 addresses to a single VF interface.
>
> The easy way to solve this is enabling multicast promiscuous mode.
> It is good to have a functionality to enable multicast promiscuous mode
> for each VF from VF driver.
>
> This patch introduces the new mbox API, IXGBE_VF_SET_MC_PROMISC, to
> enable/disable multicast promiscuous mode in VF. If multicast promiscuous
> mode is enabled the VF can receive all multicast packets.
>
> With this patch, the ixgbevf driver automatically enable multicast
> promiscuous mode when the number of multicast addresses is over than 30
> if possible.
>
> This also bump the API version up to 1.2 to check whether the API,
> IXGBE_VF_SET_MC_PROMISC is available.
>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> CC: Choi, Sy Jong <sy.jong.choi@intel.com>
> Reviewed-by: Hayato Momma <h-momma@ce.jp.nec.com>

This is a REALLY bad idea unless you plan to limit this to privileged VFs.

I would recommend looking at adding an ndo operation to control this
feature so that it could be disabled by default in the PF and only
enabled on the host side if specifically requested.  Otherwise the
problem is I can easily see this leading security issues as the VFs
might begin getting access to messages that they aren't supposed to.

- Alex

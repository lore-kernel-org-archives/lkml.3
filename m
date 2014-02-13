Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaBMLf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:35:26 -0500
Received: from smtp.citrix.com ([66.165.176.89]:11833 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbaBMLfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:35:24 -0500
X-IronPort-AV: E=Sophos;i="4.95,838,1384300800"; 
   d="scan'208";a="102194539"
Message-ID: <1392291321.27366.17.camel@kazak.uk.xensource.com>
Subject: Re: [RFC 2/2] xen-netback: disable multicast and use a random hw
 MAC address
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "Wei Liu" <wei.liu2@citrix.com>, <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Feb 2014 11:35:21 +0000
In-Reply-To: <CAB=NE6WFDWW1faoCYJP9zh6rPPvET+dbHxjHnGkYXtRx6z2LOQ@mail.gmail.com>
References: <1392071391-13215-1-git-send-email-mcgrof@do-not-panic.com>
	 <1392071391-13215-3-git-send-email-mcgrof@do-not-panic.com>
	 <1392108205.22033.16.camel@dagon.hellion.org.uk>
	 <CAB=NE6Vu=khpj_3J7r-u8DFkhyC-RgLikNFtOU-WO7te_4HMCw@mail.gmail.com>
	 <1392203708.13563.50.camel@kazak.uk.xensource.com>
	 <CAB=NE6WFDWW1faoCYJP9zh6rPPvET+dbHxjHnGkYXtRx6z2LOQ@mail.gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 14:05 -0800, Luis R. Rodriguez wrote:
> > I meant the PV protocol extension which allows guests (netfront) to
> > register to receive multicast frames across the PV ring -- i.e. for
> > multicast to work from the guests PoV.
> 
> Not quite sure I understand, ipv6 works on guests so multicast works,
> so its unclear what you mean by multicast frames across the PV ring.
> Is there any code or or documents I can look at ?

xen/include/public/io/netif.h talks about 'feature-multicast-control'
and XEN_NETIF_EXTRA_TYPE_MCAST_{ADD,DEL}.

Looking at it now in the absence of those then flooding is the
default...

> > (maybe that was just an optimisation though and the default is to flood
> > everything, it was a long time ago)
> 
> From a networking perspective everything is being flooded as I've seen
> it so far.

... which is why it works ;-)

Ian.


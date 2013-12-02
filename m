Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3LBNEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:04:50 -0500
Received: from smtp.citrix.com ([66.165.176.89]:53888 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab3LBNEp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:04:45 -0500
X-IronPort-AV: E=Sophos;i="4.93,811,1378857600"; 
   d="scan'208";a="79683731"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: David Miller <davem@davemloft.net>, Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jonathan Davies" <Jonathan.Davies@citrix.com>
Subject: RE: [PATCH net-next] xen-netback: Fix pull size in
 checksum_setup_ip*
Thread-Topic: [PATCH net-next] xen-netback: Fix pull size in
 checksum_setup_ip*
Thread-Index: AQHO7TTHgTdp3C9YG0ynI7SpJxjY8Zo+NeEAgAKs18A=
Date: Mon, 2 Dec 2013 13:04:42 +0000
Message-ID: <9AAE0902D5BC7E449B7C8E4E778ABCD019C6C4@AMSPEX01CL01.citrite.net>
References: <1385751407-9365-1-git-send-email-zoltan.kiss@citrix.com>
 <20131130.161000.1050565138363035368.davem@davemloft.net>
In-Reply-To: <20131130.161000.1050565138363035368.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.80.2.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: 30 November 2013 21:10
> To: Zoltan Kiss
> Cc: Ian Campbell; Wei Liu; xen-devel@lists.xenproject.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jonathan Davies;
> Paul Durrant
> Subject: Re: [PATCH net-next] xen-netback: Fix pull size in
> checksum_setup_ip*
> 
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Fri, 29 Nov 2013 18:56:47 +0000
> 
> > Before checksum setup we need to make sure we have enough data in
> linear
> > buffer, so we do a pull if not. The calculation of the required data counts
> > with skb->network_header, which is the headroom size actually. This is not
> > necessary, and can cause unreasonable pulling. I've also removed
> > MAX_IPOPTLEN, as we only need the base header at that point.
> >
> > Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> 
> The net-next tree is no open, therefore it is not appropriate to submit
> patches targetting to that tree at this time.
> 
> I will make an explicit announcement on netdev when I have openned
> the net-next tree, so it will be clear exactly when you can submit
> patches targetting that tree again.
> 
> Thank you.

I think this patch should be for net rather than net-next anyway. Since it appears that maybe_pull_tail() has bigger problems I'll incorporate this fix as part of v4 of the fix for fragment detection.

  Paul

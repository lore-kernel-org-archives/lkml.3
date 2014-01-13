Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaAMJxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:53:09 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:10455 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaAMJxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:53:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,651,1384300800"; 
   d="scan'208";a="90110006"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jonathan Davies" <Jonathan.Davies@citrix.com>
Subject: RE: [PATCH net-next v3 8/9] xen-netback: Timeout packets in RX path
Thread-Topic: [PATCH net-next v3 8/9] xen-netback: Timeout packets in RX path
Thread-Index: AQHPDLl4Wu4tZBxeyUWvbT3V/hLkQ5p8HC/wgAWkCACAALChMA==
Date: Mon, 13 Jan 2014 09:53:00 +0000
Message-ID: <9AAE0902D5BC7E449B7C8E4E778ABCD0204455@AMSPEX01CL01.citrite.net>
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com>
 <1389139818-24458-9-git-send-email-zoltan.kiss@citrix.com>
 <52CDC45D.3050509@citrix.com>
 <9AAE0902D5BC7E449B7C8E4E778ABCD0200C2A@AMSPEX01CL01.citrite.net>
 <52D33138.4090903@citrix.com>
In-Reply-To: <52D33138.4090903@citrix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.80.2.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Zoltan Kiss
> Sent: 13 January 2014 00:20
> To: Paul Durrant; Ian Campbell; Wei Liu; xen-devel@lists.xenproject.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jonathan Davies
> Subject: Re: [PATCH net-next v3 8/9] xen-netback: Timeout packets in RX
> path
> 
> On 09/01/14 09:20, Paul Durrant wrote:
> >> We are adding the skb to vif->rx_queue even when
> >> xenvif_rx_ring_slots_available(vif, min_slots_needed) said there is no
> >> space for that. Or am I missing something? Paul?
> >>
> > That's correct. Part of the flow control improvement was to get rid of
> needless packet drops. For your purposes, you basically need to avoid using
> the queuing discipline and take packets into netback's vif->rx_queue
> regardless of the state of the shared ring so that you can drop them if they
> get beyond a certain age. So, perhaps you should never stop the netif
> queue, place an upper limit on vif->rx_queue (either packet or byte count)
> and drop when that is exceeded (i.e. mimicking pfifo or bfifo internally).
> >
> How about this:
> - when the timer fires first we wake up the thread an tell it to drop
> all the packets in rx_queue
> - start_xmit then can drain the qdisc queue into the device queue
> - additionally, the RX thread should stop that timer when it was able to
> do some work
> 

Yes, you could do it that way.

  Paul

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbaDBH3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:29:41 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64217 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948AbaDBH3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:29:40 -0400
X-IronPort-AV: E=Sophos;i="4.97,778,1389744000"; 
   d="scan'208";a="117224367"
Message-ID: <1396423778.26869.61.camel@dagon.hellion.org.uk>
Subject: Re: [PATCH net-next v2 2/2] xen-netback: Grant copy the header
 instead of map and memcpy
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Paul Durrant <Paul.Durrant@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jonathan Davies" <Jonathan.Davies@citrix.com>
Date: Wed, 2 Apr 2014 08:29:38 +0100
In-Reply-To: <533B0BA7.6040607@citrix.com>
References: <1396278539-27639-1-git-send-email-zoltan.kiss@citrix.com>
	 <1396278539-27639-2-git-send-email-zoltan.kiss@citrix.com>
	 <9AAE0902D5BC7E449B7C8E4E778ABCD02B75F1@AMSPEX01CL01.citrite.net>
	 <533B0BA7.6040607@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 19:55 +0100, Zoltan Kiss wrote:
> >> @@ -1389,7 +1393,7 @@ static int xenvif_tx_submit(struct xenvif
> *vif)
> >>              txp = &vif->pending_tx_info[pending_idx].req;
> >>
> >>              /* Check the remap error code. */
> >> -            if (unlikely(xenvif_tx_check_gop(vif, skb, &gop_map)))
> {
> >> +            if (unlikely(xenvif_tx_check_gop(vif, skb, &gop_map,
> >> &gop_copy))) {
> >>                      netdev_dbg(vif->dev, "netback grant
> failed.\n");
> >
> > It could have been the copy that failed. You should probably change
> the error message.
> I've changed it to "netback grant op failed.\n"

Perhaps xenvif_tx_check_gop is in a position to log something more
specific about the failure? (maybe it already does, I didn't look).

Ian.



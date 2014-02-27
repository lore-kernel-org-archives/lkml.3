Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaB0Mnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:43:31 -0500
Received: from smtp.citrix.com ([66.165.176.89]:61188 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaB0Mn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:43:28 -0500
X-IronPort-AV: E=Sophos;i="4.97,554,1389744000"; 
   d="scan'208";a="106251949"
Date: Thu, 27 Feb 2014 12:43:27 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@schaman.hu>,
        Ian Campbell <Ian.Campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v5 4/9] xen-netback: Change RX path for mapped
 SKB fragments
Message-ID: <20140227124327.GD16241@zion.uk.xensource.com>
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>
 <1390253069-25507-5-git-send-email-zoltan.kiss@citrix.com>
 <1392745532.23084.65.camel@kazak.uk.xensource.com>
 <53093051.9040907@citrix.com>
 <530B4E05.4020900@schaman.hu>
 <530B606F.2070902@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <530B606F.2070902@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 03:08:31PM +0000, Zoltan Kiss wrote:
> On 24/02/14 13:49, Zoltan Kiss wrote:
> >On 22/02/14 23:18, Zoltan Kiss wrote:
> >>On 18/02/14 17:45, Ian Campbell wrote:
> >>>On Mon, 2014-01-20 at 21:24 +0000, Zoltan Kiss wrote:
> >>>
> >>>Re the Subject: change how? Perhaps "handle foreign mapped pages on the
> >>>guest RX path" would be clearer.
> >>Ok, I'll do that.
> >>
> >>>
> >>>>RX path need to know if the SKB fragments are stored on
> >>>>pages from another
> >>>>domain.
> >>>Does this not need to be done either before the mapping change
> >>>or at the
> >>>same time? -- otherwise you have a window of a couple of commits where
> >>>things are broken, breaking bisectability.
> >>I can move this to the beginning, to keep bisectability. I've
> >>put it here originally because none of these makes sense without
> >>the previous patches.
> >Well, I gave it a close look: to move this to the beginning as a
> >separate patch I would need to put move a lot of definitions from
> >the first patch to here (ubuf_to_vif helper,
> >xenvif_zerocopy_callback etc.). That would be the best from bisect
> >point of view, but from patch review point of view even worse than
> >now. So the only option I see is to merge this with the first 2
> >patches, so it will be even bigger.
> Actually I was stupid, we can move this patch earlier and introduce
> stubs for those 2 functions. But for the another two patches (#6 and
> #8) it's still true that we can't move them before, only merge them
> into the main, as they heavily rely on the main patch. #6 is
> necessary for Windows frontends, as they are keen to send too many
> slots. #8 is quite a rare case, happens only if a guest wedge or
> malicious, and sits on the packet.
> So my question is still up: do you prefer perfect bisectability or
> more segmented patches which are not that pain to review?
> 

What's the diff stat if you merge those patches?

> >And based on that principle, patch #6 and #8 should be merged
> >there as well, as they solve corner cases introduced by the grant
> >mapping.
> >I don't know how much the bisecting requirements are written in
> >stone. At this moment, all the separate patches compile, but after
> >#2 there are new problems solved in #4, #6 and #8. If someone
> >bisect in the middle of this range and run into these problems,
> >they could quite easily figure out what went wrong looking at the
> >adjacent patches. So I would recommend to keep this current order.
> >What's your opinion?
> >
> >Zoli

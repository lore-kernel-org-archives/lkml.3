Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3J2VVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:21:49 -0400
Received: from ja.ssi.bg ([178.16.129.10]:58885 "EHLO ja.home.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751929Ab3J2VVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:21:47 -0400
Date: Tue, 29 Oct 2013 23:21:24 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
X-X-Sender: ja@ja.home.ssi.bg
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
cc: Meelis Roos <mroos@linux.ee>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, steffen.klassert@secunet.com
Subject: Re: 3.12-rc7 regression - network panic from ipv6
In-Reply-To: <20131029210758.GA18323@order.stressinduktion.org>
Message-ID: <alpine.LFD.2.03.1310292310180.2045@ssi.bg>
References: <alpine.SOC.1.00.1310292221550.19416@math.ut.ee> <20131029210758.GA18323@order.stressinduktion.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Tue, 29 Oct 2013, Hannes Frederic Sowa wrote:

> On Tue, Oct 29, 2013 at 10:33:36PM +0200, Meelis Roos wrote:
> > Some bad news - in a system where 3.12-rc6 and earlier worked fine, 
> > 3.12-rc7 panics or hangs repeatedly with network traffic (torrent being 
> > good test). First there is BUG from ipv6 code, followed by panic.
> 
> Could you do a bisect on this? There seems to be one commit for this
> particular function _decode_session6:
> 
> commit bafd4bd4dcfa13145db7f951251eef3e10f8c278
> Author: Steffen Klassert <steffen.klassert@secunet.com>
> Date:   Mon Sep 9 10:38:38 2013 +0200
> 
>     xfrm: Decode sessions with output interface.
>     
>     The output interface matching does not work on forward
>     policy lookups, the output interface of the flowi is
>     always 0. Fix this by setting the output interface when
>     we decode the session.
> 
> Maybe try to just revert this change locally and try again?

	At first look this change can work only for
forwarding, for output the skb_dst is attached later
in icmpv6_push_pending_frames. May be a check for present
skb_dst is needed.

Regards

--
Julian Anastasov <ja@ssi.bg>

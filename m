Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab3GZD5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:57:22 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:52025 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753924Ab3GZD5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:57:21 -0400
Date: Thu, 25 Jul 2013 23:58:09 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andi Kleen <andi@firstfloor.org>
cc: Andi Kleen <ak@linux.intel.com>, acme@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org,
        trinity@vger.kernel.org
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
In-Reply-To: <20130724190537.GW6123@two.firstfloor.org>
Message-ID: <alpine.DEB.2.02.1307252351010.26524@pianoman.cluster.toy>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com> <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy> <20130723225150.GT6123@two.firstfloor.org>
 <alpine.DEB.2.02.1307241433380.8230@pianoman.cluster.toy> <20130724190537.GW6123@two.firstfloor.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020206.51F1F3A0.008B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013, Andi Kleen wrote:

> Sorry I meant flags as an alias of "the 64bits currently occupied by the
> bitfield". Perhaps the name choice was not very good.
> 
> "flags_bitfield" ?
> 
> So the tool would only need to know that, not every bit.
> 
> In theory it could be also generalized as a byte offset to perf_event,
> but that may be overengineered.

I somehow doubt this would be acceptable.  If it were, we could have had a 
somewhat better interface by just having the event fields be a list of 
values without involving format/* at all, something like

   config=0x58034;config1=0x20;precise_ip=0x4

For whatever reason things have to be human readable, and I don't think
just having an opaque 64-bit "flags" value will be accepted.  

I'm likely wrong though, I have a very low accuracy rate for predicting 
future perf_event design decisions.

This is all complicated by the intertwined nature of the perf_event ABI 
and the perf tool, and the way that there's at least three or four 
different ways to specify the same event from the perf tool command line.

Vince

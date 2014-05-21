Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaEUIKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:10:36 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:43076 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaEUIKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:10:32 -0400
Message-ID: <537C5F71.6000204@davidnewall.com>
Date: Wed, 21 May 2014 17:40:25 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Florian Westphal <fw@strlen.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: Revert 462fb2af9788a82a534f8184abfde31574e1cfa0 (bridge : Sanitize
 skb before it enters the IP stack)
References: <537621AC.1060409@davidnewall.com> <5379FFFD.1050705@davidnewall.com> <20140519140119.GA24523@breakpoint.cc>            <537A12EA.4060604@davidnewall.com> <14456.1400561749@turing-police.cc.vt.edu>
In-Reply-To: <14456.1400561749@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/14 14:25, Valdis.Kletnieks@vt.edu wrote:
> So yes, we*do*  need to do something sensible there - either frag the packet
> on the way out, or something.

I think the problem is that a bridge cannot be used across incompatible 
media.  That's the job of a router.

A bridge should act like a bridge, not a router.  Fragmenting the packet 
is wrong; that's IP's job.  Dropping the packet is also arguably wrong; 
that's the real device-driver's job.  What seems right to me is to act 
like a bridge and forward packets by looking inside of them *no more 
than is necessary*.  Looking beyond MAC address is perhaps too much.

We can finish the job of processing IP options, or at least in this 
scenario, but that seems wrong-headed and invites more work as more 
problems are discovered; or we could remove the half-hearted attempt it 
currently does and leave the bridge as a simple bridge.

This problem wouldn't occur if all devices in a bridge were required to 
be compatible media; particularly identical MTU.

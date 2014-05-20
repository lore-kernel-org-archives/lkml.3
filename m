Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaETQF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:05:56 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54202 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaETQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:05:54 -0400
Message-ID: <537B7D5F.2080802@gmail.com>
Date: Tue, 20 May 2014 12:05:51 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu, David Newall <davidn@davidnewall.com>
CC: Florian Westphal <fw@strlen.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: Revert 462fb2af9788a82a534f8184abfde31574e1cfa0 (bridge : Sanitize
 skb before it enters the IP stack)
References: <537621AC.1060409@davidnewall.com> <5379FFFD.1050705@davidnewall.com> <20140519140119.GA24523@breakpoint.cc>            <537A12EA.4060604@davidnewall.com> <14456.1400561749@turing-police.cc.vt.edu>
In-Reply-To: <14456.1400561749@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 12:55 AM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 19 May 2014 23:49:22 +0930, David Newall said:
> 
>> How does a packet get fragmented in this case?  Does it only happen when
>> bridging to a device with smaller MTU?  That scenario sounds quite
>> un-bridge-like.  It also sounds like something that can be handled by
>> real routing.
> 
> Which doesn't change the fact that you *will* get clowns who take a box that
> has a 10G card on a jumbogram-enabled subnet that's running with an MTU of
> 9000, and a 1G at MTU 1500 on the other, and try to bridge rather than route.
> (Did you know that you can actually mount an NFS filesystem across that? And
> that ls and cat and friends will work *just fine*? Until you hit a file that's
> more than 1.5 in size, that is. And when you do a traceroute to the wedged
> client, it tells you it's on the 10G network, so you have no idea why you're
> seeing an MTU issue.  Don't ask how I know this - let's just say that
> supporting HPC users is never boring. :)
> 
> So yes, we *do* need to do something sensible there - either frag the packet
> on the way out, or something.  It *would* be nice if we could drop the
> packet and send an ICMP Frag Needed back - except it's unclear what IP
> you use as the source address for the ICMP....
> 

If there is no netfilter, then the bridge will just drop the packet
(see br_dev_queue_push_xmit).  It should probably also do that with
netfilter.

On the question of ICMP, I've also debated about sending ICMP Frag
Needed, but that's really beyond the scope of the bridge device.

Recording a stat might be sufficient to help troubleshoot these types
of issues.

-vlad

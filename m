Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3BEQhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:37:02 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:64565 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323Ab3BEQg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:36:59 -0500
Message-ID: <1360082216.14826.17.camel@x61.thuisdomein>
Subject: Re: infiniband: cxgb4: GCC warnings for 32 bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Steve Wise <swise@opengridcomputing.com>
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipul Pandya <vipul@chelsio.com>
Date: Tue, 05 Feb 2013 17:36:56 +0100
In-Reply-To: <51112943.3040003@opengridcomputing.com>
References: <1360059358.1343.37.camel@x61.thuisdomein>
	 <51112943.3040003@opengridcomputing.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2013 16:36:56.0845 (UTC) FILETIME=[033F73D0:01CE03BF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 09:46 -0600, Steve Wise wrote:
> On 2/5/2013 4:15 AM, Paul Bolle wrote:
> > And why is 'cookie' __u64? Is struct cpl_fw6_msg_ofld_connection_wr_rpl
> > used in userspace code? Can't 'cookie' be of type "struct sk_buff *"? Is
> > there a requirement for it to be 64 bits wide on both 32 bit and 64 bit?
> 
> In general, these fields are __ types to highlight the fact that they 
> define an interface between the host driver and adapter firmware.

That's something new for me. Is that a custom for infiniband drivers or
is it used throughout the tree?

> These 
> "cookie" fields are opaque to the firmware.  They are passed to firmware 
> in a work request and then reflected back to the host in the reply to 
> the work request.  Given this, I think there are two issues:
> 
> 1) no swapping is really needed.  The values are opaque to firmware, and 
> thus can stay in host byte order.
> 
> 2) to remove the warning, we need something like:
> 
> req->cookie = (unsigned long)skb;
> 
> and
>   
> rpl_skb = (struct sk_buff *)(unsigned long)req->cookie;

That's is exactly what I came up with to silence these warnings. But I
didn't dare to submit it because I was too puzzled with the current
code. Anyhow, should I submit the (trivial) patch to fix this?


Paul Bolle


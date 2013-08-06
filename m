Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3HFSYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:24:44 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:57821 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756371Ab3HFSYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:24:43 -0400
Date: Tue, 6 Aug 2013 13:18:21 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH net] net: rename and move busy poll mib counter
Message-ID: <20130806181821.GB8993@sbohrermbp13-local.rgmadvisors.com>
References: <20130806095207.5887.2196.stgit@ladj378.jer.intel.com>
 <1375784088.4457.74.camel@edumazet-glaptop>
MIME-Version: 1.0
In-Reply-To: <1375784088.4457.74.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 03:14:48AM -0700, Eric Dumazet wrote:
> On Tue, 2013-08-06 at 12:52 +0300, Eliezer Tamir wrote:
> > Move the low latency mib counter to the ip section.
> > Rename it from low latency to busy poll.
> > 
> > Reported-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> > Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> > ---
> 
> Well, it should not be part of IP mib, but a socket one (not existing so
> far)
> 
> Linux MIB already contains few non TCP counters :
> 
> LINUX_MIB_ARPFILTER
> LINUX_MIB_IPRPFILTER

Doesn't mean they are in the correct place either, but perhaps it's too
late for them.

> Its mostly populated by TCP counters, sure.

See, on the kernel side these are called "LINUX_MIB*" which seems
perfectly sane and I wouldn't even think the statistic is out of
place.  On the user-mode side these are all reported in
/proc/net/netstat as TcpExt statistics.  I can tell you that I don't
look at TCP statistics when I'm debugging/testing UDP issues
(apparently I should).

--
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

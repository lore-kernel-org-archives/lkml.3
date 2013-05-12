Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3ELNLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 09:11:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3ELNLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 09:11:40 -0400
Date: Sun, 12 May 2013 21:11:18 +0800
From: Dong Zhu <bluezhudong@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Matthew Vick <matthew.vick@intel.com>,
        Jacob Keller <Jacob.e.keller@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH] igb: add a method to get the nic hw time stamping
 policy
Message-ID: <20130512131118.GH8399@zhudong.nay.redhat.com>
References: <20130511140219.GG8399@zhudong.nay.redhat.com>
 <20130511153143.GA25180@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130511153143.GA25180@netboy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 05:31:43PM +0200, Richard Cochran wrote:
> On Sat, May 11, 2013 at 10:02:19PM +0800, Dong Zhu wrote:
> > 
> > Currently kernel only support setting the hw time stamping policy
> > through ioctl,now add a method to check which packets(Outgoing and
> > Incoming) are time stamped by nic.
> 
> I don't really see a use case here. Applications needing time stamping
> should just set the policy that they need.

I think it is necessary to check which type of packets are stamped
by nic.

For I350 (igb), it only support HWTSTAMP_FILTER_NONE and
HWTSTAMP_FILTER_ALL of outgoing packets.For 82599EB(ixgbe), we can 
check more.

I add a new member of hwtstamp_config to judge the ioctl request is read
or write, we can specify the rw in the userspace using hwstamp_ctl
application to get the time stamped info.


-- 
Best Regards,
Dong Zhu

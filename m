Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab3IYS0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:26:18 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51432 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3IYS0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:26:16 -0400
Date: Wed, 25 Sep 2013 11:26:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 04/13] wireless: Apply rcu_access_pointer()
 to avoid sparse false positive
Message-ID: <20130925182608.GY9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130925013451.GA31260@linux.vnet.ibm.com>
 <1380072916-31557-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1380072916-31557-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <1380131303.2222.9.camel@bwh-desktop.uk.level5networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380131303.2222.9.camel@bwh-desktop.uk.level5networks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092518-1344-0000-0000-000001EF66AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 06:48:23PM +0100, Ben Hutchings wrote:
> On Tue, 2013-09-24 at 18:35 -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The sparse checking for rcu_assign_pointer() was recently upgraded
> > to reject non-__kernel address spaces.  This also rejects __rcu,
> > which is almost always the right thing to do.  However, the uses in
> > cfg80211_combine_bsses() and cfg80211_bss_update() are legitimate:
> > They is assigning a pointer to an element from an RCU-protected list,
> [...]
> 
> 'They is'?  This error is also in the commit messsages for the bridge
> and mac80211 patches, and maybe others that weren't sent to netdev.

Good catch, fixed in four patches.  Yeah, English can be a bit
unfriendly at times to text reuse.  The s/It/They/ should have been
s/It is/They are/.  ;-)

							Thanx, Paul


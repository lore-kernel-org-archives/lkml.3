Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3IYRsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:48:32 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:24091 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab3IYRsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:48:30 -0400
Message-ID: <1380131303.2222.9.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH tip/core/rcu 04/13] wireless: Apply rcu_access_pointer()
 to avoid sparse false positive
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <mingo@kernel.org>, <laijs@cn.fujitsu.com>,
        <dipankar@in.ibm.com>, <akpm@linux-foundation.org>,
        <mathieu.desnoyers@efficios.com>, <josh@joshtriplett.org>,
        <niv@us.ibm.com>, <tglx@linutronix.de>, <peterz@infradead.org>,
        <rostedt@goodmis.org>, <dhowells@redhat.com>, <edumazet@google.com>,
        <darren@dvhart.com>, <fweisbec@gmail.com>, <sbw@mit.edu>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
Date: Wed, 25 Sep 2013 18:48:23 +0100
In-Reply-To: <1380072916-31557-4-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925013451.GA31260@linux.vnet.ibm.com>
	 <1380072916-31557-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1380072916-31557-4-git-send-email-paulmck@linux.vnet.ibm.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20172.005
X-TM-AS-Result: No--10.050700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-24 at 18:35 -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The sparse checking for rcu_assign_pointer() was recently upgraded
> to reject non-__kernel address spaces.  This also rejects __rcu,
> which is almost always the right thing to do.  However, the uses in
> cfg80211_combine_bsses() and cfg80211_bss_update() are legitimate:
> They is assigning a pointer to an element from an RCU-protected list,
[...]

'They is'?  This error is also in the commit messsages for the bridge
and mac80211 patches, and maybe others that weren't sent to netdev.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


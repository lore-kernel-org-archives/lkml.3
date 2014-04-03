Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaDCVop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbaDCVol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:44:41 -0400
Date: Thu, 3 Apr 2014 17:44:30 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140403214430.GA20249@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140401150849.GA14757@redhat.com>
 <20140401153032.GT4284@linux.vnet.ibm.com>
 <20140401172244.GA10363@redhat.com>
 <20140401175545.GV4284@linux.vnet.ibm.com>
 <20140401180414.GA12326@redhat.com>
 <20140401183245.GA12473@linux.vnet.ibm.com>
 <20140402162043.GA11090@linux.vnet.ibm.com>
 <20140402224840.GA5385@redhat.com>
 <20140403200143.GA8119@redhat.com>
 <20140403204656.GI4284@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403204656.GI4284@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 01:46:56PM -0700, Paul E. McKenney wrote:
 > So, how about reverting each commit in the RCU series, and then bisecting
 > through the reverts?  Something like the following:
 > 
 > 	wherever=linus/master # or substitute whatever point you wish.
 > 	# Create a revert branch for the rcu.2014.02.26a branch
 > 	git checkout -b anti-fixes $wherever
 > 	git revert 5cb5c6e18f822b19bd41a2c0f9930c82b3ec0bc9
 > 	git revert 7a754743185a4b05818e10058fa2fbe4e6969085
 > 	git revert 8857563b819b140aa8c9be920cfe44d5d3f808b7
 > 	git revert add1f0995454374d90c9d6b2c420d2fba3d0a4e3
 > 	git revert ae1670339c95c3ff96ab10582506cf827c5fecc8
 > 	git revert 52e2bb958ac4f9b3c4bdd78606d279852fd72922
 > 	git revert 88c1863066ccfa456797e12c5d8b4631aa1ad0d0
 > 	git revert 0adab9b9aa18d7e90337d43567f1eec3d5401b81
 > 	git revert 41f4abd92a34f9c5110bbb870c04f8854604e28d
 > 	git revert cb1e78cfa267453bb19e7edafd214c03834b664c
 > 	git revert 87de1cfdc55b16b794e245b07322340725149d62
 > 	git revert 3660c2813fb6d0ba48ee44bcbf9feddf7218c11d
 > 	# Create a revert branch for the rt.2014.02.17b branch
 > 	git checkout -b anti-rt $wherever
 > 	git revert f1f399d1281ea339a08469f7e58193624992f620
 > 	git revert ffa83fb565fbc397cbafb4b71fd1cce276d4c3b6
 > 	git revert 2f33b512a5460578f6cf11d7b7867bed53157c7c
 > 	git merge anti-fixes
 > 
 > Then bisect through these reverts.
 > 
 > I am assuming, perhaps naively, that changes under Documentation and
 > to torture testing should not be affecting you.
 > 
 > Does this make sense?

I tried reverting every one of those and could still hit it, which
seems to indicate the bug is elsewhere, and rcu is just a victim of it.
I'm going to start trying to revert the lockdep changes, given this seems
to happen after that has warned..

	Dave 


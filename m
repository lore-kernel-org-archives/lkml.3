Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab3CGDMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:12:01 -0500
Received: from ozlabs.org ([203.10.76.45]:48142 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab3CGDL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:11:59 -0500
Date: Thu, 7 Mar 2013 14:11:24 +1100
From: Paul Mackerras <paulus@samba.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Michael Wolf <mjw@linux.vnet.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mingo@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
Message-ID: <20130307031124.GB2385@drongo>
References: <20130205214818.4615.12937.stgit@lambeau>
 <CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
 <20130219011104.GA5785@amt.cnet>
 <1362514928.6267.16.camel@lambeau>
 <20130306014151.GB11481@amt.cnet>
 <5136FAB4.4020305@parallels.com>
 <1362587352.6373.6.camel@lambeau>
 <20130307005216.GA29895@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307005216.GA29895@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 09:52:16PM -0300, Marcelo Tosatti wrote:
> On Wed, Mar 06, 2013 at 10:29:12AM -0600, Michael Wolf wrote:
> > I looked at doing that once but was told that I was changing the
> > interface in an unacceptable way, because now I was not reporting all of
> > the elapsed time.  I agree it would make things simpler.
> 
> Pointer to that claim, please?

Back in about 2004 or 2005 or so I was looking at changing how user
and system times were calculated (in the context of trying to find a
better way to report resources used by a thread in an SMT processor).
I found that utilities such as top expected the deltas in the
/proc/stat numbers to add up to elapsed time, and would report strange
and inconsistent results if that wasn't the case.  Unfortunately at
this distance I don't recall the exact details.  I don't know whether
the expectation that the deltas in the /proc/stat numbers over a
period of time add up to the elapsed real time is documented anywhere,
but I wouldn't be at all surprised if some programs depend on it, so
it's better to maintain that property.

Paul.

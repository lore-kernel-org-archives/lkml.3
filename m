Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716AbaDJXc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 19:32:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030615AbaDJXcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 19:32:23 -0400
Date: Thu, 10 Apr 2014 19:30:01 -0400
From: Dave Jones <davej@redhat.com>
To: Jason Low <jason.low2@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
Message-ID: <20140410233001.GA24777@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jason Low <jason.low2@hp.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Kirill A. Shutemov" <kirill@shutemov.name>,
	"Michael L. Semon" <mlsemon35@gmail.com>,
	Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
	paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <1397108579.2586.15.camel@j-VirtualBox>
 <20140410091824.GL10526@twins.programming.kicks-ass.net>
 <1397150084.3032.4.camel@j-VirtualBox>
 <20140410232652.GA24658@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410232652.GA24658@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 07:26:52PM -0400, Dave Jones wrote:
 > On Thu, Apr 10, 2014 at 10:14:44AM -0700, Jason Low wrote:
 >  > On Thu, 2014-04-10 at 11:18 +0200, Peter Zijlstra wrote:
 >  > > On Wed, Apr 09, 2014 at 10:42:59PM -0700, Jason Low wrote:
 >  > > > As a starting point, would either of you like to test the following
 >  > > > patch to see if it fixes the issue? This patch essentially generates the
 >  > > > same code as in older kernels in the debug case. This applies on top of
 >  > > > kernels with both commits 6f008e72cd11 and 1d8fe7dc8078.
 >  > > 
 >  > > 
 >  > > So I managed to reproduce, and the below makes it go away. I just don't
 >  > > understand why though. will stare more.
 >  > 
 >  > So one thing I noticed that is different in the current code is that in
 >  > debug_mutex_unlock(), there is is a possibility that it does not unlock
 >  > the mutex (when !debug_locks). May be interesting to try out this
 >  > patch too:
 >  
 > I've been seeing lockups this last week or two too, that manifested by
 > RCU spewing stall messages, and the box being totally unresponsive.
 > This patch seems to cure that for me, which I'm sure will make Paul
 > happy to hear.
 
duh, replied to the wrong mail. I tested peterz's last patch, not Jason's.

	Dave


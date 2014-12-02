Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbaLBTdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:33:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932967AbaLBTdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:33:10 -0500
Date: Tue, 2 Dec 2014 14:32:52 -0500
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202193252.GB17595@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20141127225637.GA24019@redhat.com>
 <m5dart$co$1@ger.gmane.org>
 <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
 <20141201230339.GA20487@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201230339.GA20487@ret.masoncoding.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 06:08:38PM -0500, Chris Mason wrote:
 > I'm not sure if this is related, but running trinity here, I noticed it
 > was stuck at 100% system time on every CPU.  perf report tells me we are
 > spending all of our time in spin_lock under the sync system call.
 > 
 > I think it's coming from contention in the bdi_queue_work() call from
 > inside sync_inodes_sb, which is spin_lock_bh(). 
 > 
 > I wonder if we're just spinning so hard on this one bh lock that we're
 > starving the watchdog?
 > 
 > Dave, do you have spinlock debugging on?  

That has been a constant, yes. I can try with that disabled some time.

	Dave


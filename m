Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaLBONc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:13:32 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:58870 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaLBONa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:13:30 -0500
Message-ID: <1417529606.3924.26.camel@maggy.simpson.net>
Subject: Re: frequent lockups in 3.18rc4
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 02 Dec 2014 07:13:26 -0700
In-Reply-To: <20141201230339.GA20487@ret.masoncoding.com>
References: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	 <20141127225637.GA24019@redhat.com> <m5dart$co$1@ger.gmane.org>
	 <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
	 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	 <547bbe36.48548c0a.105c.779c@mx.google.com>
	 <20141201191431.GA17385@linux.vnet.ibm.com>
	 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
	 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	 <20141201230339.GA20487@ret.masoncoding.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 18:08 -0500, Chris Mason wrote:
> I'm not sure if this is related, but running trinity here, I noticed it
> was stuck at 100% system time on every CPU.  perf report tells me we are
> spending all of our time in spin_lock under the sync system call.
> 
> I think it's coming from contention in the bdi_queue_work() call from
> inside sync_inodes_sb, which is spin_lock_bh(). 
> 
> I wonder if we're just spinning so hard on this one bh lock that we're
> starving the watchdog?

The bean counting problem below can contribute.

https://lkml.org/lkml/2014/3/30/7

	-Mike


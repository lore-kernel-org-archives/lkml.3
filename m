Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaLOLoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:44:54 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:42720 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaLOLou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:44:50 -0500
Date: Mon, 15 Dec 2014 11:44:21 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Loic Pefferkorn <loic@loicp.eu>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, jun.j.tian@intel.com, octavian.purdila@intel.com,
        nnk@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, joe@perches.com
Subject: Re: [PATCH] checkpatch giving bogus advice (was staging: goldfish:
 Fix minor coding style)
Message-ID: <20141215114421.7389d32a@lxorguk.ukuu.org.uk>
In-Reply-To: <20141213194647.GA30065@hudson.localdomain>
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
	<20141213175518.GA28616@hudson.localdomain>
	<20141213182238.GA6979@iron>
	<20141213194647.GA30065@hudson.localdomain>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2014 11:46:47 -0800
Jeremiah Mahler <jmmahler@gmail.com> wrote:

> Loïc,
> 
> On Sat, Dec 13, 2014 at 07:22:38PM +0100, Loic Pefferkorn wrote:
> > > Whose convention is this?  I can't find any mention in
> > > Documention/CodingStyle. checkpatch.pl doesn't complain about them.
> > > And there are almost three thousand examples in staging which don't
> > > use this convention.
> > > 
> > >   linux-next$ grep -r "== NULL" drivers/staging/* | wc -l
> > >   2844
> > 
> > Hi Jeremiah,
> > 
> > Thanks for your feedback.
> > 
> > I have used checkpatch.pl with the --strict flag:

checkpatch.pl is a bit dubious at the best of times - you can't automate
taste without an AI ;). With --strict it's a positive hazard.

Those kind of small cleanups really only make sense if you are doing big
changes to the code itself anyway and are doing testing and all the rest.

In this case I'd say checkpatch.pl is actually wrong because in the
general case it's better to compare with NULL in C

If you write

          if (!x)

and accidentally use a non-pointer type you don't get a warning. If you
try and compare a non pointer type to NULL you usually do. So the NULL
comparison avoids accidents.

The historical reason for it being done in C was I think to avoid the

          if (x = NULL) 

bug, but gcc will shout at you for that these days.

Alan




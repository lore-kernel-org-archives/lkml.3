Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3DOGPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 02:15:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42716 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751814Ab3DOGPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 02:15:19 -0400
Message-ID: <1366006517.1878.49.camel@joe-AO722>
Subject: Re: arch/s390/lib/uaccess_pt.c: Missing breaks: ?
From: Joe Perches <joe@perches.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 14 Apr 2013 23:15:17 -0700
In-Reply-To: <20130415055822.GC4207@osiris>
References: <1365919574.1878.13.camel@joe-AO722>
	 <20130415054814.GA4207@osiris> <1366005207.1878.43.camel@joe-AO722>
	 <20130415055822.GC4207@osiris>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 07:58 +0200, Heiko Carstens wrote:
> On Sun, Apr 14, 2013 at 10:53:27PM -0700, Joe Perches wrote:
> > On Mon, 2013-04-15 at 07:48 +0200, Heiko Carstens wrote:
> > > On Sat, Apr 13, 2013 at 11:06:14PM -0700, Joe Perches wrote:
> > > > Commit ea81531d ("s390/uaccess: fix page table walk")
> > > > added this code.  It looks like it should have break;
> > > > for each case.
> > > no, the fallthrough is on purpose for each case statement.
> > 
> > Hi again.  It might be useful to add /* fallthrough */
> > or some other comment showing it's intentional.
> 
> I might add some comment above the function, since for everybody
> *knowing* the architecture it's obvious ;) that these must be
> fallthroughs.
> How did you stuble across this?

Tony Prisk sent an patch about a duplicated set of
a variable in a switch/case without a break and I
generalized it and found this and another one in
arch/arm. (the arm one was a real defect)

This one looked like it could be intentional (or not),
but I thought I'd ask.

$ grep-2.5.4 -rP --include=*.[ch] "\b(\w+)\s*=[^;]+;\s*(?:case\s+\w+:|default:)\s*\1\s*=" *



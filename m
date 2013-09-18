Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3IRLGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab3IRLGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:06:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1379482610.1787.7.camel@joe-AO722>
References: <1379482610.1787.7.camel@joe-AO722> <1379459317-13046-1-git-send-email-daniel.santos@pobox.com> <1379459317-13046-6-git-send-email-daniel.santos@pobox.com>
To: Joe Perches <joe@perches.com>
Cc: dhowells@redhat.com, Daniel Santos <daniel.santos@pobox.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: Re: [PATCH 5/5] lib: Add error string support to printks
Date: Wed, 18 Sep 2013 12:04:55 +0100
Message-ID: <22238.1379502295@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> On Tue, 2013-09-17 at 18:08 -0500, danielfsantos@att.net wrote:
> > This adds an extension for the integral format specifier suffix of 'e',
> > so that the format %[duxXo]e will result in printing an number (as
> > before) in addition to a name and descrption for an error code, if such
> > support is enabled and a name and descrption is found.
> > 
> > My initial thought was to use the glibc extension of '%m', but this
> > format specifier uses the value of libc's errno and adding a value
> > breaks gcc's printf parsing.  I'm not convinced that the 'e' extension
> > is optimal, although there are only four instances of this pattern in
> > the kernel that would need to be changed.
> > 
> >     git grep -E '".*%[#0\ +\-]*[0-9]*[hljzt]*[idoxXu]e'
> > 
> > Alternatively, 'E' was another thought for a suffix as well.
> 
> I'd much rather see another %p extension used instead
> of generating odd output given normal printf formats.
> 
> %pE might work

I guess you'd use that with ERR_PTR().  On one hand, it would look decidedly
odd, but on the other hand, we have errors in pointers in a lot of places
already which wouldn't then need converting back - so it doesn't seem entirely
unreasonable.

David

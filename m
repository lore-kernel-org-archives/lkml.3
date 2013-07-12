Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab3GLTgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:36:06 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37279 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757511Ab3GLTgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:36:03 -0400
Date: Fri, 12 Jul 2013 15:35:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130712193557.GB342@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Guenter Roeck <linux@roeck-us.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable <stable@vger.kernel.org>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130711222935.GA11340@redhat.com>
 <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712181103.GA6689@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712181103.GA6689@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unwritten criteria that I've seen used (and sometimes even
discussed on mailing lists) is that if it's something that distro
kernel maintainers would want, then it's fit for stable.  Now, there's
a grey area here.  The criteria before distro's "golden master" has
been released is quite different compared to a criteria for a Service
Pack 5 kernel.  There's also a hjuge difference between a patch which
has just hit mainline during the merge window, and a bug fix which has
been in Linus's tree for weeks or months.  It's likely that a bug fix
which has been in the kernel since 3.8, even if it is not "critical"
is one which might be suitable merging for 3.4.  Heck, I've even had
users screaming at me that it was somehow my duty as the ext4
maintainer to find these commits and backport them to 3.4 or 3.2.  (Of
course, I blow them off.  :-)

So the problem is that maintainers are lazy.  They don't want to go
back for bug fixes that have "proven" themselves, and even if they
aren't critical bug fixes, they are things which a distro maintainer
or a stable kernel user might want (and sometimes stable uers are
uppity enough to expect subsystem maintainers to do this back
porting).  So subsystem maintainers then react by marking submits for
stable even though they really should soak for a release or two before
submitting them, since by marking them as submit, the commit gets
pushed to stable automatically --- albeit early.

Now, I'm not condoning this practice; but I suspect this is at least
partially the reason why some maintainers have gotten more aggressive
about marking patches for stable and not pushing them to mainline earlier.

If it really is the case that patches that are marked for -stable are
patches that should just be sent to linus pre-rc4, and patches that
had just been added to the subsystem maintainer tree a few weeks
before the merge window shouldn't be automatically be merged into
stable, maybe the right answer is that the stable kernel maintainers
shouldn't be automatically including _any_ patches that are marked for
stable which are sent to mainline during the merge window.

       	     	      	 	  	 - Ted

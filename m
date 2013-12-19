Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab3LSSfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:35:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab3LSSfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:35:20 -0500
Date: Thu, 19 Dec 2013 13:35:08 -0500
From: Dave Jones <davej@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@gentwo.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: bad page state in 3.13-rc4
Message-ID: <20131219183508.GB881@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Kent Overstreet <kmo@daterainc.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@gentwo.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20131219040738.GA10316@redhat.com>
 <CA+55aFwweoGs3eGWXFULcqnbRbpDhpj2qrefXB5OpQOiWW8wYA@mail.gmail.com>
 <20131219155313.GA25771@redhat.com>
 <CA+55aFyoXCDNfHb+r5b=CgKQLPA1wrU_Tmh4ROZNEt5TPjpODA@mail.gmail.com>
 <20131219181134.GC25385@kmo-pixel>
 <20131219182920.GG30640@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219182920.GG30640@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 01:29:21PM -0500, Benjamin LaHaise wrote:
 
 > > > and some kind of double free in an error path would certainly explain
 > > > this (with io_setup() . And the first oops reported obviously had that
 > > > migration thing. So maybe those "fixes" weren't fixing things at all
 > > > (or just moved the error case around).
 > > > 
 > > > Btw, that "rework aio migrate pages to use aio fs" looks odd. It has
 > > > Ben LaHaise marked as author, but no sign-off, instead "Tested-by" and
 > > > "Acked-by".
 > > 
 > > I could certainly believe a double free, but rereading the current code
 > > I can't find anything, and I just manually tested all the relevant error
 > > paths in ioctx_alloc() and aio_setup_ring() without finding anything.
 > 
 > The same here.  It would be very helpful to know what syscalls trinity is 
 > issuing in the lead up to the bug.

Working on narrowing it down.  The io_setup fuzzer is actually incredibly dumb,
and 99.9% of the time will just EFAULT or EINVAL. I'll see if I can smarten it
up to succeed more often, in the hope that it can reproduce this faster, because
right now it looks like it needs the planets to line up just right to hit
the bug (even though I've hit it twice in the last 24 hrs)

	Dave


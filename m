Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbaFIWnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:43:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbaFIWm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:42:58 -0400
Date: Mon, 9 Jun 2014 15:46:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds
 checking
Message-ID: <20140609224645.GA8113@kroah.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
 <20140609223057.GB18475@kroah.com>
 <CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 03:35:02PM -0700, Andy Lutomirski wrote:
> On Mon, Jun 9, 2014 at 3:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, May 28, 2014 at 11:09:58PM -0400, Eric Paris wrote:
> >> From: Andy Lutomirski <luto@amacapital.net>
> >>
> >> Fixes an easy DoS and possible information disclosure.
> >>
> >> This does nothing about the broken state of x32 auditing.
> >>
> >> eparis: If the admin has enabled auditd and has specifically loaded audit
> >> rules.  This bug has been around since before git.  Wow...
> >>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >> Signed-off-by: Eric Paris <eparis@redhat.com>
> >> ---
> >>  kernel/auditsc.c | 27 ++++++++++++++++++---------
> >>  1 file changed, 18 insertions(+), 9 deletions(-)
> >
> > Did this patch get dropped somewhere?  Isn't it a valid bugfix, or did I
> > miss a later conversation about this?
> 
> Hmm.  It seems that it didn't make it into Linus' tree.  Crap.
> 
> IMO we need some kind of real tracking system for issues reported to
> security@.

That seems to be my mbox at times :)

But yes, having something "real" might be good if the load gets higher,
right now it's so low that my "sweep pending security patches" task
usually catches anything pending, which is rare.

thanks,

greg k-h

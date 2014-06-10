Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbaFJA15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:27:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbaFJA1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:27:54 -0400
Date: Mon, 9 Jun 2014 17:31:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds
 checking
Message-ID: <20140610003142.GA20728@kroah.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
 <20140609223057.GB18475@kroah.com>
 <CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
 <20140609224645.GA8113@kroah.com>
 <CA+5PVA6dHu-0qi1fx5Vq4QynJDJ=dG0feJjwoCHA3GaUSHp-FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA6dHu-0qi1fx5Vq4QynJDJ=dG0feJjwoCHA3GaUSHp-FQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 07:35:57PM -0400, Josh Boyer wrote:
> On Mon, Jun 9, 2014 at 6:46 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Jun 09, 2014 at 03:35:02PM -0700, Andy Lutomirski wrote:
> >> On Mon, Jun 9, 2014 at 3:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > On Wed, May 28, 2014 at 11:09:58PM -0400, Eric Paris wrote:
> >> >> From: Andy Lutomirski <luto@amacapital.net>
> >> >>
> >> >> Fixes an easy DoS and possible information disclosure.
> >> >>
> >> >> This does nothing about the broken state of x32 auditing.
> >> >>
> >> >> eparis: If the admin has enabled auditd and has specifically loaded audit
> >> >> rules.  This bug has been around since before git.  Wow...
> >> >>
> >> >> Cc: stable@vger.kernel.org
> >> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >> >> Signed-off-by: Eric Paris <eparis@redhat.com>
> >> >> ---
> >> >>  kernel/auditsc.c | 27 ++++++++++++++++++---------
> >> >>  1 file changed, 18 insertions(+), 9 deletions(-)
> >> >
> >> > Did this patch get dropped somewhere?  Isn't it a valid bugfix, or did I
> >> > miss a later conversation about this?
> >>
> >> Hmm.  It seems that it didn't make it into Linus' tree.  Crap.
> >>
> >> IMO we need some kind of real tracking system for issues reported to
> >> security@.
> >
> > That seems to be my mbox at times :)
> >
> > But yes, having something "real" might be good if the load gets higher,
> > right now it's so low that my "sweep pending security patches" task
> > usually catches anything pending, which is rare.
> 
> How does one get added to the security@ alias?  We've been carrying
> this patch in Fedora for a bit now.  I'd be happy to help track things
> given we get distro security bug reports and such.

Just ask on the security@ alias to be added and we can take it from
there.

thanks,

greg k-h

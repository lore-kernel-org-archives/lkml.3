Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbaFIXf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:35:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55664 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbaFIXf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:35:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140609224645.GA8113@kroah.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
	<20140609223057.GB18475@kroah.com>
	<CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
	<20140609224645.GA8113@kroah.com>
Date: Mon, 9 Jun 2014 19:35:57 -0400
X-Google-Sender-Auth: 5NblKTlSnH5Icb7g2i3mTMuEC-g
Message-ID: <CA+5PVA6dHu-0qi1fx5Vq4QynJDJ=dG0feJjwoCHA3GaUSHp-FQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds checking
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 6:46 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jun 09, 2014 at 03:35:02PM -0700, Andy Lutomirski wrote:
>> On Mon, Jun 9, 2014 at 3:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Wed, May 28, 2014 at 11:09:58PM -0400, Eric Paris wrote:
>> >> From: Andy Lutomirski <luto@amacapital.net>
>> >>
>> >> Fixes an easy DoS and possible information disclosure.
>> >>
>> >> This does nothing about the broken state of x32 auditing.
>> >>
>> >> eparis: If the admin has enabled auditd and has specifically loaded audit
>> >> rules.  This bug has been around since before git.  Wow...
>> >>
>> >> Cc: stable@vger.kernel.org
>> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> >> Signed-off-by: Eric Paris <eparis@redhat.com>
>> >> ---
>> >>  kernel/auditsc.c | 27 ++++++++++++++++++---------
>> >>  1 file changed, 18 insertions(+), 9 deletions(-)
>> >
>> > Did this patch get dropped somewhere?  Isn't it a valid bugfix, or did I
>> > miss a later conversation about this?
>>
>> Hmm.  It seems that it didn't make it into Linus' tree.  Crap.
>>
>> IMO we need some kind of real tracking system for issues reported to
>> security@.
>
> That seems to be my mbox at times :)
>
> But yes, having something "real" might be good if the load gets higher,
> right now it's so low that my "sweep pending security patches" task
> usually catches anything pending, which is rare.

How does one get added to the security@ alias?  We've been carrying
this patch in Fedora for a bit now.  I'd be happy to help track things
given we get distro security bug reports and such.

josh

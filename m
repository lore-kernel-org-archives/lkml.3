Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936208AbaFJAan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:30:43 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:34517 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934584AbaFJAak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:30:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140610003234.GB20728@kroah.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
 <20140609223057.GB18475@kroah.com> <CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
 <20140609224645.GA8113@kroah.com> <CALCETrWb9HsaUWaQA+1ga6sH2_yUT=NEg-oKx=zFUQ5AZUqPaA@mail.gmail.com>
 <20140610003234.GB20728@kroah.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 9 Jun 2014 17:30:19 -0700
Message-ID: <CALCETrXpUZsUOoFgG4GRvStjLkWCn5=pNDFPTm-t5g=8HRaDhw@mail.gmail.com>
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds checking
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 5:32 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jun 09, 2014 at 03:55:20PM -0700, Andy Lutomirski wrote:
>> On Mon, Jun 9, 2014 at 3:46 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Mon, Jun 09, 2014 at 03:35:02PM -0700, Andy Lutomirski wrote:
>> >> On Mon, Jun 9, 2014 at 3:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> > On Wed, May 28, 2014 at 11:09:58PM -0400, Eric Paris wrote:
>> >> >> From: Andy Lutomirski <luto@amacapital.net>
>> >> >>
>> >> >> Fixes an easy DoS and possible information disclosure.
>> >> >>
>> >> >> This does nothing about the broken state of x32 auditing.
>> >> >>
>> >> >> eparis: If the admin has enabled auditd and has specifically loaded audit
>> >> >> rules.  This bug has been around since before git.  Wow...
>> >> >>
>> >> >> Cc: stable@vger.kernel.org
>> >> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> >> >> Signed-off-by: Eric Paris <eparis@redhat.com>
>> >> >> ---
>> >> >>  kernel/auditsc.c | 27 ++++++++++++++++++---------
>> >> >>  1 file changed, 18 insertions(+), 9 deletions(-)
>> >> >
>> >> > Did this patch get dropped somewhere?  Isn't it a valid bugfix, or did I
>> >> > miss a later conversation about this?
>> >>
>> >> Hmm.  It seems that it didn't make it into Linus' tree.  Crap.
>> >>
>> >> IMO we need some kind of real tracking system for issues reported to
>> >> security@.
>> >
>> > That seems to be my mbox at times :)
>> >
>> > But yes, having something "real" might be good if the load gets higher,
>> > right now it's so low that my "sweep pending security patches" task
>> > usually catches anything pending, which is rare.
>> >
>>
>> There are currently at least two issues that I reported that are stuck
>> in limbo: this one and the (not-yet-public) vfs thing.
>
> That was next on my list to poke people about...
>
>> And there's the CVE-2014-0181 regression fix that almost got
>> forgotten, but that isn't really a security issue.
>
> What is that, where was that reported?

commit 2d7a85f4b06e9c27ff629f07a524c48074f07f81
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Fri May 30 11:04:00 2014 -0700

    netlink: Only check file credentials for implicit destinations


The security issue got fixed quickly, but the fix turned out to be problematic.

--Andy

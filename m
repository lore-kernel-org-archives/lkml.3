Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbaGWPiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:38:09 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:43750 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785AbaGWPiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:38:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140723151911.GM14599@beardog.cce.hp.com>
References: <CAPDOMVhvixp4+3P8RPUhM0iT_Ovo2kgPTUBorxPny9t_Fo2UUw@mail.gmail.com>
	<E97154CC48E26246A93194D00057266054F11A3F@G9W0745.americas.hpqcorp.net>
	<20140723144148.GL14599@beardog.cce.hp.com>
	<53CFD0A5.7010609@infradead.org>
	<20140723151911.GM14599@beardog.cce.hp.com>
Date: Wed, 23 Jul 2014 11:38:06 -0400
Message-ID: <CAPDOMVhrZe+_ewQQe1y-pam=3rNtF8tjMt3Kgprc3WavVur1QQ@mail.gmail.com>
Subject: Re: cciss_scsi.c: Fix me
From: Nick Krause <xerofoify@gmail.com>
To: scameron@beardog.cce.hp.com
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        scott.benesh@hp.com, iss_storagedev@hp.com,
        michael.miller@canonical.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:19 AM,  <scameron@beardog.cce.hp.com> wrote:
> On Wed, Jul 23, 2014 at 08:11:33AM -0700, Randy Dunlap wrote:
>> On 07/23/2014 07:41 AM, scameron@beardog.cce.hp.com wrote:
>> > On Wed, Jul 23, 2014 at 02:15:29PM +0000, Benesh, Scott wrote:
>> >> From: Nick Krause [mailto:xerofoify@gmail.com]
>> >> Sent: Saturday, July 19, 2014 11:51 PM
>> >> To: mike.miller@hp.com
>> >> Cc: ISS StorageDev; linux-kernel@vger.kernel.org
>> >> Subject: cciss_scsi.c: Fix me
>> >>
>> >> Hey Mike,
>> >> I seem to be hitting a fix me message in this file in function,cciss_scsi_queue_command_lck.
>> >> I am wondering what you want to do when C is Null?
>> >> Cheers Nick
>> >
>> > Hi Nick,
>> >
>> > Mike's moved on from HP to Canonical now.
>> >
>> > It looks like you're running out of commands for tape drives,
>> > which shouldn't ever happen, since we set
>> >
>> >     sh->can_queue = cciss_tape_cmds;
>> >
>> > and we allocate that many commands + 2....
>> >
>> > scsi_cmd_stack_setup(ctlr_info_t *h, struct cciss_scsi_adapter_data_t *sa)
>> > {
>> >         int i;
>> >         struct cciss_scsi_cmd_stack_t *stk;
>> >         size_t size;
>> >
>> >         stk = &sa->cmd_stack;
>> >         stk->nelems = cciss_tape_cmds + 2;
>> >
>> > You're apparently hitting this:
>> >
>> >         spin_lock_irqsave(&h->lock, flags);
>> >         c = scsi_cmd_alloc(h);
>> >         spin_unlock_irqrestore(&h->lock, flags);
>> >         if (c == NULL) {                        /* trouble... */
>> >                 dev_warn(&h->pdev->dev, "scsi_cmd_alloc returned NULL!\n");
>> >                 /* FIXME: next 3 lines are -> BAD! <- */
>> >                 cmd->result = DID_NO_CONNECT << 16;
>> >                 done(cmd);
>> >                 return 0;
>> >         }
>> >
>> > which means that scsi_cmd_alloc returned NULL, which only happens
>> > if the thing has run out of commands.
>> >
>> > It's not obvious to me how it can be that it runs out of commands.
>> > Maybe we're losing them somehow, but this has not previously been
>> > a problem that I'm aware of.
>> >
>> > Are you able to reproduce the problem?
>> >
>> > What's going on on the system when it happens?
>> >
>> > putting in a dump_stack(); near that FIXME might give a clue.
>> >
>> > Which kernel are you running?
>> >
>> > -- steve
>>
>> Hi Steve,
>>
>> You apparently have not been following the Nick saga.
>>
>> Nick is using cscope to search for FIXMEs in the kernel source tree and
>> then trying to generate patches to remove or 'fix' them.
>>
>> He is not hitting a kernel oops or panic or bug.
>
> Ah, ok, thanks.  That explains it, because I was pretty sure that
> code is a "this will never happen" case.
>
> -- steve
>


Fine I give up you guys don't want me to touch these fix mes and leave
them alone.
Cheers Nick

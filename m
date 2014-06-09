Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbaFIWfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:35:25 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:58536 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaFIWfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:35:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140609223057.GB18475@kroah.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com> <20140609223057.GB18475@kroah.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 9 Jun 2014 15:35:02 -0700
Message-ID: <CALCETrUD75vSwJUjFuxGCrZ_7DJhCc1KW2v_ndF6EHJ31fUMBg@mail.gmail.com>
Subject: Re: [PATCH 1/2] auditsc: audit_krule mask accesses need bounds checking
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 3:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, May 28, 2014 at 11:09:58PM -0400, Eric Paris wrote:
>> From: Andy Lutomirski <luto@amacapital.net>
>>
>> Fixes an easy DoS and possible information disclosure.
>>
>> This does nothing about the broken state of x32 auditing.
>>
>> eparis: If the admin has enabled auditd and has specifically loaded audit
>> rules.  This bug has been around since before git.  Wow...
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> Signed-off-by: Eric Paris <eparis@redhat.com>
>> ---
>>  kernel/auditsc.c | 27 ++++++++++++++++++---------
>>  1 file changed, 18 insertions(+), 9 deletions(-)
>
> Did this patch get dropped somewhere?  Isn't it a valid bugfix, or did I
> miss a later conversation about this?

Hmm.  It seems that it didn't make it into Linus' tree.  Crap.

IMO we need some kind of real tracking system for issues reported to
security@.  This shouldn't have been possible (and if I'd realized
that the patch got dropped, I wouldn't have publicly disclosed it).

For whoever applies this: it's CVE-2014-3917.

--Andy

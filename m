Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaBJSGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:06:24 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:51948 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaBJSGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:06:19 -0500
MIME-Version: 1.0
In-Reply-To: <6760094.oQMeiCg8QG@x2>
References: <ee359482b77f8f633014ec300bc5a4b93f8961e8.1391893528.git.luto@amacapital.net>
 <20140210165723.GA10856@redhat.com> <CALCETrX9gb_+zW4UZZv5icCQ-3HNG7BFZOaqMPYaQfzotsZpnA@mail.gmail.com>
 <6760094.oQMeiCg8QG@x2>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Feb 2014 10:05:58 -0800
Message-ID: <CALCETrW3FS5aOmfp7X70RuXgCO-XfXHZ2G8sEpyOKV=pn1EzCg@mail.gmail.com>
Subject: Re: [PATCH v3] audit: Turn off TIF_SYSCALL_AUDIT when there are no rules
To: Steve Grubb <sgrubb@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 9:47 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Monday, February 10, 2014 09:29:19 AM Andy Lutomirski wrote:
>> Grr.  Why is all this crap tied up with syscall auditing anyway?  ISTM
>> it would have been a lot nicer if audit calls just immediately emitted
>> audit records, completely independently of the syscall machinery.
>
> Because the majority of people needing audit need syscall records for it to
> make any sense. The auxiliary records generally report on the object of the
> syscall. We still require information about who was doing something, what they
> were doing, and what the result was.
>
> Even if you just get the AVC's, you still don't know what happened. If you get
> a deny record, was it really denied? The system could have been in permissive
> mode and the syscall succeeded. You only get the real decision when you have
> syscall records.
>

Fair enough.

I'll see if I can turn this into something more workable.

--Andy

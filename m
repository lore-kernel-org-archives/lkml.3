Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaBJRrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:47:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbaBJRrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:47:35 -0500
From: Steve Grubb <sgrubb@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v3] audit: Turn off TIF_SYSCALL_AUDIT when there are no rules
Date: Mon, 10 Feb 2014 12:47:21 -0500
Message-ID: <6760094.oQMeiCg8QG@x2>
Organization: Red Hat
User-Agent: KMail/4.11.5 (Linux/3.12.9-301.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALCETrX9gb_+zW4UZZv5icCQ-3HNG7BFZOaqMPYaQfzotsZpnA@mail.gmail.com>
References: <ee359482b77f8f633014ec300bc5a4b93f8961e8.1391893528.git.luto@amacapital.net> <20140210165723.GA10856@redhat.com> <CALCETrX9gb_+zW4UZZv5icCQ-3HNG7BFZOaqMPYaQfzotsZpnA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 10, 2014 09:29:19 AM Andy Lutomirski wrote:
> Grr.  Why is all this crap tied up with syscall auditing anyway?  ISTM
> it would have been a lot nicer if audit calls just immediately emitted
> audit records, completely independently of the syscall machinery.

Because the majority of people needing audit need syscall records for it to 
make any sense. The auxiliary records generally report on the object of the 
syscall. We still require information about who was doing something, what they 
were doing, and what the result was. 

Even if you just get the AVC's, you still don't know what happened. If you get 
a deny record, was it really denied? The system could have been in permissive 
mode and the syscall succeeded. You only get the real decision when you have 
syscall records.

-Steve

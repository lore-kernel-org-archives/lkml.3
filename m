Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaA1AZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:25:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52623 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaA1AZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:25:33 -0500
Message-ID: <52E6F84F.1000408@zytor.com>
Date: Mon, 27 Jan 2014 16:22:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com> <20140127002255.GA10323@ZenIV.linux.org.uk> <CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com> <20140127074208.GB10323@ZenIV.linux.org.uk> <52E6D866.604@amacapital.net> <CA+55aFzWRjNC4kPeVad3isOOW+vZhnzX0Gk5_8QzD16GZEw5Kg@mail.gmail.com> <20140127223257.GE10323@ZenIV.linux.org.uk> <CA+55aFyajjkCtRiTOS2AbFOWi7qt2FUnW6T3iG9nXqoZ0O9Ljg@mail.gmail.com> <CALCETrUXjFYd7ZC958WoNk1mnPCw2kw5jt-Ywo309EObnuqFAg@mail.gmail.com>
In-Reply-To: <CALCETrUXjFYd7ZC958WoNk1mnPCw2kw5jt-Ywo309EObnuqFAg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 02:46 PM, Andy Lutomirski wrote:
> 
> I think that sysret for sigreturn is probably not very interesting.
> On the other hand, sysret for #PF might be a huge win, despite being
> even scarier.
> 

SYSRET for #PF or other exceptions is a nonstarter; register state is
live at that point.

	-hpa



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaKKHwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:52:55 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:43695 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaKKHwy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 11 Nov 2014 02:52:54 -0500
Message-Id: <5461CE6302000078000464C5@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 11 Nov 2014 07:52:51 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Tony Jones" <tonyj@suse.de>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, RFC] x86: also CFI-annotate certain inline asm()s
References: <5458A9600200007800044AE5@mail.emea.novell.com>
 <20141110100117.GA15841@gmail.com>
 <CA+55aFw9MV1n8T7_k5oftfY-sOu8s1ywKYM-3k4+PF022vv9ow@mail.gmail.com>
 <CA+55aFwZYeFtuQbxtAbOoMVNFN_fQKnxGbRybdz-LYRzwMqX9w@mail.gmail.com>
In-Reply-To: <CA+55aFwZYeFtuQbxtAbOoMVNFN_fQKnxGbRybdz-LYRzwMqX9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.11.14 at 19:10, <torvalds@linux-foundation.org> wrote:
> Btw, the sane thing to do is to make your infrastructure just say "If
> my frame walker hits a push/pop without CFI information, I'll just add
> it myself".
> 
> Yes, that involved having to actuall ylook at the instruction. Tough
> shit. Just do it right. There aren't that many push/pop patterns.

Did you think this through? Inspecting instructions while unwinding
the stack would involve significant amounts of architecture specific
code, whereas the unwinder is largely architecture independent.
Apart from code to obtain machine state, only the annotations are
(necessarily) connected to the architecture since they accompany
machine instructions.

Did you ever write a disassembler capable of correctly dealing with
everything a compiler may generate (i.e. including data literals in the
middle of code)?

Anyway - I'm sure I won't convince you now or ever, this is too
religious a topic for you afaict, and hence an objective and fair
discussion is impossible.

Jan


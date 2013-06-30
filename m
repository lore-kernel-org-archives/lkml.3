Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab3F3VtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 17:49:05 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:61382 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab3F3VtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 17:49:03 -0400
Message-ID: <51D0A707.6070803@gmail.com>
Date: Sun, 30 Jun 2013 23:45:43 +0200
From: max <massimiliano.ghilardi@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: RFC: Kernel lock elision for TSX
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 23, 2013 6:11:52 PM UTC+1, Linus Torvalds wrote:
 > On Fri, Mar 22, 2013 at 6:24 PM, Andi Kleen <andi@firstfloor.org> wrote:
 >
 > >
 > > Some questions and answers:
 > >
 > > - How much does it improve performance?
 >
 > > I cannot share any performance numbers at this point unfortunately.
 > > Also please keep in mind that the tuning is very preliminary and
 > > will be revised.
 >
 > If we don't know how much it helps, we can't judge whether it's worth
 > even discussing this patch. It adds enough complexity that it had
 > better be worth it, and without knowing the performance side, all we
 > can see are the negatives.
 >
 > Talk to your managers about this. Tell them that without performance
 > numbers, any patch-series like this is totally pointless.

Hello,

I don't know if the thread is still actual, but I have a Core i7 4770
as my home PC, which supports TSX. I bought it *exactly* to experiment
with hardware transactions.

I am willing to test and benchmark kernel patches, and since I do not
work for Intel I can tell all the quantitative performance differences
I find.

Obviously, they will be *my* results, not official Intel ones -
it's up to Andi Kleen or some other Intel guy to tell if they are ok
or not with this, but since CPUs with TSX are now available in shops,
non-disclosure about their performance seems a bit difficult to
enforce...

--

I can tell from my preliminary performance results that at least for
user-space RTM seems really fast. On my PC, the overhead of an empty
transaction is approximately 11 nanoseconds and a minimal transaction
reading and writing 2 or 3 memory addresses runs in approximately
15-20 nanoseconds.

I just hope I did not violate some non-disclosure condition attached
to the CPU guarantee certificate ;-)

I tested it both with GCC, using inline assembler and .byte directives,
and in Lisp (don't tell anybody), by writing a compiler module that
defines the XBEGIN, XTEST, XABORT and XEND primitives.

--

How can I help?

I would start with the patches already posted by Andi, but the ones
I found in LKML archives seem to belong to at least two different sets
of patches: xy/31 (September 2012) and xy/29 (March 2013) and I could
not find if the first ones are a prerequisite for the second.

Regards,

Massimiliano

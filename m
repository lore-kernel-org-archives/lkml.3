Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaH1Vpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 17:45:44 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:43159 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaH1Vpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 17:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140828213945.GP5001@linux.vnet.ibm.com>
References: <1408972138-12246-1-git-send-email-bobby.prani@gmail.com>
 <53FF8B77.7000103@infradead.org> <20140828210010.GM5001@linux.vnet.ibm.com>
 <CAJhHMCDxsukXe_HW55iJp0oCAWgrosxCRX1AfocS6QBzxaD0pw@mail.gmail.com> <20140828213945.GP5001@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 28 Aug 2014 17:45:10 -0400
Message-ID: <CAJhHMCDaMH0b0Np8vNf=RBH8i76AUK78qf213aWfHY-F4j3OOw@mail.gmail.com>
Subject: Re: [PATCH] doc: memory-barriers.txt: Correct example for reorderings
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 5:39 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Aug 28, 2014 at 05:15:50PM -0400, Pranith Kumar wrote:
>> On Thu, Aug 28, 2014 at 5:00 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> >
>> > I am really confused by the ordering of the new lines, as I would have
>> > expected the "x"s to be replaced with "y"s and vice versa.  But the
>> > ordering of the various combinations does not matter, and each line
>> > looks OK.
>>
>> Since x = A was replaced by x = B and y = B was replaced by y = A, I
>> just converted all x = load A to x = load B. Similarly for y. I think
>> we can do either this or as you suggested replacing x's with y's.
>
> Fair enough.  The other thing that confused me was the "STORE B=4,"
> showing up early in your replacement.
>

So I converted

STORE A=3, x=LOAD A->3

to

STORE B=4, x=LOAD B->4

since the later load into x wanted an updated value of B and not the
default. That is the reason you see STORE B = 4  in place of STORE A =
3


-- 
Pranith

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3BIPH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 10:07:57 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48789 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab3BIPHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 10:07:55 -0500
Message-ID: <1360422473.6696.28.camel@edumazet-glaptop>
Subject: Re: BUG: soft lockup on all kernels after 2.6.3x
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 09 Feb 2013 07:07:53 -0800
In-Reply-To: <20130209141029.GA13493@beaver>
References: <20130209141029.GA13493@beaver>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-09 at 18:10 +0400, Alexey Vlasov wrote:
> Hello.
> 
> I used 2.6.2x kernel for a long time on my shared hosting and I didn't
> have any problems. Kernels worked well and server uptime was about 2-3
> years.
> 
> But investigating some strange hangings of my clients' sites I came to
> this:
> http://bugs.mysql.com/bug.php?id=50399
> from this bug it is clear that on kernels younger than 2.6.32 (
> unfortunately I can't remember if it is true with 2.6.30-31) happens
> mysql client hanging.
> 
> It is not clear whether it is a bug of kernel or libc or mysql-client, I
> didn't manage to find it out. I decided to do simpler (as it seemed to
> me at that moment) to start using 2.6.3x kernels. And that caused
> greater problems. By trying to use new kernels on my working servers
> with peak load I got an uptime from an hour to 1-3 months.
> 
> I even got some statistics for how long can every kernel from version
> 2.6.32 work in peak load situations. It sounds funny but my clients are
> not happy with all these reboots.
> 
> From all the variety of servers from 2.6.32 to 3.7.4 I can say that
> 2.6.35 is the most stabil, I got about 30 servers on it. But they hang
> usually once in 1-3 months.
> 
> Returning to the problem of kernels >= 2.6.32, as I have noticed they
> hang totally alike, giving the console:
> 
> ...
> Feb  8 10:27:45 10.2.0.7 [470393.417168] BUG: soft lockup - CPU#2 stuck for 61s! [vsftpd:29013]
> ...
> [see the attachment]
> 
> it doesn't happen on an empty server, only on loaded ones. Unfortunately
> I don't know how to provoke such hanging artificially.
> 
> I' ve given a trace attached. In fact I don't know what to do with all
> these bugs, I can't use 2.6.2x because of MySQL hanging and = >2.6.3
> start hanging themselves.
> 

Did you compile the kernel yourself, or is it a standard kernel (distro
provided) ?

Your traces dont contain symbols, its quite hard to guess the issue.



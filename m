Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaJ1PpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:45:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:49596 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaJ1PpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:45:04 -0400
Date: Tue, 28 Oct 2014 16:45:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?P=E1draig_Brady?= <P@draigBrady.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Eggert <eggert@cs.ucla.edu>, bug-gnulib <bug-gnulib@gnu.org>
Subject: Re: nanosleep truncated on 64 bit Linux by 292 billion years
In-Reply-To: <544DC3A8.1060103@draigBrady.com>
Message-ID: <alpine.DEB.2.11.1410281644070.5308@nanos>
References: <53E0FF15.4090808@draigBrady.com> <53E13F04.70609@cs.ucla.edu> <alpine.DEB.2.10.1408060017090.3323@nanos> <544DC3A8.1060103@draigBrady.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-748278803-1414511101=:5308"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-748278803-1414511101=:5308
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 27 Oct 2014, Pádraig Brady wrote:
> I noticed that nanosleep() on 64 bit, "only" supports 292 years,
> rather than the full potential 292 billion years with 64 bit time_t, due to:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/linux/time.h?id=refs/tags/v3.16#n87
> 
> Attached is a program from Paul Eggert that illustrates the bug.
> Running this program on a buggy host outputs something like this:
> 
>   Setting alarm for 1 second from now ...
>   Sleeping for 9223372036854775807.999999999 seconds...
>   After alarm sent off, remaining time is 9223357678.462306617 seconds;
>   i.e., nanosleep claimed that it slept for about 293079448610.606445 years.

I'm aware of the issue. It's on my ever growing todo list.

Thanks,

	tglx
--8323329-748278803-1414511101=:5308--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab3ELSTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 14:19:48 -0400
Received: from canardo.mork.no ([148.122.252.1]:42199 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab3ELSTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 14:19:47 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: paulmck@linux.vnet.ibm.com
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [v3.10-rc1] WARNING: at kernel/rcutree.c:502
Organization: m
References: <87ip2opntp.fsf@nemi.mork.no>
	<20130512113905.GH3648@linux.vnet.ibm.com>
	<87li7kp50r.fsf@nemi.mork.no>
	<20130512172135.GJ3648@linux.vnet.ibm.com>
Date: Sun, 12 May 2013 20:19:34 +0200
In-Reply-To: <20130512172135.GJ3648@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Sun, 12 May 2013 10:21:35 -0700")
Message-ID: <87a9o0ukll.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> On Sun, May 12, 2013 at 05:55:00PM +0200, Bjørn Mork wrote:
>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>> > On Sun, May 12, 2013 at 11:08:50AM +0200, Bjørn Mork wrote:
>> >> Hello,
>> >> 
>> >> got the splat below when running powertop on plain v3.10-rc1
>> >> (i.e. without my previously mentioned revert patch or any other extra
>> >> patches).  Config attached.
>> >
>> > OK, it looks like you have context-tracking enabled, so you might be
>> > hitting a bug that Steven Rostedt found a few days ago.  Could you
>> > please try out his fix below?
>> 
>> Thanks for the quick reply, but I'm afraid that patch had no effect on
>> the warning I got. It's still there.
>
> Other than wondering whether powertop has issues similar to the bug
> Steven Rostedt located, I must confess myself clueless.  Here are some
> diagnostics I can suggest:
>
> 1.	Run in 32-bit mode.  This disables some of the new adaptive-ticks
> 	functionality, so might give a probabilistic indication of where
> 	the bug lies.
>
> 2.	The standard fallback of bisection.
>
> Would you be willing to do either of these?

Willing, yes. But it will take some time before I am able to do either
unless I can recreate the problem in a virtual machine.  I assume that
you by " 32-bit mode" mean a 32bit kernel?  I'm not exactly set up to
run that on my laptop.  Bisection will be less work.

To be honest, I don't even know how old this thing is.  It could be
totally unrelated to your recent changes for all I know. Running
powertop is something I do once every 6 kernel releases or something
like that...

I'll see what I can come up with.  Thanks for your attention.


Bjørn

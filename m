Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975AbaDIPVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:21:06 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:57046 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256AbaDIPVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:21:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140409103138.29be16b9@gandalf.local.home>
References: <20131113113927.GA13875@mwhitehe.csb>
	<alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
	<20131113102153.5f10e6b5@gandalf.local.home>
	<20131113103134.5b8cf02f@gandalf.local.home>
	<20131113105737.3f7a0b1b@gandalf.local.home>
	<alpine.DEB.2.02.1311131706260.30673@ionos.tec.linutronix.de>
	<20131113111257.482c2955@gandalf.local.home>
	<20131113161829.GE4138@linux.vnet.ibm.com>
	<20131113112338.7d303c0f@gandalf.local.home>
	<20131113163552.GF4138@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
	<CAOh2x=koQ4tXdq5_Bi4Vbo_k1a=zosFA3e4zRJGjzysYmC-PEA@mail.gmail.com>
	<20140409103138.29be16b9@gandalf.local.home>
Date: Wed, 9 Apr 2014 20:50:59 +0530
Message-ID: <CAKohponY+4y8G875wy4GsO1hTqERc7-hYKY6uQvLn28+32VxVQ@mail.gmail.com>
Subject: Re: nohz problem with idle time on old hardware
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matthew Whitehead <tedheadster@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2014 20:01, Steven Rostedt <rostedt@goodmis.org> wrote:
> Ouch! You are correct, this part of the patch makes no sense. That's
> what I get for reviewing a patch and not looking at all the code around
> the changes. (another kernel developer hangs head in shame :-( )
>
> I think that if statement should be nuked.

Hmm, my opinion differs here :)

If we completely remove this statement, we will run
tick_nohz_switch_to_nohz() even if nohz is not enabled. And check for
enabled must stay.

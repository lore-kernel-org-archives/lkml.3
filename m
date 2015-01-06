Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbbAFVSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:18:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbbAFVR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:17:59 -0500
Date: Tue, 6 Jan 2015 13:17:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Kiran Raparthy <kiran.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v4] debug: prevent entering debug mode on panic/exception.
Message-Id: <20150106131758.0d6eb85279f678691443b8ef@linux-foundation.org>
In-Reply-To: <54ABFE7F.6090904@linaro.org>
References: <1419338309-16729-1-git-send-email-kiran.kumar@linaro.org>
	<20150105161412.44f53313e1d771dc9f968264@linux-foundation.org>
	<54ABFE7F.6090904@linaro.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2015 15:25:51 +0000 Daniel Thompson <daniel.thompson@linaro.org> wrote:

> >> To avoid entering the debugger on panic/exception without any extra
> >> configuration, panic_timeout is being used which can be set via
> >> /proc/sys/kernel/panic at run time and CONFIG_PANIC_TIMEOUT sets the default
> >> value.
> >>
> >> ...
> >>
> > 
> > hm.  Why overload the meaning of panic_timeout in this fashion?  If
> > someone is using kgdb and has panic_timeout set, they'll get quiet a
> > surprise.
> 
> Will they?
> 
> Setting panic_timeout means the user explicitly requested that the
> machine try to perform an unattended reboot after a panic. Wedging in
> kgdb during panic on such a system absolutely contradicts the user's
> request to have an automated reboot.
> 
> In this case it is not overloading the meaning... we are simply altering
> kgdb to properly honour the existing meaning.
> 
> Changing the behaviour for exceptions as well as for panics *might*
> maybe veer into overloading but even there, I think we are simply better
> reflecting user intent. It is hard to imagine a user that wants
> automatic-reboot-on-panic being happy for the kernel to get stuck
> overnight just because of an oops.

OK, when you put it that way...

Kiran, could we please have an updated patch which includes the above
observations in the changelog and which documents panic_timeout?

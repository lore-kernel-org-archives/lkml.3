Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaKDI1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:27:37 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59045 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKDI1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:27:34 -0500
Date: Tue, 4 Nov 2014 09:27:28 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, Pawel Moll <pawel.moll@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Pawel Moll <mail@pawelmoll.com>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event
 generation
Message-ID: <20141104082728.GB4253@localhost.localdomain>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
 <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
 <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
 <3430954.VNaFmamXmP@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3430954.VNaFmamXmP@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:01:31AM +0100, Arnd Bergmann wrote:
> On Monday 03 November 2014 17:11:53 John Stultz wrote:
> > I've got some thoughts on what a possible interface that wouldn't be
> > awful could look like, but I'm still hesitant because I don't really
> > know if exposing this sort of data is actually a good idea long term.
>  
> I was also thinking (while working on an unrelated patch) we could use
> a system call like
> 
> int clock_getoffset(clockid_t clkid, struct timespec *offs);
> 
> that returns the current offset between CLOCK_REALTIME and the
> requested timebase. It is of course racy, but so is every use
> of CLOCK_REALTIME. We could also use a reference other than
> CLOCK_REALTIME that might be more stable, but passing two arbitrary
> clocks as input would make this much more complex to implement.

No, it is really easy to implement. Just drop the idea of "atomic". It
really is not necessary or even possible.

Thanks,
Richard

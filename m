Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaKDQMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:12:42 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:50761 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaKDQMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:12:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, Pawel Moll <pawel.moll@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Pawel Moll <mail@pawelmoll.com>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event generation
Date: Tue, 04 Nov 2014 17:11:47 +0100
Message-ID: <2022010.zd45j2gEWl@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1411041111010.5308@nanos>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com> <20141104082728.GB4253@localhost.localdomain> <alpine.DEB.2.11.1411041111010.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Cnel/rO4INuWapA6WSh31QtAO1itNk392LfXkxFRQkJ
 TI2hERZeHLjf7c7H5pXnUWUND5uj6YFKMKLutrSd4EkMSIgy6K
 Jtf/X+5yhPmOH2GGoF5kwOva4xLEI305DjPEdHSHJMgD13NXA9
 XYXcmbDbYn4LvhDRClo3Jn1ZS6QZkVHe0ALI0OBBRtz7Iv3JX7
 mcJTQVMbkU9/s5DmgKc1Pu7bM9+7b5w3aBjSWtmLN/iV497/m+
 YMAcRdrza7FK8fXB6+bt4Csa+0CeilWEvHkk6h+zQ98FfHI5qd
 oR6utd0RUsDNOrc/G2nE/Jf0VEizN8ZFYgEgamD+CYjOW+LUqn
 NIUWePKUX7OtLtdQxmNE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 November 2014 11:49:04 Thomas Gleixner wrote:
> On Tue, 4 Nov 2014, Richard Cochran wrote:
> 
> > On Tue, Nov 04, 2014 at 09:01:31AM +0100, Arnd Bergmann wrote:
> > > On Monday 03 November 2014 17:11:53 John Stultz wrote:
> > > > I've got some thoughts on what a possible interface that wouldn't be
> > > > awful could look like, but I'm still hesitant because I don't really
> > > > know if exposing this sort of data is actually a good idea long term.
> > >  
> > > I was also thinking (while working on an unrelated patch) we could use
> > > a system call like
> > > 
> > > int clock_getoffset(clockid_t clkid, struct timespec *offs);
> 
> We might make *offs a timespec64 or u64 

I don't think we are ready yet to introduce timespec64 in the uapi
headers, this needs some more careful planning. Otherwise I agree
it's bad to introduce syscalls that we already know will become
obsolete soon.

	Arnd

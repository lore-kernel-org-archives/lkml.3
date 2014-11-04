Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaKDICc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:02:32 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:52264 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaKDIC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:02:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Pawel Moll <pawel.moll@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
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
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event generation
Date: Tue, 04 Nov 2014 09:01:31 +0100
Message-ID: <3430954.VNaFmamXmP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com> <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com> <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:txJ0H+hZ2+1L2O/S3sfp83JNRCljdw2DyatBpuXBKci
 WUmOg2knPQ55ooGLOdgmHGDgklzuCjjdl1iEluySMqChKhJkkh
 9UDeFHJ53iD8+B2ea4bDiDLBU6GtapAIMQnbMJg2rBiNKhK5Zs
 xJE6sIF3WE/yeNgxG+MFu5h2GtvpMqMoa75JZaifw1aNIi5rqP
 w+l2HEfue8JtEfINwoZCYhiQnLyJ/7zBzQsp2etgIBziLCo9Av
 w4GAOW9BWKyk2gDzshBzT9e1iDCJq6vHQ4SlbcSIaiD5/cyWv5
 rIg2wmN+SHp+7XyLbbN+PmWjbV+xpNeCmfLvp0/c7uUAN/POFV
 wuamchppjquCBC6Q2S4E=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 November 2014 17:11:53 John Stultz wrote:
> I've got some thoughts on what a possible interface that wouldn't be
> awful could look like, but I'm still hesitant because I don't really
> know if exposing this sort of data is actually a good idea long term.
 
I was also thinking (while working on an unrelated patch) we could use
a system call like

int clock_getoffset(clockid_t clkid, struct timespec *offs);

that returns the current offset between CLOCK_REALTIME and the
requested timebase. It is of course racy, but so is every use
of CLOCK_REALTIME. We could also use a reference other than
CLOCK_REALTIME that might be more stable, but passing two arbitrary
clocks as input would make this much more complex to implement.

	Arnd

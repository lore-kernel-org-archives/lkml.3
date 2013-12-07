Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab3LGIkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 03:40:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51217 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3LGIkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 03:40:22 -0500
Message-ID: <1386405590.5673.96.camel@marge.simpson.net>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Mike Galbraith <bitbucket@online.de>
To: Len Brown <lenb@kernel.org>
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Date: Sat, 07 Dec 2013 09:39:50 +0100
In-Reply-To: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:tLwg913UNXw3XnAC2CRRtBXUkRnnDMXc3QCGGDCf8Ye
 P+GZYy4mzS15kNjRWDqeUky5iHIAs6pKqtXAWc3l1t4NYrQPW9
 BkDmKBekljRqdFTrqOPrxfyIwKQpZ3QL1RXcxY4SpeIvz2fQIO
 PN0S6syed6YoNRUtipdu4M0DShP4MKF5LotCl4Gm5xsF3ThAbX
 oFaPCGSDHaMITINUtyVZQagYOvCOT8GxsfxmnufwfI92eekjgr
 eKWXABmKx/oo87QQq8ynx0ZEHSuNeYbBlrkG93U7mfca87/sao
 Xc4fGUQEf40qqB7zjsKB0RIcyLZMKR46EV7gg5NZro5FT4S5Qc
 xk5UjvM9gyuTmEeiLd83ZfAfha75Xi60XnRjiMK8ctUzfttPXU
 OvlAYqQzq481g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-07 at 03:00 -0500, Len Brown wrote:

> No, Linux-3.13-rc3 does not fix this issue, even though it contains
> the following patch, claiming to address an issue with the commit above:
> 
> commit ea8117478918a4734586d35ff530721b682425be
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Wed Sep 11 12:43:13 2013 +0200
> 
>     sched, idle: Fix the idle polling state logic
> 
>     Mike reported that commit 7d1a9417 ("x86: Use generic idle loop")
>     regressed several workloads and caused excessive reschedule
>     interrupts.

It fixes that, except for my Q6600 box.  Too bad mwait_idle() went away,
beloved old box doesn't play hints game, so it continues to flog itself.

-Mike


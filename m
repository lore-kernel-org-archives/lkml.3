Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaBCCnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 21:43:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaBCCnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 21:43:23 -0500
Message-ID: <1391395399.5357.16.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] irq_work: allow certain work in hard irq context
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de
Date: Mon, 03 Feb 2014 03:43:19 +0100
In-Reply-To: <52EEA643.1010200@linutronix.de>
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
	 <1391314950.5444.18.camel@marge.simpson.net>
	 <52EEA643.1010200@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:GP2LuTMC4MF05olRrtYJnxkFCSJ3PHuQJgQIqYZ5QJP
 I0t7CBYfvKhLxqcpAbH3BhcdXUE42GqluiIGKakxrVcIlsj3TS
 k4ZG4nNiKjdEq3Sb7lPelbWQ7u8VnUnwVhnon4Zpe7X5dkxvOw
 WiJftoeR+NJkVfaynKMGWv5XAqfXCJP2RTyATGyz7qj3YjT87C
 Ti3mxXKlDlKgiGBR0kGCmm3ZriUAOtDlE6jkj1piakjb3SNlYT
 tIliCiLNwVYdh6DBr0CaljN78pv2LLxOZ3w4Mm/5mBd1ZT300a
 xNqdHUymQeFsAqE/o4VYm4o/iyvj6DvWBOV+QJEBDnjrvJlaG2
 XapgKr1W58AA0Rav9DlgnCf4bbhntDrNxwXidKZYQ/hM0P7yM1
 kBxPsSD5c67+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-02 at 21:10 +0100, Sebastian Andrzej Siewior wrote:

> So CPU5 & CPU52 were eating 100% CPU doing "nothing" instead of running
> cc1 & objdump right?

Yeah.

> According to the backtrace both of them are trying to access the
> per-cpu hrtimer (sched_timer) in order to cancel but they seem to fail
> to get the timer lock here. They shouldn't spin there for minutes, I
> have no idea why they did so…

I dumped it for later-guy.. but he tends to get busy doing other crap,
and just whacks my carefully saved data ;-)

> I guess this problem does not occur without -RT and before that patch
> you saw only that one warning from can_stop_full_tick()?

I didn't try it without -RT, and yes, without, you just get the warning.

-Mike


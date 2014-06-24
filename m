Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965439AbaFXQ52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:57:28 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:48277 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964864AbaFXQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:57:26 -0400
X-Yandex-Uniq: e11e4595-6a91-4faf-b23b-ef3b97325e3b
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 24 Jun 2014 20:57:12 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com,
        rusty@rustcorp.com.au, bp@suse.de, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v4 0/4] perf timechart io mode
Message-ID: <20140624165712.GA10114@stfomichev-desktop.yandex.net>
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
 <20140624084113.GC31390@krava.redhat.com>
 <20140624091022.GE20225@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624091022.GE20225@stfomichev-desktop.yandex.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 01:10:22PM +0400, Stanislav Fomichev wrote:
> > hum, got this when trying:
> > 
> > [jolsa@krava perf]$ sudo ./perf timechart record -I
> > ^C[ perf record: Woken up 2 times to write data ]
> > [ perf record: Captured and wrote 1.071 MB perf.data (~46806 samples) ]
> > [jolsa@krava perf]$ ./perf timechart
> > Invalid previous event (non-zero)!
> > 0x113f80 [0x8]: failed to process type: 68
> Hm, I added a bunch of consistency checks which I couldn't actually hit
> myself. Nice work :-) Can I get you perf.data?

For some reason, in Jiri's trace we see exit from sys_read with 2,
and then again exit from sys_read with -EAGAIN:
            xterm 32028 [000] 43390.908909: syscalls:sys_enter_read: fd: 0x00000004, buf: 0x02076e8c, count: 0x0
            xterm 32028 [000] 43390.908917: syscalls:sys_exit_read: 0x2
            xterm 32028 [000] 43390.908982: syscalls:sys_exit_read: 0xfffffffffffffff5

I'm not sure how it is possible (either we lost sys_enter, or timestamp
of seconds -EAGAIN is wrong?). I think we might just convert this error
to a warning (we couldn't reproduce it again).
Should I resend the whole series (preferred) or add another patch on
top?

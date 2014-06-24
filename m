Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaFXRB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:01:59 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:49545 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753656AbaFXRB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:01:58 -0400
X-Yandex-Uniq: d9e4953f-4e8a-4551-a9b9-2e3d6b343a3c
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 24 Jun 2014 21:01:53 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com,
        rusty@rustcorp.com.au, bp@suse.de, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v4 0/4] perf timechart io mode
Message-ID: <20140624170153.GC10114@stfomichev-desktop.yandex.net>
References: <1403260191-10079-1-git-send-email-stfomichev@yandex-team.ru>
 <20140624084113.GC31390@krava.redhat.com>
 <20140624091022.GE20225@stfomichev-desktop.yandex.net>
 <20140624165712.GA10114@stfomichev-desktop.yandex.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624165712.GA10114@stfomichev-desktop.yandex.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For some reason, in Jiri's trace we see exit from sys_read with 2,
> and then again exit from sys_read with -EAGAIN:
>             xterm 32028 [000] 43390.908909: syscalls:sys_enter_read: fd: 0x00000004, buf: 0x02076e8c, count: 0x0
>             xterm 32028 [000] 43390.908917: syscalls:sys_exit_read: 0x2
>             xterm 32028 [000] 43390.908982: syscalls:sys_exit_read: 0xfffffffffffffff5
> 
> I'm not sure how it is possible (either we lost sys_enter, or timestamp
> of seconds -EAGAIN is wrong?). I think we might just convert this error
> to a warning (we couldn't reproduce it again).
> Should I resend the whole series (preferred) or add another patch on
> top?

Or probably left it as is, because perf.data is really weird...

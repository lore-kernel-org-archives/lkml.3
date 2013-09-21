Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3IUA3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 20:29:40 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50584 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3IUA3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 20:29:38 -0400
X-Nat-Received: from [202.181.97.72]:51635 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379723297.18439
To: keescook@chromium.org, jslaby@suse.cz
Cc: viro@zeniv.linux.org.uk, xemul@openvz.org, remi.denis-courmont@nokia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux@horizon.com,
        akpm@linux-foundation.org, dan.carpenter@oracle.com,
        geert@linux-m68k.org, JBeulich@suse.com, joe@perches.com,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309191756.BCF65661.MQFOLSJOFHFtOV@I-love.SAKURA.ne.jp>
	<CAGXu5jK_D1BJOQr=1A-UFrpM5Ad+Qu894HT_XjkZh4EmsbCkTQ@mail.gmail.com>
	<201309201309.GFB52620.OQOtSFLMJVHOFF@I-love.SAKURA.ne.jp>
	<523C0268.20404@suse.cz>
	<CAGXu5jLENb+x6b9XOY7-pWMT7GsFgnLr0=A8VNFLkqMi0BX4=w@mail.gmail.com>
In-Reply-To: <CAGXu5jLENb+x6b9XOY7-pWMT7GsFgnLr0=A8VNFLkqMi0BX4=w@mail.gmail.com>
Message-Id: <201309210928.JCF90671.OtOFLFQSOJVFMH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 21 Sep 2013 09:28:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 20092013 #11079105, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> >> -                     seq_printf(seq, "%*s\n", 127 - len, "");
> >> +                     seq_pad(seq, '\n');
> >
> > Hmm, seq_pad is unintuitive. I would say it pads the string by '\n'. Of
> > course it does not, but...
> 
> I don't think this is a very serious problem. Currently, the padding
> character is always ' ' for all existing callers, so it only makes
> sense to make the trailing character an argument.

If you want, we can rename seq_pad() to seq_pad_and_putc(). Also we can pass
both the padding character (e.g. ' ') and the trailing character (e.g. '\n')
like seq_pad_and_putc((' ' << 8) | '\n'), though I wonder someone wants to
use '\0', '\t', '\n' etc. as the padding character...

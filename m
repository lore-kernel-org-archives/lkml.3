Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab3ISCMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 22:12:51 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63239 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3ISCMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 22:12:50 -0400
X-Nat-Received: from [202.181.97.72]:61311 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379556717.20584
To: keescook@chromium.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, joe@perches.com,
        linux@horizon.com, dan.carpenter@oracle.com, JBeulich@suse.com,
        kosaki.motohiro@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] vsprintf: ignore %n again
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
	<20130916155504.GC13318@ZenIV.linux.org.uk>
	<CAGXu5jK2d+9m0uA84nGbZ5E=s974NRn+Sxz3iRcTsFWqWFTGNQ@mail.gmail.com>
	<201309182214.IDD13060.FFOVJOLOFQtHSM@I-love.SAKURA.ne.jp>
	<CAGXu5jKztpsUwTCa0dMNHUS==dPQE02FvT=xjNfZLK80NSriXQ@mail.gmail.com>
In-Reply-To: <CAGXu5jKztpsUwTCa0dMNHUS==dPQE02FvT=xjNfZLK80NSriXQ@mail.gmail.com>
Message-Id: <201309191111.HEI73985.FMOVFHtQFLOOSJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 19 Sep 2013 11:11:57 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 18092013 #11098720, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> > ---------- output start ----------
> > const : literal
> > not const : const char *
> > not const : const char []
> > const : const char * const
> 
> What version of gcc did you use? I don't get the last as const, for
> some reason. And as Dan mentions, shouldn't const char[] be detected
> as const too?

This worked on

  gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-3)
  gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)

with -On (where n != 0), but didn't work on

  gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3

. Oops...

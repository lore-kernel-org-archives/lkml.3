Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384AbaFLLzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:55:04 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55309 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268AbaFLLy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:58 -0400
X-Nat-Received: from [202.181.97.72]:40327 [ident-empty]
	by ksav112.sakura.ne.jp with TPROXY id 1402574020.15209
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, peterz@infradead.org, mingo@kernel.org,
        takedakn@nttdata.co.jp, linux-security-module@vger.kernel.org
Subject: Re: [patch 13/13] tomoyo: Use sensible time interface
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140611234024.103571777@linutronix.de>
	<20140611234607.775273584@linutronix.de>
In-Reply-To: <20140611234607.775273584@linutronix.de>
Message-Id: <201406122053.CHI48403.HQFMOVFOFSLJOt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 12 Jun 2014 20:53:38 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-KLMS-AntiVirus: Kaspersky Security 8.0 for Linux Mail Server, version 8.0.1.705 status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> There is no point in calling gettimeofday if only the seconds part of
> the timespec is used. Use get_seconds() instead. It's not only the
> proper interface it's also faster.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
> Cc: linux-security-module@vger.kernel.org

Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

John Stultz wrote:
> do_gettimeofday()  { 99, 888....}
> get_seconds()   { 99 }
> do_gettimeofday()  { 99, 999....}
> get_seconds()   { 99 }
> do_gettimeofday()  { 100, 000....}
> get_seconds()   { 99 }
> do_gettimeofday()  { 100, 011....}
> get_seconds()   { 100 }

That will be acceptable error for TOMOYO. Thank you.

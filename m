Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3JAIsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:48:37 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61976 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3JAIsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:48:35 -0400
Date: Tue, 1 Oct 2013 10:48:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tool: don't print bogus data on -e instructions
Message-ID: <20131001084831.GG21793@gmail.com>
References: <1380616604-4077-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380616604-4077-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ramkumar Ramachandra <artagnon@gmail.com> wrote:

> When only the instructions event is requested:
> 
> $ perf stat -e instructions git s
> M  builtin-stat.c
> 
>  Performance counter stats for 'git s':
> 
>        917,453,420 instructions              #    0.00  insns per cycle
> 
>        0.213002926 seconds time elapsed
> 
> The 0.00 insns per cycle comment in the output is totally bogus and
> misleading. It happens because update_shadow_stats() doesn't touch
> runtime_cycles_stats when only the instructions event is requested. So,
> omit printing the bogus data altogether.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

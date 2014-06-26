Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaFZPhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:37:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:43796 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbaFZPhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:37:31 -0400
Message-ID: <53AC3E37.1010603@linutronix.de>
Date: Thu, 26 Jun 2014 17:37:27 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tzanussi@gmail.com, jolsa@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf script/python: Print array argument as string
References: <1401338695-18837-1-git-send-email-namhyung@kernel.org> <tip-e646fe730a324098a718f1c9b2f349efb99d5457@git.kernel.org>
In-Reply-To: <tip-e646fe730a324098a718f1c9b2f349efb99d5457@git.kernel.org>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 02:01 PM, tip-bot for Namhyung Kim wrote:

> Commit-ID:  e646fe730a324098a718f1c9b2f349efb99d5457
> Gitweb:     http://git.kernel.org/tip/e646fe730a324098a718f1c9b2f349efb99d5457
> Author:     Namhyung Kim <namhyung@kernel.org>
> AuthorDate: Thu, 29 May 2014 13:44:55 +0900
> Committer:  Jiri Olsa <jolsa@kernel.org>
> CommitDate: Mon, 9 Jun 2014 12:21:03 +0200
> 
> perf script/python: Print array argument as string
> 
> With the Sebastian's change of handling num array argument (of raw
> syscall enter), the script still failed to work like this:

This patch got merged. It fixes something that was introduced by
  "perf script: move the number processing into its own function" [0]
  "perf script: handle the num array type in python properly" [1]

which was not yet merged.

[0] lkml.kernel.org/r/1401207274-8170-1-git-send-email-bigeasy@linutronix.de
[1] lkml.kernel.org/r/1401207274-8170-2-git-send-email-bigeasy@linutronix.de

>   $ perf record -e raw_syscalls:* sleep 1
>   $ perf script -g python
>   $ perf script -s perf-script.py
>   ...
>   Traceback (most recent call last):
>     File "perf-script.py", line 42, in raw_syscalls__sys_enter
>       (id, args),
>   TypeError: %u format: a number is required, not list
>   Fatal Python error: problem in Python trace event handler
>   Aborted (core dumped)
> 
> This is because the generated script tries to print the array arg as
> unsigned integer (%u).  Since the python seems to convert arguments to
> strings by default, just using %s solved the problem for me.

Sebastian

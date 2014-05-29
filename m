Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbaE2En0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:43:26 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62602 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808AbaE2EnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:43:22 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 2/2] perf script: handle the num array type in python properly
References: <1401207274-8170-1-git-send-email-bigeasy@linutronix.de>
	<1401207274-8170-2-git-send-email-bigeasy@linutronix.de>
Date: Thu, 29 May 2014 13:43:20 +0900
In-Reply-To: <1401207274-8170-2-git-send-email-bigeasy@linutronix.de>
	(Sebastian Andrzej Siewior's message of "Tue, 27 May 2014 18:14:34
	+0200")
Message-ID: <87d2exgpp3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014 18:14:34 +0200, Sebastian Andrzej Siewior wrote:
> The raw_syscalls:sys_enter tracer for instance passes has one argument
> named 'arg' which is an array of 6 integers. Right the python scripts
> gets only 0 passed as an argument. The reason is that
> pevent_read_number() can not handle data types of 48 and returns always
> 0.
> This patch changes this by passing num array as list of nums which fit
> the description. As a result python will now see a list named arg which
> contains 6 (integer) items.

Acked-by: Namhyung Kim <namhyung@kernel.org>

But this requires a change in generation time as I faced a type error
when try to print an array argument as number.  I'll post a separate
patch for this.

Thanks,
Namhyung

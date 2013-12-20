Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab3LTH6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:58:05 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:52746 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab3LTH6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:58:03 -0500
Date: Fri, 20 Dec 2013 08:57:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Do not show stats if workload fails
Message-ID: <20131220075759.GA12937@gmail.com>
References: <1387518748-25340-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387518748-25340-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> Currently perf-stat attempts to show counter stats even if the workload
> is bogus:
> 
> $ perf stat -- foo
> foo: No such file or directory
> 
>  Performance counter stats for 'foo':
> 
>      <not counted>      task-clock
>      <not counted>      context-switches
>      <not counted>      cpu-migrations
>      <not counted>      page-faults
>      <not counted>      cycles
>      <not counted>      stalled-cycles-frontend
>      <not counted>      stalled-cycles-backend
>      <not counted>      instructions
>      <not counted>      branches
>      <not counted>      branch-misses
> 
>        0.009769943 seconds time elapsed
> 
> It is impossible to differentiate all the failure modes, but it seems
> reasonable that if the workload handling fails, perf-stat should not try
> to print stats.
> 
> With this change:
> 
> $ perf stat  -v -- foo
> Failed to start workload
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Stephane Eranian <eranian@google.com>

Nice!

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo

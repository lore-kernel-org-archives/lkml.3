Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbaLKS6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:58:32 -0500
Received: from www.linutronix.de ([62.245.132.108]:59369 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbaLKS6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:58:31 -0500
Message-ID: <5489E937.2050102@linutronix.de>
Date: Thu, 11 Dec 2014 19:57:59 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 4/8] perf data: Add a 'perf' prefix to the generic fields
References: <1418310749-22267-1-git-send-email-jolsa@kernel.org> <1418310749-22267-5-git-send-email-jolsa@kernel.org> <5489E88A.3000801@gmail.com>
In-Reply-To: <5489E88A.3000801@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 07:55 PM, David Ahern wrote:
> On 12/11/14 8:12 AM, Jiri Olsa wrote:
> 
>> Before:
>>    $ babeltrace ./ctf-data/
>>    [03:19:13.962131936] (+0.000001935) cycles: { }, { ip =
>> 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 8 }
>>    [03:19:13.962133732] (+0.000001796) cycles: { }, { ip =
>> 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 114 }
>>    ...
>>
>> Now:
>>    $ babeltrace ./ctf-data/
>>    [03:19:13.962131936] (+0.000001935) cycles: { }, { perf_ip =
>> 0xFFFFFFFF8105443A, perf_tid = 20714, perf_pid = 20714, perf_period = 8 }
>>    [03:19:13.962133732] (+0.000001796) cycles: { }, { perf_ip =
>> 0xFFFFFFFF8105443A, perf_tid = 20714, perf_pid = 20714, perf_period =
>> 114 }
>>    ...
> 
> How is babeltrace showing time-of-day for perf-based data files? Is that
> tod when the command is run?

CTF needs an a base offset which we set to 0 because we don't have it.
It then takes the NS timestamp and computes the "time".

> David

Sebastian

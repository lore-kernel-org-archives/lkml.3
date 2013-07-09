Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3GIOT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:19:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59253 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3GIOTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:19:55 -0400
Message-ID: <51DC1C05.6040500@gmail.com>
Date: Tue, 09 Jul 2013 08:19:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Al Cooper <alcooperx@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        mingo@infradead.org, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Build failure when python-devel not installed
References: <20130709131926.GA3260@ghostprotocols.net>
In-Reply-To: <20130709131926.GA3260@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/13 7:19 AM, Arnaldo Carvalho de Melo wrote:
> Hi,
>
> 	While trying to build perf on a freshly installed Fedora 18
> machine I couldn't do it if python-devel isn't installed.
>
> 	The expected behaviour is for a warning to be emitted and the
> build to continue.
>
> 	I bisected it down to:
>
> commit 31160d7feab786c991780d7f0ce2755a469e0e5e
> "perf tools: Fix GNU make v3.80 compatibility issue"
>
> 	If I revert this changeset, everything works as expected, I get:
>
> config/Makefile:319: The path '/usr/bin/python-config' is not executable.
> config/Makefile:323: No python-config tool was found
> config/Makefile:323: Python support will not be built

https://lkml.org/lkml/2013/4/15/148

Suggested patch at the bottom of https://lkml.org/lkml/2013/4/16/577

David

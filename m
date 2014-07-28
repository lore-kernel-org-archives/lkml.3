Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaG1BEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 21:04:11 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:46860 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaG1BEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 21:04:10 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
	<20140725131521.GI7831@kernel.org>
Date: Mon, 28 Jul 2014 10:04:07 +0900
In-Reply-To: <20140725131521.GI7831@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Fri, 25 Jul 2014 10:15:21 -0300")
Message-ID: <87fvhmi9a0.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Fri, 25 Jul 2014 10:15:21 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jul 25, 2014 at 10:31:47AM +0900, Namhyung Kim escreveu:
>> Minchan reported that perf failed to load vmlinux if --symfs argument
>> doesn't end with '/' character.  So make sure that the symfs always
>> ends with the '/'.
>
> I don't think this is the right way of doing this, users of
> symbol_conf.symfs should instead make sure that they do what they expect
> to, i.e. if they want it to be a base directory, make sure that a path
> separator is added between it and the relative path following it, if
> not, do as they please.

Hmm.. what's the usecase of non-directory symfs?  I guess realpath(3)
already nullifies such case and defaults to no symfs..

Thanks,
Namhyung

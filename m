Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaE0BFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:05:33 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49734 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbaE0BFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:05:30 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/14] perf tools: Cache dso data file descriptor
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
	<1400174615-2121-7-git-send-email-jolsa@kernel.org>
Date: Tue, 27 May 2014 10:05:28 +0900
In-Reply-To: <1400174615-2121-7-git-send-email-jolsa@kernel.org> (Jiri Olsa's
	message of "Thu, 15 May 2014 19:23:27 +0200")
Message-ID: <87tx8chvzb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 15 May 2014 19:23:27 +0200, Jiri Olsa wrote:

[SNIP]
> +static void data_close(void)
> +{
> +	bool cache_fd = may_cache_fd();
> +
> +	if (!cache_fd)
> +		close_first_dso();
> +}

Why do you do this at close()?  As long as there's no attempt to open a
new file, we can keep existing fd, no?

> +
> +void dso__data_close(struct dso *dso)
> +{
> +	if (dso->data.fd >= 0)
> +		data_close();
> +}

Hmm.. it's confusing dso__data_close(dso) closes an other dso rather
than the given dso.  And this dso__data_close() is not paired with any
_open() also these close calls make me confusing which one to use. ;-p


Thanks
Namhyung

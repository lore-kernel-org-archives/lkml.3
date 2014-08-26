Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbaHZHqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:46:30 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54802 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860AbaHZHqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:46:25 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 10/10] tools lib api: Adopt fdarray class from perf's evlist
References: <1408741190-5123-1-git-send-email-acme@kernel.org>
	<1408741190-5123-11-git-send-email-acme@kernel.org>
Date: Tue, 26 Aug 2014 16:46:18 +0900
In-Reply-To: <1408741190-5123-11-git-send-email-acme@kernel.org> (Arnaldo
	Carvalho de Melo's message of "Fri, 22 Aug 2014 17:59:50 -0300")
Message-ID: <87k35vbsmt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Fri, 22 Aug 2014 17:59:50 -0300, Arnaldo Carvalho de Melo wrote:
> +int fdarray__add(struct fdarray *fda, int fd)
> +{
> +	/*
> +	 * XXX: 64 is arbitrary, just not to call realloc at each fd.
> +	 *	Find a better autogrowing heuristic
> +	 */
> +	if (fda->nr == fda->nr_alloc &&
> +	    fdarray__grow(fda, 64) < 0)
> +		return -ENOMEM;
> +
> +	fcntl(fd, F_SETFL, O_NONBLOCK);
> +	fda->entries[fda->nr].fd = fd;
> +	fda->entries[fda->nr].events = POLLIN | POLLERR | POLLHUP;
> +	fda->nr++;
> +	return 0;
> +}

To be more generic api, I think it'd be better receiving events from
user rather than hard-coding.  Also it might be useful to let user
sets a grow hint (during init?) as well.

Thanks,
Namhyung

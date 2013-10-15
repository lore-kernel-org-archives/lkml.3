Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3JOGId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:08:33 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:35592 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3JOGIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:08:32 -0400
Date: Tue, 15 Oct 2013 08:08:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf tools: Compare dso's also when comparing symbols
Message-ID: <20131015060829.GA4529@gmail.com>
References: <1381802517-18812-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381802517-18812-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Linus reported that sometimes 'perf report -s symbol' exits without any 
> message on TUI.  David and Jiri found that it's because it failed to add 
> a hist entry due to an invalid symbol length.

Btw., 'exit without any messages' is something that should be fixed 
separately as well I suspect.

>  static int64_t
>  sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
>  {
> +	int64_t ret;
> +

Btw., this file should go back to u64/s64 like the kernel and most of perf 
does. (A few int64_t uses slipped into other places as well, I suspect 
they should be fixed.)

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3EIJdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:33:19 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57048 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3EIJc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:32:57 -0400
Date: Thu, 9 May 2013 11:32:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: detect when perf.data file not closed out properly
Message-ID: <20130509093253.GA21690@gmail.com>
References: <1368025728-4669-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368025728-4669-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> +		pr_err("data size is 0. "
> +		       "Was the record command properly terminated?\n");

Btw., a small stylistic request: please put user-visible strings into a 
single line - even if it technically turns into an overlong line.

		pr_err("data size is 0. Was the record command properly terminated?\n");

This 1) makes it easier for people to git grep the error text they are 
seeing during usage 2) makes it easier for _developers_ to see the 
messages they are outputing to users.

For example from the single-line output it's immediately visible that it 
should be capitalized thusly:

		pr_err("Data size is 0. Was the record command properly terminated?\n");

:-)

Thanks,

	Ingo

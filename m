Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbaFCGv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 02:51:26 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:64201 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbaFCGvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 02:51:25 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] tools lib traceevent: Add options to plugins
References: <20140603032012.088137043@goodmis.org>
	<20140603032223.896255043@goodmis.org>
Date: Tue, 03 Jun 2014 15:51:22 +0900
In-Reply-To: <20140603032223.896255043@goodmis.org> (Steven Rostedt's message
	of "Mon, 02 Jun 2014 23:20:14 -0400")
Message-ID: <87lhtecwph.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014 23:20:14 -0400, Steven Rostedt wrote:
> +void traceevent_plugin_free_options_list(char **list)
> +{
> +	int i;
> +
> +	if (!list)
> +		return;
> +
> +	if (list == (char **)((unsigned long)-1))

It also should be:

	if (list == INVALID_PLUGIN_LIST_OPTION)


Other than that, the series looks good to me now!

Thanks,
Namhyung


> +		return;
> +
> +	for (i = 0; list[i]; i++)
> +		free(list[i]);
> +
> +	free(list);
> +}

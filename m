Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3JKNrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:47:10 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39853 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3JKNrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:47:08 -0400
Message-ID: <52580157.1040300@hitachi.com>
Date: Fri, 11 Oct 2013 22:47:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/12] tracing: Add 'snapshot' event trigger command
References: <cover.1381445299.git.tom.zanussi@linux.intel.com> <4ed13a4c303b83164992b92dc17d79717bea2116.1381445299.git.tom.zanussi@linux.intel.com>
In-Reply-To: <4ed13a4c303b83164992b92dc17d79717bea2116.1381445299.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/11 9:48), Tom Zanussi wrote:
>  /**
> + * tracing_alloc_snapshot - allocate snapshot buffer.
> + *
> + * This only allocates the snapshot buffer if it isn't already
> + * allocated - it doesn't also take a snapshot.
> + *
> + * This is meant to be used in cases where the snapshot buffer needs
> + * to be set up for events that can't sleep but need to be able to
> + * trigger a snapshot.
> + */
> +int tracing_alloc_snapshot(void)
> +{
> +	struct trace_array *tr = &global_trace;
> +	int ret;
> +
> +	ret = alloc_snapshot(tr);
> +	WARN_ON(ret < 0);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tracing_alloc_snapshot);

Out of curiously, why this symbol is exported to modules?
The functions which are called directly from trace_event macros
should be exported because those macros can be used in module code,
but I couldn't find this in such code, at a glance.

Thank you,



-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



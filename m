Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbbANO5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:57:53 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56617 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbANO5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:57:52 -0500
Message-ID: <54B683ED.2060105@gmail.com>
Date: Wed, 14 Jan 2015 07:57:49 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH v2 1/4] perf tools: Fix segfault for symbol annotation
 on TUI
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/15 4:18 AM, Namhyung Kim wrote:

> @@ -129,8 +124,7 @@ static inline struct sym_hist *annotation__histogram(struct annotation *notes, i
>
>   static inline struct annotation *symbol__annotation(struct symbol *sym)
>   {
> -	struct sannotation *a = container_of(sym, struct sannotation, symbol);
> -	return &a->annotation;
> +	return (void *)sym - symbol_conf.priv_size;

symbol__priv(sym);

David

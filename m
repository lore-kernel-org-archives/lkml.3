Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaJXAkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:40:09 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:47516 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaJXAkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:40:07 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] perf tools: Add support for exclusive option
References: <1413990949-13953-1-git-send-email-namhyung@kernel.org>
	<1413990949-13953-5-git-send-email-namhyung@kernel.org>
	<54488C84.3040408@hitachi.com> <20141023202948.GK14687@kernel.org>
Date: Fri, 24 Oct 2014 09:40:05 +0900
In-Reply-To: <20141023202948.GK14687@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Thu, 23 Oct 2014 17:29:48 -0300")
Message-ID: <87bnp2e1wa.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Thu, 23 Oct 2014 17:29:48 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 23, 2014 at 02:05:08PM +0900, Masami Hiramatsu escreveu:
>> (2014/10/23 0:15), Namhyung Kim wrote:
>> > Some options cannot be used at the same time.  To handle such options
>> > add a new PARSE_OPT_EXCLUSIVE flag and show error message if more than
>> > one of them is used.
>> 
>> Looks useful for me :)
>> 
>> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> 
>> I just have a comment below;
>> 
>> > @@ -360,19 +378,21 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
>> >  		}
>> >  
>> >  		if (arg[1] != '-') {
>> > -			ctx->opt = arg + 1;
>> > +			ctx->opt = ++arg;
>> >  			if (internal_help && *ctx->opt == 'h')
>> >  				return usage_with_options_internal(usagestr, options, 0);
>> >  			switch (parse_short_opt(ctx, options)) {
>> >  			case -1:
>> > -				return parse_options_usage(usagestr, options, arg + 1, 1);
>> > +				return parse_options_usage(usagestr, options, arg, 1);
>> >  			case -2:
>> >  				goto unknown;
>> > +			case -3:
>> > +				goto exclusive;
>> 
>> BTW, it may be a time to define return error codes.
>
> Yeah, this thing looks unnecessarily complicated :-\

OK, will do it as a separate patch later.

Thanks,
Namhyung

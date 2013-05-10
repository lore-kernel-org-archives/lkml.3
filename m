Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3EJBnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:43:32 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43087 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab3EJBnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:43:31 -0400
X-AuditID: 9c930197-b7c1fae000001854-66-518c50c0f254
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/9] perf tools: Add a precise event qualifier
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com>
	<1368106344-23383-5-git-send-email-jolsa@redhat.com>
Date: Fri, 10 May 2013 10:43:28 +0900
In-Reply-To: <1368106344-23383-5-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Thu, 9 May 2013 15:32:19 +0200")
Message-ID: <877gj77gov.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 15:32:19 +0200, Jiri Olsa wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Add a precise qualifier, like cpu/event=0x3c,precise=1/
>
> This is needed so that the kernel can request enabling PEBS
> for TSX events. The parser bails out on any sysfs parse errors,
> so this is needed in any case to handle any event on the TSX
> perf kernel.
[SNIP]
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -568,6 +568,12 @@ do {								\
>  	case PARSE_EVENTS__TERM_TYPE_NAME:
>  		CHECK_TYPE_VAL(STR);
>  		break;
> +	case PARSE_EVENTS__TERM_TYPE_PRECISE:
> +		CHECK_TYPE_VAL(NUM);
> +		if ((unsigned)term->val.num > 2)

Shouldn't it be 3 as we technically allow the 'ppp' modifier?  Although
there's no cpu suppports precise=3 currently, things can be changed. :)

Thanks,
Namhyung


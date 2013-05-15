Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3EOJN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:13:58 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52571
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060Ab3EOJN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:13:56 -0400
Date: Wed, 15 May 2013 11:13:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/8] perf tools: Add formula interface to interface
 formula definitions
Message-ID: <20130515091331.GF10510@laptop.programming.kicks-ass.net>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
 <1367421346-18257-5-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367421346-18257-5-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 05:15:42PM +0200, Jiri Olsa wrote:
> Each counter (cpi/branch-rate above) defines formula that
> produces the counter number.
> 
> Formula grammar:
> 
>   expr: '-' expr       |
>         expr '+' expr  |
>         expr '-' expr  |
>         expr '*' expr  |
>         expr '/' expr  |
>         value          |
>         name
> 

I was going to suggest adding (), but then I saw

> +<expr>{
> +"*"		{ return '*'; }
> +"-"		{ return '-'; }
> +"+"		{ return '+'; }
> +"/"		{ return '/'; }
> +"("		{ return '('; }
> +")"		{ return ')'; }
> +

> +'(' expr ')'
> +{
> +	$$ = $2;
> +	pr_debug2("( %F )\n", $$);
> +}

:-)

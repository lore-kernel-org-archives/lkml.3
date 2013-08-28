Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3H1N1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:27:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab3H1N1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:27:13 -0400
Date: Wed, 28 Aug 2013 10:27:03 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, sukadev@linux.vnet.ibm.com,
        jolsa@redhat.com, ak@linux.intel.com
Subject: Re: [PATCH] perf mem: add priv level filtering support
Message-ID: <20130828132703.GD3825@infradead.org>
References: <20130826131121.GA26224@quad>
 <521BD4F8.5050504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521BD4F8.5050504@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 26, 2013 at 04:21:44PM -0600, David Ahern escreveu:
> On 8/26/13 7:11 AM, Stephane Eranian wrote:

> >This patch adds the -u -and -k options to perf to allow
> >filtering of load/store sampling based on priv levels.
> >This may not be supported by all HW platforms.


> >+++ b/tools/perf/Documentation/perf-mem.txt
> >+-k::
> >+	Only sample loads/stores at the user level (default: user + kernel)
> >+-u::
> >+	Only sample loads/stores at the kernel level (default: user + kernel)
 
> Are the descriptions backwards? In the commit message yuo have -u
> means user level and -k means kernel level; the help message here
> seems backwards.

Looks like it is reversed, yes.

> >+	OPT_BOOLEAN('u', "user-level", &mem.user, "include user-level accesses"),
> >+	OPT_BOOLEAN('k', "kernel-level", &mem.kernel, "include kernel-level accesses"),

And its not clear to say that using -u will _exclude_ kernel samples,
just that it includes user samples, perf top has:

    -K, --hide_kernel_symbols	hide kernel symbols
    -U, --hide_user_symbols	hide user symbols

So perhaps we should change both to (and add this to 'report' as well):

    -U, --hide_kernel_symbols	hide kernel symbols
    -K, --hide_user_symbols	hide user symbols

To state that:

	perf top -K
and
	perf top --hide_user_symbols

Are equivalent and asks for 'kernel only' samples, like it seems its the
intent (filtering) of Stephane here, and seems to clarify things?

- Arnaldo

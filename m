Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3FZWlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:41:47 -0400
Received: from dmz-mailsec-scanner-6.mit.edu ([18.7.68.35]:57034 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454Ab3FZWlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:41:44 -0400
X-AuditID: 12074423-b7f168e00000095a-d5-51cb6e2848dc
Date: Wed, 26 Jun 2013 18:41:34 -0400
From: Greg Price <price@MIT.EDU>
To: Namhyung Kim <namhyung.kim@lge.com>, Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
Message-ID: <20130626224134.GA22203@biohazard-cafe.mit.edu>
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
 <20130111052736.GG3054@ghostprotocols.net>
 <20130623031720.GW22203@biohazard-cafe.mit.edu>
 <20130623215327.GA995@krava.redhat.com>
 <20130624083253.GA28025@gmail.com>
 <20130624231426.GY22203@biohazard-cafe.mit.edu>
 <20130625074734.GD11420@gmail.com>
 <51C94E6B.6000802@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C94E6B.6000802@lge.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsUixCmqrauRdzrQYPd+DouLbRfZLA48PsBi
	sXXvGxaLo2f/Mllc3jWHzWL1v1OMFpcOLGCyeLAy26Jp2VYWizVHFrNbtH3+x+rA7XHlKYfH
	6R49j52z7rJ7bFrVyebR9fYKk8f7fVfZPObu6mP0+LxJLoAjissmJTUnsyy1SN8ugSvjyq69
	LAVHuCpe7vjB2MC4nKOLkZNDQsBE4krfExYIW0ziwr31bF2MXBxCAvsYJXZN2cwE4WxklGj9
	NJ0ZwvnMKHF6+jVWkBYWAVWJP4sms4HYbAIKEj/mr2MGsUUE3CVu7dnBCNLALPCZSaLzVCtY
	QlggQmL65v9gzbwC1hJta46zQky9yySxsHM7C0RCUOLkTIijmAW0JG78ewl0BweQLS2x/B/Y
	3ZwC6hLv5s1iB7FFBVQkru1vZ5vAKDgLSfcsJN2zELoXMDKvYpRNya3SzU3MzClOTdYtTk7M
	y0st0jXTy80s0UtNKd3ECIoodhflHYx/DiodYhTgYFTi4f3AeDpQiDWxrLgy9xCjJAeTkiiv
	bi5QiC8pP6UyI7E4I76oNCe1+BCjBAezkghvaA5QjjclsbIqtSgfJiXNwaIkzit2a2egkEB6
	YklqdmpqQWoRTFaGg0NJgtcFZKhgUWp6akVaZk4JQpqJgxNkOA/QcA+QGt7igsTc4sx0iPwp
	RkUpcV5pkIQASCKjNA+uF5bwXjGKA70izBsKUsUDTJZw3a+ABjMBDZ655BTI4JJEhJRUA2Pp
	kW8e7Yuyz9c8ONvQeVojYWPXUePTXXnPvFg8gk/ETNW+ud9kQ8kHTiGrxVK2t9e+2TT9YKKs
	cMHF4+YbXtSc/DJtz5uNi0NYDi94KsH97OvpbfckzTtjPIOtLp79dORrkO06PQ91Rf6Nf/aa
	ruJqP/T4bYlvhLWGuJ3ZtLMJancafa3PsD5XYinOSDTUYi4qTgQAGUMxvFMDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung, hi Ingo,

On Tue, Jun 25, 2013 at 05:01:47PM +0900, Namhyung Kim wrote:
> >>TBH I'm not really familiar with the GTK front-end, as I mainly use
> >>the TUI.  At a quick trial, it looks like --blackbox has the expected
> >>effect on the display there; though with or without --blackbox I can't
> >>seem to get the entries to expand to show me a call-graph profile, so
> >>it's hard to demonstrate it fully.  Not sure what I may have done
> >>wrong in building or running perf to make that not work (or is that
> >>expected?)
> 
> Currently perf GTK front-end does not support callchains at all.
> There's a floating patchset to enable it though.
> 
> https://lkml.org/lkml/2013/6/4/181

OK, good to know I didn't simply mess something up.  So probably best
to leave any specific --blackbox-related support aside until that
patchset lands.


> >>What changes do you have in mind to make these available in the GTK
> >>front-end?
> >
> >I was thinking of something obvious like right-clicking it to make that
> >function back boxed away or so? Have no firm ideas - maybe the GTK gents
> >on Cc: know how to best integrate such features.
> 
> We don't support context menu yet.  Frankly, perf GTK code is still
> premature and needs some love.  Any contribution should be welcomed!

Noted.

Cheers,
Greg

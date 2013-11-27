Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3K0Ah1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:37:27 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44865 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3K0AhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:37:23 -0500
X-AuditID: 9c93017d-b7b24ae000002834-85-52953ec1e17d
Message-ID: <52953EC1.8010706@lge.com>
Date: Wed, 27 Nov 2013 09:37:21 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH 0/2] tracing: Teach FETCH_MTD_symbol to handle per-cpu
 data
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com> <20131126174355.GB14028@redhat.com>
In-Reply-To: <20131126174355.GB14028@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

(Please use my korg email address, otherwise I might not see - at least 
in time - the messages.)

2013-11-27 AM 2:43, Oleg Nesterov wrote:
> On 11/26, Masami Hiramatsu wrote:
>> If the symbol is
>> percpu, it should be automatically translated to something like
>> FETCH_percpu, instead of such additional expression.
>
> OK. Probably yes, it should be automatically translated, please
> see the patches.
>
> This doesn't allow to read the data from other CPUs, but at least
> the changes are simple and this_cpu_ is better than the reading
> from the obviously wrong address.

Agreed.  I also like the automatic translation.

>
>> For the dynamic allocated per-cpu things, it is also good to give
>> a straight operation, like +10(percpu(%rdi)).
>
> Probably yes, but this needs more changes and I am still not sure
> this is really useful. And if we do this, we probably also need
> to allow to read from other CPUs...

Right.  This should be another story.

Do we also need something similar to user-space TLS?

>
>> Also, please do not be afraid to add fetch operation,
>
> Well, this is what I am trying to avoid ;)

Well, it looks like a trade-off between code-size (or performance) and 
readability (or modularity).  For this specific case, I don't have any 
preference though.

Thanks,
Namhyung

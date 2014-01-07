Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaAGIc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:32:26 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:38134 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaAGIcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:32:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140106163123.GN31570@twins.programming.kicks-ass.net>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
 <52B87149.4010801@arm.com> <CAKfTPtDmb1fa8PUcrqEGaoQLxoPBddu-Yn_oS8KwsCJJWJzQug@mail.gmail.com>
 <20140106163123.GN31570@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 7 Jan 2014 09:32:04 +0100
Message-ID: <CAKfTPtDind8HGJwu0odSnNdRpaxp3VB3JWw3eADAp4bL4Ex-Mw@mail.gmail.com>
Subject: Re: [RFC] sched: CPU topology try
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 January 2014 17:31, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jan 06, 2014 at 02:41:31PM +0100, Vincent Guittot wrote:
>> IMHO, these settings will disappear sooner or later, as an example the
>> idle/busy _idx are going to be removed by Alex's patch.
>
> Well I'm still entirely unconvinced by them..
>
> removing the cpu_load array makes sense, but I'm starting to doubt the
> removal of the _idx things.. I think we want to retain them in some
> form, it simply makes sense to look at longer term averages when looking
> at larger CPU groups.
>
> So maybe we can express the things in log_2(group-span) or so, but we
> need a working replacement for the cpu_load array. Ideally some
> expression involving the blocked load.

Using the blocked load can surely give benefit in the load balance
because it gives a view of potential load on a core but it still decay
with the same speed than runnable load average so it doesn't solve the
issue for longer term average. One way is to have a runnable average
load with longer time window

>
> Its another one of those things I need to ponder more :-)

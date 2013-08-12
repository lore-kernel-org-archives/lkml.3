Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3HLJIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 05:08:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37480 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab3HLJIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:08:11 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-4d-5208a5f9b98c
Date: Mon, 12 Aug 2013 11:07:41 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v6 2/8] cpufreq: Add boost frequency support in core
Message-id: <20130812110741.608e1e34@amdc308.digital.local>
In-reply-to: <CAKohpokK8eNid3yNGTEax_-3CZNaJ4T6Osz8RrXk11hn+Mmxxg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-3-git-send-email-l.majewski@samsung.com>
 <CAKohpom9QHf+XBYQcajv4tni4_KA2x+Y3BAXWhZkdCFnZxp3XA@mail.gmail.com>
 <20130726103321.21238bbb@amdc308.digital.local>
 <CAKohpokK8eNid3yNGTEax_-3CZNaJ4T6Osz8RrXk11hn+Mmxxg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t9jQd2fSzmCDPafV7XYOGM9q8XTph/s
	FvM+y1r0/bzCbLFm/08mi86zT5gtehdcZbN484jb4v2hZ8wWl3fNYbP43HuE0eJ24wo2i/6F
	vUwWTx72sVls/OrhwO+xeM9LJo871/awedz+95jZY920t8wefVtWMXo8WtzC6HH8xnYmj8+b
	5AI4orhsUlJzMstSi/TtErgyFrZ9YS04xVGx9PoxlgbGN2xdjJwcEgImEldenoKyxSQu3FsP
	ZHNxCAlMZ5T4fGICC4TTziRxYOlPdpAqFgFViUu998FsNgE9ic93nzJ1MXJwiAhoSby8mQpS
	zyxwj0WitWcNK0iNsICHxJFf35hAbF4Ba4n7P68wgticAsESTa++MIPYQgL/mSRWntEHsfkF
	JCXa//1ghrjITuLcpw3sEL2CEj8m32MBsZmBdm3e1sQKYctLbF7zlnkCo+AsJGWzkJTNQlK2
	gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwnD2T3sG4qsHiEKMAB6MSD6/HF/YgIdbE
	suLK3EOMEhzMSiK8avM4goR4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1I
	LYLJMnFwSjUwtnvkrgsIdVoVyfPQrd/78YSKy7cOq+tYz87deUXj/tqlxlLzI+3fPnia8enI
	o99KTJ68htu007xN1oSEtK3sOrid+TdXeQxrsL73pqkd6Zab79SfNdyovuXJa+U1cslSgbbn
	s2ruTsl837l9Wt+V0+HO56tvFsZd4S3vjpuj8Ko0TyO2QHK9EktxRqKhFnNRcSIAQBU3oK8C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 15:06:45 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 26 July 2013 14:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > The problem here is with the cpufreq_driver->set_boost() call.
> >
> > I tried to avoid acquiring lock at one function and release it at
> > another (in this case cpufreq_boost_set_sw), especially since the
> > __cpufreq_governor() acquires its own lock - good place for
> > deadlock.
> >
> > Is it OK for you to grab lock at one function
> > (cpufreq_boost_trigger_state()) and then at other function
> > (cpufreq_boost_set_sw) release it before calling
> > __cpufreq_governor() and grab it again after its completion?
> 
> Problem is not only that.. but we shouldn't call boost_set() of
> drivers like acpi-cpufreq with this lock..... Leave it as it is for
> now.. Let me see if I can think of any problems that can happen due
> to this.

Do you have any second thoughts about this? Shall I leave it as it is
now?

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3GQPAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:00:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48721 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3GQPAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:00:16 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-c7-51e6b17eec07
Date: Wed, 17 Jul 2013 16:59:43 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Lukasz Majewski <l.majewski@majess.pl>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Message-id: <20130717165943.7f06acd9@amdc308.digital.local>
In-reply-to: <CAKohpo=1Qov8p3f2xZkfOqaFRNJPJN60KeK4SOXcL9Hw82MkAg@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <6633375.dICiDrHJgK@vostro.rjw.lan>
 <CAKohpokw-bSWEgKvx0jd2QZ0RCz5dORHM9z+VYbTdKoCmKFvsg@mail.gmail.com>
 <2509113.ybUsa2l9tg@vostro.rjw.lan>
 <CAKohpo=1Qov8p3f2xZkfOqaFRNJPJN60KeK4SOXcL9Hw82MkAg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jQd26jc8CDd5c4bT483Y5q8XTph/s
	FvM+y1q03F3LarFm/08mi86zT5gtehdcZbN484jb4vKuOWwWn3uPMFrcblzBZtG/sJfJ4snD
	PjaLjiPfmC02fvVw4PfYOesuu8fiPS+ZPO5c28PmsW7aW2aPvi2rGD0eLW5h9Dh+YzuTx+dN
	cgEcUVw2Kak5mWWpRfp2CVwZ8+ZpFVzgrNjQ59rAeJK9i5GTQ0LAROJm73w2CFtM4sK99UA2
	F4eQwHRGiTWrOhghnHYmidtXHoJ1sAioStx/eYkJxGYT0JP4fPcpkM3BISKgJfHyZipIPbPA
	IxaJ658XMoLUCAt4SGzf1c8KYvMKWEvs+XEbLM4pECzRuacZzBYSmM8kMXeZJ4jNLyAp0f7v
	BzPERXYS5z5tYIfoFZT4MfkeC4jNDLRr87YmVghbXmLzmrfMExgFZyEpm4WkbBaSsgWMzKsY
	RVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgmPsmdQOxpUNFocYBTgYlXh4J4Q9DRRiTSwrrsw9
	xCjBwawkwntwybNAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJM
	HJxSDYyN7zo3n/1+4UhQ6CGDReWSE/i3OAdr6cULuAe/Cg7wyPrd2TfV/MyPiMlPZ7TaF82t
	D/R6azHFbPUXd6lb8ptcDvFlOAUlRZQExF5+Fnp6+6NkuWnJqTrRqtXLBNNvNyZeUTc0VJjX
	PedXXMfZ34sUxXfeZeHVX5MTEzLtXKCvpfGCL+GSVUosxRmJhlrMRcWJADPzYTutAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 18:31:19 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 17 July 2013 17:01, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > First off, I'm not sure how many applications actually use it and I
> > think, if any, they should be able cope with the attribute not
> > being present.
> >
> > Of course, if it turns out that yes, there are applications using
> > it and no, they cannot cope with the missing attribute, we'll need
> > to address this. That said such applications wouldn't work with
> > earlier kernels in which that attribute wasn't present at all, so I
> > suppose this is really unlikely.
> >
> > So, do whichever makes more sense to you: Design things to preserve
> > the old behavior (which is sightly confusing) or design them to
> > expose the attribute if the feature is actually supported and be
> > prepared to address the (unlikely) case when some hypothetical
> > applications break because of that.
> 
> Okay. Its better to keep it the way Lukasz designed it in his last
> patchset.

To be 100% sure - we export boost only when supported (as proposed at v5).


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group

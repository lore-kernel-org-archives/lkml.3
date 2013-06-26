Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3FZLEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:04:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21064 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3FZLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:04:19 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-70-51cacab150aa
Date: Wed, 26 Jun 2013 13:04:07 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, t.figa@samsung.com
Subject: Re: [PATCH v4 1/7] cpufreq: Store cpufreq policies in a list
Message-id: <20130626130407.021c05cb@amdc308.digital.local>
In-reply-to: <CAKohpom1yJOAVZ1XE+Q+dtrZM1N6Zqd7DjURSA_f2fhQ1OiCJA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-2-git-send-email-l.majewski@samsung.com>
 <CAKohpomStuSGyQHnk9jNLpije=SAkb4zHg40zHDgLRCUQeZC1A@mail.gmail.com>
 <20130626125411.5dc935bf@amdc308.digital.local>
 <CAKohpom1yJOAVZ1XE+Q+dtrZM1N6Zqd7DjURSA_f2fhQ1OiCJA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jAd1Np04FGtz5w2zx5+1yVounTT/Y
	LeZ9lrVYs/8nk0Xn2SfMFr0LrrJZvHnEbXF51xw2i8+9RxgtbjeuYLPoX9jLZPHkYR+bxfoZ
	r1ksOo58Y7bY+NXDgd9j8Z6XTB53ru1h81g37S2zR9+WVYwejxa3MHocv7GdyePzJrkA9igu
	m5TUnMyy1CJ9uwSujOa7XYwFy1grDp/PbGD8zdzFyMkhIWAisbV1LiOELSZx4d56NhBbSGAR
	o8S2xxldjFxAdjuTxOMzH8GKWARUJT6d+wnWzCagJ/H57lOmLkYODhEBLYmXN1NB6pkFTrNI
	7HhwjR0kLizgKnH9vCKIyStgLbFrawVIJ6dAsMT83ydZIcb/ZZLoWncVbCS/gKRE+78fULfZ
	SZz7tIEdxOYVEJT4MfkeC4jNDLRq87YmVghbXmLzmrfMExgFZyEpm4WkbBaSsgWMzKsYRVML
	kguKk9JzjfSKE3OLS/PS9ZLzczcxguPqmfQOxlUNFocYBTgYlXh4FbaeDBRiTSwrrsw9xCjB
	wawkwvtm/qlAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tSs1NTC1KLYLJMHJxS
	DYxWxrNM638sEr8WcT5hpu9Ur4ZJ6h+n3EqZ5V73RGXn+p/ZXXcfXkq+/N2YJ1Tg2bqnLLLv
	5vKJhGgFV36o/el8a8+2e6+WpxqEu+x2NdA/UZ2UGXDI6quPyzenRQ1yb2X67+z9Lta07Xc3
	75ZTMeLyszNWG515bd/zaZeN8Bbb9ukL1i/6veayEktxRqKhFnNRcSIAHWDx9acCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 16:26:30 +0530, Viresh Kumar wrote:
> On 26 June 2013 16:24, Lukasz Majewski <l.majewski@samsung.com> wrote:
> >> > ---
> >
> > So here <---> I will put change log for v5.
> 
> correct.

OK.

> 
> >> >         ret = cpufreq_add_dev_interface(cpu, policy, dev);
> >> >         if (ret)
> >
> > I will add list_del(&cpufreq_policy_list);
> > here.
> 
> May not be sufficient. You must do it once at the end of this routine.

Then I will add this code below:

err_out_kobj_put:
	list_del(&cpufreq_policy_list);
	[rest of error path]

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group

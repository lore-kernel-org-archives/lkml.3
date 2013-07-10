Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3GJFjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 01:39:55 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45837 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3GJFjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 01:39:54 -0400
MIME-Version: 1.0
In-Reply-To: <51DCDF1C.1000208@linux.vnet.ibm.com>
References: <1443144.WnBWEpaopK@amdc1032>
	<51DB724F.9050708@linux.vnet.ibm.com>
	<1754044.EVIH1UZj6p@amdc1032>
	<51DC0B0D.9070201@linux.vnet.ibm.com>
	<51DCDF1C.1000208@linux.vnet.ibm.com>
Date: Wed, 10 Jul 2013 11:09:53 +0530
Message-ID: <CAKohpokbo+X5bEYweBuSqr5bkdRsb-XHT7SrMWybwAvkfDsGBQ@mail.gmail.com>
Subject: Re: [v3.10 regression] deadlock on cpu hotplug
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2013 09:42, Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
> I'm not sure what is supposed after notify CPUFREQ_GOV_STOP event, if it
> is in order to stop queued work and prevent follow work happen again,
> then it failed to, and we need some method to stop queue work again when
> CPUFREQ_GOV_STOP notified, like some flag in policy which will be
> checked before re-queue work in work.
>
> But if the event is just to sync the queued work but not prevent follow
> work happen, then things will become tough...we need confirm.

After GOV_STOP, until the time GOV_START is called, we shouldn't be
queuing any work.

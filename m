Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3LPKk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:40:58 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:61389 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3LPKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:40:56 -0500
MIME-Version: 1.0
In-Reply-To: <52A448F2.4010208@redhat.com>
References: <52A448F2.4010208@redhat.com>
Date: Mon, 16 Dec 2013 16:10:55 +0530
Message-ID: <CAKohpomO+0q7bFWTnFRgqoRuU2WryfPpFv0WLOCKtHBrLzLRqw@mail.gmail.com>
Subject: Re: Regression with suspend resume 5a87182aa21d6d5d306840feab9321818dd3e2a3
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lan Tianyu <tianyu.lan@intel.com>,
        jinchoi@broadcom.com, Paul Bolle <pebolle@tiscali.nl>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        ziegler@email.mathematik.uni-freiburg.de,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        jbarnes@virtuousgeek.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2013 15:54, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> I'm testing recent 3.13-rc kernel - and I've notice my Lenovo T61 is not
> able to resume.  After bisect I've found commit:
>
> 5a87182aa21d6d5d306840feab9321818dd3e2a3

That's my patch, sorry for all the trouble.. Just came back after vacations
and multiple threads are there with this patch as culprit..

I just tested this patch again on Rafael's linux-next branch and suspend/resume
and Hibernation are working fine for me on my Thinkpad T420. I don't see any
issues at all..

scaling_governor: ondemand
scaling_driver: acpi-cpufreq

> When I just revert this commit with 374b105797c3d4f29c685f3be535c35f5689b30e
> (3.13-rc3)   suspend/resume works again.
> (I'm using  ondemand CPU governor)

> Here is bisect log:

> # bad: [2167e2399dc5e69c62db56d933e9c8cbe107620a] cpufreq: fix garbage
> kobjects on errors during suspend/resume
> git bisect bad 2167e2399dc5e69c62db56d933e9c8cbe107620a

I don't read bisect logs well but doesn't you log say that the culprit is
2167e2399dc5e69c62db56d933e9c8cbe107620a instead?

I am trying with this patch now, but will take some time for results to be out.

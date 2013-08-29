Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab3H2VXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:23:14 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:45995 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3H2VXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:23:11 -0400
MIME-Version: 1.0
In-Reply-To: <7272744.lhUaaLc3cm@vostro.rjw.lan>
References: <1377740508-22134-1-git-send-email-ccross@android.com>
	<7272744.lhUaaLc3cm@vostro.rjw.lan>
Date: Thu, 29 Aug 2013 14:23:10 -0700
X-Google-Sender-Auth: lJdO1hm60dYGcn2H1oF7y7JOT5w
Message-ID: <CAMbhsRTnMKMVXBav+FwJxw3+Ochk-wfs8WU3oWAExzYMfm4RRw@mail.gmail.com>
Subject: Re: [PATCH v2] cpuidle: coupled: abort idle if pokes are pending
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Neil Zhang <zhangwm@marvell.com>,
        Joseph Lo <josephl@nvidia.com>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jon Medhurst <tixy@linaro.org>, Sivaram Nair <sivaramn@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 1:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, August 28, 2013 06:41:47 PM Colin Cross wrote:
>> Joseph Lo <josephl@nvidia.com> reported a lockup on Tegra20 caused
>> by a race condition in coupled cpuidle.  When two or more cpus
>> enter idle at the same time, the first cpus to arrive may go to the
>> ready loop without processing pending pokes from the last cpu to
>> arrive.
>>
>> This patch adds a check for pending pokes once all cpus have been
>> synchronized in the ready loop and resets the coupled state and
>> retries if any cpus failed to handle their pending poke.
>>
>> Retrying on all cpus may trigger the same issue again, so this patch
>> also adds a check to ensure that each cpu has received at least one
>> poke between when it enters the waiting loop and when it moves on to
>> the ready loop.
>>
>> Reported-by: Joseph Lo <josephl@nvidia.com>
>> Tested-by: Stephen Warren <swarren@nvidia.com>
>> Tested-by: Joseph Lo <josephl@nvidia.com>
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> Still stable material I suppose?

Yes please

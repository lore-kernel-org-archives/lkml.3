Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaIDKha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:37:30 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34473 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaIDKh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:37:28 -0400
MIME-Version: 1.0
In-Reply-To: <540838DB.1070202@linux.vnet.ibm.com>
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
	<CAKohpomLW17B=Sk42tczzDF+VGwn7hT521osWPi5TcgqpCPZ_w@mail.gmail.com>
	<53296AD0.5090908@linux.vnet.ibm.com>
	<19131121.D211TBerqb@vostro.rjw.lan>
	<CAKohpom0+bbyffZML2tJjXQDc+2q4PM8sVkL5pDA5WX=rmvtKA@mail.gmail.com>
	<54082C68.8030400@linux.vnet.ibm.com>
	<CAKohpokvpWDbCbPYcV+fzzpaztZSi=yacdmyYfBLoSs4U2YO9A@mail.gmail.com>
	<540838DB.1070202@linux.vnet.ibm.com>
Date: Thu, 4 Sep 2014 16:07:28 +0530
Message-ID: <CAKohpomH=ODnDT1FxrGVLOiOpA9NecQR134tUKQk-bRXLGPRYw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 September 2014 15:33, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> I think Rafael's point was that since no driver that had implemented the
> target_index callback was using it at the time that this patch was
> proposed, it was be best to couple the check on existence of stop_cpu
> callback with the the check on the kind of cpufreq driver. However
> powerpc is also in need of this today and we implement the target_index
> callback and find it convenient to use the stop CPU callback.

No, this is what he said..

"
So to me, (1) the new ->stop() should *only* be called for ->setpolicy drivers,
because the purpose of it should be to "allow ->setpolicy drivers to do what the
GOV_STOP will do for regular drivers"
"

> Rafael, in which case would it not make sense to remove the check on
> driver->setpolicy above?
>
> Besides, I don't understand very well why we had this double check in
> the first place. Only if the drivers are in need of the functionality
> like stop_cpu, would they have implemented this callback right? If we
> are to assume that the drivers which have implemented the target_index
> callback should never be needing it, they would not have implemented the
> stop CPU callback either. So what was that, which was blatantly wrong
> with just having a check on stop_cpu? I did go through the discussion
> but did not find a convincing answer to this.

The idea was to get something similar to GOV_STOP for setpolicy drivers.
But in the end we didn't get to that. What we do in GOV_STOP is stop
changing CPUs frequency, but here in stop_cpu() we can stop changing
CPUs frequency OR take it to minimum, whatever we want..

As I said earlier, probably we should just do what you did in your patch +
some documentation changes.

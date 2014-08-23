Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaHWUIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 16:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaHWUIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 16:08:07 -0400
Date: Sat, 23 Aug 2014 22:07:59 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] perf: Allow leader sampling on inherited events
Message-ID: <20140823200759.GA1972@krava.redhat.com>
References: <1408712718-19656-1-git-send-email-jolsa@kernel.org>
 <20140822133056.GA22315@krava.brq.redhat.com>
 <CABooUW0qEpo2YhXfxHsf48mw1acuZ63bq=Fot3kH1eHOfryU-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABooUW0qEpo2YhXfxHsf48mw1acuZ63bq=Fot3kH1eHOfryU-A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 02:55:32PM -0400, Jen-Cheng(Tommy) Huang wrote:
> Hi Jiri,
> 
> 1. Thank you so much for providing the patch.
> I am trying to test out the patch.
> (I got the source using "git checkout -b perf
> remotes/origin/perf/core_format_group"
> after clone)
> However, the perf in your repo seems having issues with sample_read :S.
> (:S works fine with my original perf that comes with the kernel.)
> When I do
> perf record -e '{instructions,cycles}:S' /bin/ls
> 
> The following error is shown
> Error:
> The sys_perf_event_open() syscall returned with 22 (Invalid argument) for
> event (instructions).
> /bin/dmesg may provide additional information.
> No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> This error does not occur without :S.
> perf record -e '{instructions,cycles}' /bin/ls
> This shows no errors.

have u boot the new kernel? there're 2 kernel patches
within the patchset

but right, the perf code should detect the kernel change
and keep old behaviour if it's not detected..

> 
> 2. Another issue I have is to show the sample value using 'perf script'.
> Currently, I am using perf report -D to show the sample read values, the
> format is not what I need. Could you give me some hints on where to modify
> to show the sample values using perf script?

there's no support in perf script to display the sample
read values.. I'll check if that could be added

thanks,
jirka

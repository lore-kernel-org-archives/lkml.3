Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3KET7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:59:02 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55101 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab3KET7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:59:00 -0500
MIME-Version: 1.0
In-Reply-To: <1362388174-3435-10-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1362388174-3435-10-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 5 Nov 2013 11:58:58 -0800
X-Google-Sender-Auth: 4PCTwRxWov8uL-8KkGazOxsa0ic
Message-ID: <CAA9_cmdYr_KMf7UyanX9QAndPoFa4fVW6=QwDJbH6pZExYUcpw@mail.gmail.com>
Subject: Re: [PATCH 09/10] dmatest: gather test results in the linked list
From: Dan Williams <dan.j.williams@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, dmaengine@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 1:09 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The patch provides a storage for the test results in the linked list. The
> gathered data could be used after test is done.
>
> The new file 'results' represents gathered data of the in progress test. The
> messages collected are printed to the kernel log as well.
>
> Example of output:
>         % cat /sys/kernel/debug/dmatest/results
>         dma0chan0-copy0: #1: No errors with src_off=0x7bf dst_off=0x8ad len=0x3fea (0)
>
> The message format is unified across the different types of errors. A number in
> the parens represents additional information, e.g. error code, error counter,
> or status.
>
> Note that the buffer comparison is done in the old way, i.e. data is not
> collected and just printed out.
>

I need to revert this to get my testing done as it just leaks memory
for no real benefit that I can see.  Outside of making the log
messages have a uniform format I'm not seeing the case for this?  I'll
revert and add a pr_fmt to make dmatest messages readily parseable.

--
Dan

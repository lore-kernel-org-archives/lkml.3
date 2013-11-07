Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3KGOiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:38:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:22397 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab3KGOiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:38:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="431346952"
Message-ID: <1383835070.30870.9.camel@smile>
Subject: Re: [PATCH 09/10] dmatest: gather test results in the linked list
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, dmaengine@vger.kernel.org
Date: Thu, 07 Nov 2013 16:37:50 +0200
In-Reply-To: <CAA9_cmfy6AEtEnEY60_YAL3jLLme98-oGjh12tHPJOH3AFqpEA@mail.gmail.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1362388174-3435-10-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAA9_cmdYr_KMf7UyanX9QAndPoFa4fVW6=QwDJbH6pZExYUcpw@mail.gmail.com>
	 <1383747221.30870.7.camel@smile>
	 <CAA9_cmfy6AEtEnEY60_YAL3jLLme98-oGjh12tHPJOH3AFqpEA@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-06 at 10:11 -0800, Dan Williams wrote:
> [ excuse the resend, always forget that mobile-gmail sends html by default ]
> 
> On Wed, Nov 6, 2013 at 6:13 AM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Tue, 2013-11-05 at 11:58 -0800, Dan Williams wrote:
> >> On Mon, Mar 4, 2013 at 1:09 AM, Andy Shevchenko
> >> <andriy.shevchenko@linux.intel.com> wrote:
> >> > The patch provides a storage for the test results in the linked list. The
> >> > gathered data could be used after test is done.
> >> >
> >> > The new file 'results' represents gathered data of the in progress test. The
> >> > messages collected are printed to the kernel log as well.
> >> >
> >> > Example of output:
> >> >         % cat /sys/kernel/debug/dmatest/results
> >> >         dma0chan0-copy0: #1: No errors with src_off=0x7bf dst_off=0x8ad len=0x3fea (0)
> >> >
> >> > The message format is unified across the different types of errors. A number in
> >> > the parens represents additional information, e.g. error code, error counter,
> >> > or status.
> >> >
> >> > Note that the buffer comparison is done in the old way, i.e. data is not
> >> > collected and just printed out.
> >> >
> >>
> >> I need to revert this to get my testing done as it just leaks memory
> >> for no real benefit that I can see.  Outside of making the log
> >> messages have a uniform format I'm not seeing the case for this?  I'll
> >> revert and add a pr_fmt to make dmatest messages readily parseable.
> >
> >
> > The benefit of it is to access to the results asynchronously as many
> > times as tester wants to.
> >
> 
> tail -f /var/log/messages is also asynchronous.

It's harder to collect them by the script.

> 
> > Actually I wonder where you found memory leak. It keeps the result only
> > for the last test run.
> 
> In my test I hit the oom killer allocating the "OK" results.

Any description and steps you can share to reproduce your test?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

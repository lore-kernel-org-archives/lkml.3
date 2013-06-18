Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab3FRUoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:44:30 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:52084 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab3FRUo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:44:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75Vf-bE1cYmj543U=Wk-=iEgTfpnezXSjPjHUiYdM8G-C+A@mail.gmail.com>
References: <20130613172408.GA5561@intel.com>
	<CAA9_cmf5y_z_XeX7N2Jno9uvUkrFK83RN1XrxTwVqZJnbdfEWA@mail.gmail.com>
	<CAA9_cmdr7gjrbBN8tV9LAH2JXzFiegLzLPOAHVg-9sP8p9HRqg@mail.gmail.com>
	<20130618173406.GB5054@intel.com>
	<CAA9_cmewUn1Gz_BJvmhuC46u_4b2xZ9SL-uEtefcaOg0ECBJhg@mail.gmail.com>
	<CAHp75Vf-bE1cYmj543U=Wk-=iEgTfpnezXSjPjHUiYdM8G-C+A@mail.gmail.com>
Date: Tue, 18 Jun 2013 13:44:27 -0700
X-Google-Sender-Auth: 0O1_ftFfgEFySxSmSNIa4BBm5WQ
Message-ID: <CAA9_cmcKehEhdeeRv7XrcNHBTxAcyf5cw6d=szMV8q0_BwHSFw@mail.gmail.com>
Subject: Re: [PATCH] dmatest: masking tests for channel capabilities
From: Dan Williams <djbw@fb.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jubin Mehta <jubin.mehta@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jon.mason@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 1:01 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Tue, Jun 18, 2013 at 10:16 PM, Dan Williams <djbw@fb.com> wrote:
>> On Tue, Jun 18, 2013 at 10:34 AM, Jubin Mehta <jubin.mehta@intel.com> wrote:
>
>>> Would you like to have some changes regarding the configuration
>>> process for the module parameters of the dmatest?
>>
>> Yes, as a first step I would like to see a clean up of the the
>> configuration parameters to be available via
>> /sys/module/dmatest/parameters rather than /sys/kernel/debug/dmatest
>
> Do  you mean to enable write access to them?

Yes.

>
>> As for "run" and "results" I see Andy's point that those are a bit
>> awkward as parameters.  However, we do have trace points as a more
>> general mechanism for dumping events and data to userspace.  If we had
>> /sys/module/dmatest/parameters/run with a tracepoint for the result
>> line does that get us everything we need for automation?  I can see
>> more tracepoints beng added to get some perf metrics out of the tests.
>
> I'm not familiar neither with perf, nor with tracepoints. Could you
> elaborate and show here the scheme how it should work? How we will get
> results? In what form?
>

It would be very similar to what it does now except using generic
functionality.  At a high level you would have a tracepoint that emits
something like:

dma0chan0-copy0: #1: No errors with src_off=0x7bf dst_off=0x8ad len=0x3fea (0)

...and that message shows up in the ftrace buffer when it fires.

These articles are a good starting point.
https://lwn.net/Articles/379903/
https://lwn.net/Articles/383362/

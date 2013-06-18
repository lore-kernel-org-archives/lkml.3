Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab3FRTQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:16:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53637 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3FRTQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:16:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130618173406.GB5054@intel.com>
References: <20130613172408.GA5561@intel.com>
	<CAA9_cmf5y_z_XeX7N2Jno9uvUkrFK83RN1XrxTwVqZJnbdfEWA@mail.gmail.com>
	<CAA9_cmdr7gjrbBN8tV9LAH2JXzFiegLzLPOAHVg-9sP8p9HRqg@mail.gmail.com>
	<20130618173406.GB5054@intel.com>
Date: Tue, 18 Jun 2013 12:16:07 -0700
X-Google-Sender-Auth: kWntvKUMJjNDI8fpgRhUnOOBIBU
Message-ID: <CAA9_cmewUn1Gz_BJvmhuC46u_4b2xZ9SL-uEtefcaOg0ECBJhg@mail.gmail.com>
Subject: Re: [PATCH] dmatest: masking tests for channel capabilities
From: Dan Williams <djbw@fb.com>
To: Jubin Mehta <jubin.mehta@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jon.mason@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:34 AM, Jubin Mehta <jubin.mehta@intel.com> wrote:
> On Mon, Jun 17, 2013 at 02:12:51PM -0700, Dan Williams wrote:
>> [ apologies for the resend, gmail defaulted to html ]
>>
>> On Mon, Jun 17, 2013 at 2:10 PM, Dan Williams <djbw@fb.com> wrote:
>> >> +Example to perform only MEMCPY and PQ mode tests (0x01 | 0x04 = 0x05):
>> >> +
>> >> +        % modprobe dmatest
>> >> +        % echo dma0chan0 > /sys/kernel/debug/dmatest/channel
>> >> +        % echo 5  > /sys/kernel/debug/dmatest/cap_mask
>> >> +        % echo 1 > /sys/kernel/debug/dmatest/iterations
>> >> +        % echo 1 > /sys/kernel/debug/dmatest/run
>> >
>> >
>> > Hmmm, I should have paid more attention when the debugfs support was
>> > initially proposed for dmatest.  As it is I see duplication and
>> > configuration parameters getting out of sync with their module parameter
>> > equivalents versus just having all configuration go through module
>> > parameters.  module_param_call() can be used for the more complex options.
>> > Debugfs at this point looks like overkill for what amounts to some simple
>> > configuration variables and a result line.
>> >
>> > --
>> > Dan
>>
> Would you like to have some changes regarding the configuration
> process for the module parameters of the dmatest?

Yes, as a first step I would like to see a clean up of the the
configuration parameters to be available via
/sys/module/dmatest/parameters rather than /sys/kernel/debug/dmatest

As for "run" and "results" I see Andy's point that those are a bit
awkward as parameters.  However, we do have trace points as a more
general mechanism for dumping events and data to userspace.  If we had
/sys/module/dmatest/parameters/run with a tracepoint for the result
line does that get us everything we need for automation?  I can see
more tracepoints beng added to get some perf metrics out of the tests.
 Thoughts?

> Any other comments with respect to the patch?

How about a comma separated list of named capabilities (copy, xor, pq,
xor_val, sg... etc) rather than a mask?  If we are already not using
the dma_transaction_type values might as well use something human
readable.

--
Dan

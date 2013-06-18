Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3FRF5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:57:07 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36135 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3FRF5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:57:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAA9_cmdr7gjrbBN8tV9LAH2JXzFiegLzLPOAHVg-9sP8p9HRqg@mail.gmail.com>
References: <20130613172408.GA5561@intel.com>
	<CAA9_cmf5y_z_XeX7N2Jno9uvUkrFK83RN1XrxTwVqZJnbdfEWA@mail.gmail.com>
	<CAA9_cmdr7gjrbBN8tV9LAH2JXzFiegLzLPOAHVg-9sP8p9HRqg@mail.gmail.com>
Date: Tue, 18 Jun 2013 08:57:04 +0300
Message-ID: <CAHp75VdxO_hpSHSu+KsHWo8s7MFb=QqdYXuihSNSLLUXU1ykyg@mail.gmail.com>
Subject: Re: [PATCH] dmatest: masking tests for channel capabilities
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Dan Williams <djbw@fb.com>
Cc: Jubin Mehta <jubin.mehta@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jon.mason@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 12:12 AM, Dan Williams <djbw@fb.com> wrote:
> On Mon, Jun 17, 2013 at 2:10 PM, Dan Williams <djbw@fb.com> wrote:
>>> +Example to perform only MEMCPY and PQ mode tests (0x01 | 0x04 = 0x05):
>>> +
>>> +        % modprobe dmatest
>>> +        % echo dma0chan0 > /sys/kernel/debug/dmatest/channel
>>> +        % echo 5  > /sys/kernel/debug/dmatest/cap_mask
>>> +        % echo 1 > /sys/kernel/debug/dmatest/iterations
>>> +        % echo 1 > /sys/kernel/debug/dmatest/run
>>
>>
>> Hmmm, I should have paid more attention when the debugfs support was
>> initially proposed for dmatest.  As it is I see duplication and
>> configuration parameters getting out of sync with their module parameter
>> equivalents versus just having all configuration go through module
>> parameters.  module_param_call() can be used for the more complex options.
>> Debugfs at this point looks like overkill for what amounts to some simple
>> configuration variables and a result line.

There two main issues we fight against:
 - test automation, where we can collect results and use them later
 - annoying modprobe / modprobe -r for each test case

The module parameters were left to support old behaviour of the module.

--
With Best Regards,
Andy Shevchenko

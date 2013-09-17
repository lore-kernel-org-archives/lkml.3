Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3IQUVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:21:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56341 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3IQUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:21:14 -0400
Message-ID: <5238B9A7.6040002@kernel.dk>
Date: Tue, 17 Sep 2013 14:20:55 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Jeff Moyer <jmoyer@redhat.com>,
        OS Engineering <osengineering@stec-inc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Akhil Bhansali <abhansali@stec-inc.com>,
        Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: Re: [PATCH] block: Device driver for sTec's PCIe Kronos Card.
References: <26D762E250385C4D8E9D6EC3C8E47DC11E6FCF20@sambx4.stec-inc.ad> <x49vc2nnwp5.fsf@segfault.boston.devel.redhat.com> <26D762E250385C4D8E9D6EC3C8E47DC11E6FE729@sambx4.stec-inc.ad> <x4938pjbhqk.fsf@segfault.boston.devel.redhat.com> <5228913A.50807@kernel.dk> <CAOesGMhF42=qQLyMyF4-tsTjCxwX0bb10rTQv9sLooyzrEOpHA@mail.gmail.com>
In-Reply-To: <CAOesGMhF42=qQLyMyF4-tsTjCxwX0bb10rTQv9sLooyzrEOpHA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 01:04 PM, Olof Johansson wrote:
> On Thu, Sep 5, 2013 at 7:12 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 09/05/2013 06:00 AM, Jeff Moyer wrote:
>>> OS Engineering <osengineering@stec-inc.com> writes:
>>>
>>>> Hi Jeff,
>>>>
>>>> Thank you for reviewing the patch.
>>>
>>> No problem.  Jens, any objection to queueing this up for 3.12?
>>
>> I'll give it a look-over, but usually I'm pretty lax when it comes to
>> new drivers. So no, I'd be surprised if we can't queue this up for 3.12.
> 
> I came across this driver because it was spewing a lot of really
> trivial and easy to fix compiler warnings. Silly stuff such as
> printing u32 with %lu.
> 
> From a quick look at the code, several things are immediately apparent:
> 
> First, checkpatch says, on the currently existing file in -next:
> 
> total: 3 errors, 61 warnings, 5817 lines checked
> 
> Code like this looks _really_ confused:
> 
>                 barrier();
>                 val = readl(skdev->mem_map[1] + offset);
>                 barrier();
> 
> There are also some crazy long functions that should be refactored,
> such as skd_request_fn().
> 
> So, it looks like this driver needs a bunch of work before it's ready
> to go in. Or, maybe it's better to submit it with a TODO list for the
> staging tree instead?

Not disagreeing with you, it definitely needs a bit of cleaning. And so
far stec has not been very responsive in fixing those issues.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab3C0QFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:05:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:20698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab3C0QFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,920,1355126400"; 
   d="scan'208";a="285328904"
Message-ID: <515318D1.5030005@linux.intel.com>
Date: Wed, 27 Mar 2013 09:05:37 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Seth Heasley <seth.heasley@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio-sch: Allow for more than 8 lines in the resume well
References: <dabdda74b7aabe3edece1c5edb9aed1c24093695.1362606482.git.dvhart@linux.intel.com> <CACRpkdYfDRtcQ4z4PdinpNKmTHHS5+T2asSPgRGHvGK1qRL_XQ@mail.gmail.com>
In-Reply-To: <CACRpkdYfDRtcQ4z4PdinpNKmTHHS5+T2asSPgRGHvGK1qRL_XQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/27/2013 01:20 AM, Linus Walleij wrote:
> On Wed, Mar 6, 2013 at 10:49 PM, Darren Hart <dvhart@linux.intel.com> wrote:
>
>> The E6xx (TunnelCreek) CPUs have 9 GPIO lines in the resume well. Update
>> the resume functions to allow for more than 8 GPIO lines, using the core
>> functions as a template.
>>
>> Cc: <stable@vger.kernel.org> # 3.4.x
>> Cc: <stable@vger.kernel.org> # 3.8.x
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
>
> I have applied this for next (v3.10)
>
> I cannot for my life figure out what kind of *regression* you are
> fixing so that it should go into fixes for the -rc:s or the two stable
> branches indicated above.

I apologize. This is not a regression, it has always been broken for the
TunnelCreek (which was added later). With only 8 bits for the resume well,
trying to read the 9th GPIO line always fails. I suspect it was just never
tested or needed until a board came along using it. As adding support
for new
systems is acceptable for stable, I felt this landed in that bucket, as
well as
the "obvious bug fix" bucket.


> I need a more verbose commit message with descriptions of
> user-percieved problems on deployed systems that for that.


Would you like me to resubmit with a more verbose commit message? Happy
to do so.


> BTW: are you interested in adding yourself as mainatiner of
> this driver in the MAINTAINERS file Darren?

That might make sense. I'm doing a lot of TunnelCreek driver fixes for
the MinnowBoard. If that would be helpful, I'm willing.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

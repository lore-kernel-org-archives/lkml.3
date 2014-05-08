Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaEHTov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:44:51 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37770 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbaEHTou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:44:50 -0400
Message-ID: <536BDEAF.5030602@gmail.com>
Date: Thu, 08 May 2014 12:44:47 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robherring2@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/4] of/selftest: add testcase for nodes with same name
 and address
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com> <1399499298-8830-2-git-send-email-robherring2@gmail.com> <536AF13F.6000502@gmail.com> <CACxGe6seW1MYC5iqZriXzrR1_hcR_DfLs5exUCLEZY3CRb28pw@mail.gmail.com>
In-Reply-To: <CACxGe6seW1MYC5iqZriXzrR1_hcR_DfLs5exUCLEZY3CRb28pw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/2014 1:59 AM, Grant Likely wrote:
> On Thu, May 8, 2014 at 3:51 AM, Frank Rowand <frowand.list@gmail.com> wrote:
>> On 5/7/2014 2:48 PM, Rob Herring wrote:
>>> From: Rob Herring <robh@kernel.org>
>>>
>>> Add a test case for nodes which have the same name and same
>>> non-translatable unit address.
>>
>> If I apply patch 1 and 2 without applying 3 and 4 then console
>> warnings are printed, but from a different area of code than
>> the original problem reported.  This probably is not a big deal,
>> but I'm trying to figure out if I can modify the test to also
>> show the original problem.
>>
>> The test case also properly reports the failure.
>>
>> Once all 4 patches are applied, then the test case passes.
> 
> When adding testcases I do prefer the addition of the test to appear
> before the fix while the patch is under review. Makes it easy to see
> that, yes the bug exists, and yes the later patch resolves it.
> 
> When the patches are actually committed for merging then it is
> probably a good idea to reverse them. Thanks for the testing.

In this case, the test case has to be patch #2, if you want to be
able to verify that the test case catches the bug, because patch
#1 added code to allow the error return value to propagate all
the way out to the API called by the test code.  So the patch
ordering is correct.

> 
> g.
> 
>>
>> Thus:
>>
>>    Tested-by: Frank Rowand <frank.rowand@sonymobile.com>
>>
>>>
>>> Signed-off-by: Rob Herring <robh@kernel.org>
>>> ---
>>>  drivers/of/selftest.c                        | 23 ++++++++++++++++++
>>>  drivers/of/testcase-data/testcases.dtsi      |  1 +
>>>  drivers/of/testcase-data/tests-platform.dtsi | 35 ++++++++++++++++++++++++++++
>>>  3 files changed, 59 insertions(+)
>>>  create mode 100644 drivers/of/testcase-data/tests-platform.dtsi
>>>
>>
>> < snip >
>>
> .
> 


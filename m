Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaCBPec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:34:32 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:49496 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaCBPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:34:31 -0500
Message-ID: <53134F84.1040906@linux.com>
Date: Sun, 02 Mar 2014 16:34:28 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yogesh Chaudhari <mr.yogesh@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: to give more detailed warning
 message in case printk is used in any patch
References: <CAAOfnZp-KAFo8Q4bBW7oxe8BgUn+bSDAWuHbK6E+SF0X0Ex=Wg@mail.gmail.com> <53134C4D.2090406@linux.com> <CAAOfnZqjVn5_aTU3fQQmOF8MqOb5NqXS5Yg4gb-Sec+Qm_0dEQ@mail.gmail.com>
In-Reply-To: <CAAOfnZqjVn5_aTU3fQQmOF8MqOb5NqXS5Yg4gb-Sec+Qm_0dEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[+CC LKML, Joe]
[Leaving full copy for LKML, Joe]

On 03/02/2014 04:29 PM, Yogesh Chaudhari wrote:
> On 2 March 2014 20:50, Levente Kurusa <levex@linux.com> wrote:
>> Hi,
>>
>> On 03/02/2014 04:01 PM, Yogesh Chaudhari wrote:
>>> Based on the discussion here:
>>> https://lkml.org/lkml/2014/3/2/17
>>>
>>> I would like to propose this patch to improve the warning message in
>>> checkpatch.pl.  Comments/Suggestions on possible improvements are
>>> welcome.
>>>
>>>
>>> =========================================================
>>>
>>> This patch modifies scripts/checkpatch.pl to give more detailed
>>> warning message in case printk is used in any patch.
>>>
>>> Signed-off-by: Yogesh Chaudhari <mr.yogesh@gmail.com>
>>> ---
>>>  scripts/checkpatch.pl | 5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>>> index 464dcef..526f33aa 100755
>>> --- a/scripts/checkpatch.pl
>>> +++ b/scripts/checkpatch.pl
>>> @@ -2799,7 +2799,10 @@ sub process {
>>>              my $level2 = $level;
>>>              $level2 = "dbg" if ($level eq "debug");
>>>              WARN("PREFER_PR_LEVEL",
>>> -                 "Prefer netdev_$level2(netdev, ... then
>>> dev_$level2(dev, ... then pr_$level(...  to printk(KERN_$orig ...\n" .
>>> $herecurr);
>>
>> Whoops, that's a word-wrap!
>> Try using git-format-patch+git-send-email to send the patch.
> Ack, my bad, I will make this change.
> 
>>
>>> +                 "Order of preference for printing debug messages:
>>> +                 1. [subsystem]_$level2([subsystem]dev, ... eg
>>> netdev_$level2(netdev, ... for netdevice object
>>> +                 2. dev_$level2(dev, ... for drivers with struct device
>>> +                 3. pr_$level(...  to printk(KERN_$orig ...\n" . $herecurr);
>>>          }
>>>
>>>          if ($line =~ /\bpr_warning\s*\(/) {
>>>
>>
>> IMHO, this message is too big. The one we already have is nice and clean.
>> I would simply do: s/netdev/[subsystem]/ or something among the lines.
> 
> Seems proper way to go about. I agree that this makes it a bit too
> long, however, I was wondering, if there is a detailed
> documentation/information file about checkpatch (or patching in
> general where a detailed message would be accurate). Particularly,
> where we can make a note of proper way of using such debug calls.

Yes there is. Documentation/CodingStyle#Chapter13 is where you should
do stuff like that.

-- 
Regards,
Levente Kurusa

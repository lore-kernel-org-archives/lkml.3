Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaIAGiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:38:14 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58287 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaIAGiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:38:12 -0400
X-AuditID: 85900ec0-d312bb9000001514-af-54041450182a
Message-ID: <5404144F.2070509@hitachi.com>
Date: Mon, 01 Sep 2014 15:38:07 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 10/10] scsi/trace: Use scsi_print_command trace point
 instead of printk
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115030.6768.91195.stgit@yuno-kbuild.novalocal> <53FDE859.1020800@suse.de> <53FE8890.80403@hitachi.com> <53FEC9E7.6000909@hitachi.com> <53FF1D44.3080702@suse.de>
In-Reply-To: <53FF1D44.3080702@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

Sorry for the late reply.

(2014/08/28 21:15), Hannes Reinecke wrote:
> On 08/28/2014 08:19 AM, Yoshihiro YUNOMAE wrote:
>> Hi Hannes,
>>
>> I tried to remove duplicated decoder of SCSI command, but the
>> output format of it in constants.c is different from it in traceevents.
>> I have two questions for it.
>>
>> (Ex1)
>> traceevents: TEST_UNIT_READY
>> constants: Test Unit Ready
>>
>> => Which of "XXX_YYY_ZZZ" and "Xxx Yyy Zzz" should the kernel output
>> strings? This difference comes from difference of implementation.
>> The decoder in traceevents are using macro. So, it cannot define
>> separated words. On the other hand, the decoder in constants are using
>> constant string array table. So, it can define separated words.
>>
> I would go with the wording in constants.c, but set in double quotes
> like "Test Unit Ready" to avoid parsing errors later on.

OK, we use constants' format and add double quotes for each sense code.

>> (Ex2)
>> traceevents: (nothing)
>> constants: Set limits(12)
>>
>> => Should we merge those decoder?
>>
> Yes, I would prefer this. Again, we should be setting the strings in
> double quotes irrespective if there are spaces in the resulting string
> or not.

Sure.

>> I understand we use the decoder of constants, but we need to solve
>> these problems. Would you give me your comments?
>>
> As mentioned previously, my aim is to convert the logging system in
> several steps:
>
> a) convert all lone 'printk' statements into dev_printk() variants
>     and ensure everything is printed in one statement to avoid
>     linebreaks in the resulting logging message.
>     This will eliminate the immediate problem we're having, namely
>     that debugging is near to impossible under high load.
>     The patchset is nearing completion, and I will be posting it
>     later this week.
> b) Convert scsi_trace to use the functions from constants.c to
>     avoid code duplication and update scsi_trace to log sense codes.
> c) Remove all logging functions in the hot path (ie
>     SCSI_LOG_MLQUEUE and SCSI_LOG_MLCOMPLETE) and replace them
>     with trace events.
>
> b) is what you're working on, right?

Right.

> For 'c)' the problem is that we should retain the existing functionality
> with scsi_logging_level here, at least initially.
> So we cannot just replace it, as this would leave SCSI_LOG_ML
> a dummy without any real functionality.

I tried to change printk messages to new tracevents, but I'll stop it
until we solve the problem.
I'll submit the patch set removing duplicated decoder first.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



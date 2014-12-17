Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000AbaLQBF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:05:29 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:52503 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaLQBF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:05:28 -0500
MIME-Version: 1.0
Date: Tue, 16 Dec 2014 17:05:27 -0800
Message-ID: <CAADnVQLerROn=H=w0T29wt-wO=SbHaggrso_B7aGCajrAJ3TvA@mail.gmail.com>
Subject: Re: [LKP] [ipmi] BUG: key ffff880fcfc51ed0 not in .data!
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Corey Minyard <cminyard@mvista.com>
Cc: Huang Ying <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 5:08 AM, Corey Minyard <cminyard@mvista.com> wrote:
> On 12/15/2014 08:53 PM, Alexei Starovoitov wrote:
>> On Fri, Dec 12, 2014 at 8:04 PM, Corey Minyard <cminyard@mvista.com> wrote:
>>> On 12/11/2014 09:20 PM, Huang Ying wrote:
>>>> FYI, we noticed the below changes on
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
>>>> commit 2ed09fc090fc0488e2ab27604a141679fe2ef610 ("ipmi: clean up the device handling for the bmc device")
>>> Thanks.  The surprising thing is that this didn't give an error before.
>>>
>>> But this should be fixed in linux-next the next time.
>> when specifically? Is there a fix already?
>> Quite annoying to see this every boot:
>> [    4.778018] BUG: key ffff88046458fe20 not in .data!
>> [    4.778021] ------------[ cut here ]------------
>> [    4.778061] WARNING: CPU: 1 PID: 1428 at
>> ../kernel/locking/lockdep.c:2991 lockdep_init_map+0x4cd/0x500()
> Yes, should be fixed by:
>
> commit 693726299ba87a6e267993806bc1320a266e5c5e
> Author: Corey Minyard <cminyard@mvista.com>
> Date:   Fri Dec 12 19:06:07 2014 -0600
>
>     ipmi: Finish cleanup of BMC attributes
>
> which should be in linux-next now.  I was able to reproduce and verify
> that this fixed it.  I've verified that the branch is correct in the
> repository.

thanks. cleared the warning for me as well:
Tested-by: Alexei Starovoitov <ast@plumgrid.com>

Are you planning to send a pull request
before the merge window is over or for rc2 ?

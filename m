Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3DFQpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:45:06 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38884 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3DFQpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:45:04 -0400
MIME-Version: 1.0
In-Reply-To: <51601B25.5050801@gmx.de>
References: <515DB2A6.7020902@gmx.de>
	<CAFLxGvyDxdL9BJHFH5O6OSqZ3ZyBatBvmZGJWP3B=D=0xcgVng@mail.gmail.com>
	<51601958.3090806@gmx.de>
	<51601B25.5050801@gmx.de>
Date: Sat, 6 Apr 2013 18:45:02 +0200
Message-ID: <CAFLxGvzQ=_jGr+oaRfOPKdEV3YogDYwHN3UwUXtcFArnV2bkCg@mail.gmail.com>
Subject: Re: user mode linux: trinity syscall "madvise" triggers quickly BUG:
 Bad page map
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 6, 2013 at 2:55 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> On 04/06/2013 02:47 PM, Toralf Förster wrote:
>> On 04/06/2013 01:43 PM, richard -rw- weinberger wrote:
>>>> What I get with the this trinity command line
>>>>
>>>> gt; trinity --children 2 -c madvise
>>>
>>> Does the attached patch fix the problem?
>>
>> yes, the issue for this syscall is fixed now.
>>
>
> But now I get - after running this command for a longer time :
>
>
> 2013-04-06T14:49:55.755+02:00 trinity kernel: do_syscall_stub : ret = -12, offset = 1052680, data = 3f2ff008
> 2013-04-06T14:49:55.755+02:00 trinity kernel: do_syscall_stub: syscall 192 failed, return value = 0xfffffff4, expected return value = 0x280e5000
> 2013-04-06T14:49:55.755+02:00 trinity kernel: syscall parameters: 0x280e5000 0x1000 0x7 0x11 0x3 0x11cba
> 2013-04-06T14:49:55.755+02:00 trinity kernel: Failed to flush page for address 0x280e5000
> 2013-04-06T14:49:57.600+02:00 trinity kernel: do_syscall_stub : ret = -12, offset = 1052680, data = 3f397008
> 2013-04-06T14:49:57.600+02:00 trinity kernel: do_syscall_stub: syscall 192 failed, return value = 0xfffffff4, expected return value = 0x280e5000
> 2013-04-06T14:49:57.600+02:00 trinity kernel: syscall parameters: 0x280e5000 0x1000 0x7 0x11 0x3 0x1ad80
> 2013-04-06T14:49:57.600+02:00 trinity kernel: Failed to flush page for address 0x280e5000
> 2013-04-06T14:50:01.000+02:00 trinity cron[1071]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons)
> 2013-04-06T14:51:15.336+02:00 trinity kernel: do_syscall_stub : ret = -12, offset = 1052680, data = 3f2fe008
> 2013-04-06T14:51:15.336+02:00 trinity kernel: do_syscall_stub: syscall 192 failed, return value = 0xfffffff4, expected return value = 0x280e3000
> 2013-04-06T14:51:15.336+02:00 trinity kernel: syscall parameters: 0x280e3000 0x1000 0x7 0x11 0x3 0xd561
> 2013-04-06T14:51:15.336+02:00 trinity kernel: Failed to flush page for address 0x280e3000
> 2013-04-06T14:51:20.224+02:00 trinity kernel: do_syscall_stub : ret = -12, offset = 1052680, data = 3f394008
> 2013-04-06T14:51:20.224+02:00 trinity kernel: do_syscall_stub: syscall 192 failed, return value = 0xfffffff4, expected return value = 0x280e5000
> 2013-04-06T14:51:20.224+02:00 trinity kernel: syscall parameters: 0x280e5000 0x1000 0x7 0x11 0x3 0x29571
> 2013-04-06T14:51:20.224+02:00 trinity kernel: Failed to flush page for address 0x280e5000
> 2013-04-06T14:52:34.379+02:00 trinity kernel: do_syscall_stub : ret = -12, offset = 1052680, data = 3f22a008
> 2013-04-06T14:52:34.379+02:00 trinity kernel: do_syscall_stub: syscall 192 failed, return value = 0xfffffff4, expected return value = 0x280e3000
> 2013-04-06T14:52:34.379+02:00 trinity kernel: syscall parameters: 0x280e3000 0x1000 0x7 0x11 0x3 0x9b50
> 2013-04-06T14:52:34.379+02:00 trinity kernel: Failed to flush page for address 0x280e3000
> 2013-04-06T14:52:40.422+02:00 trinity kernel: do_syscall_stub : ret = -12, offset = 1052680, data = 3f397008
> 2013-04-06T14:52:40.422+02:00 trinity kernel: do_syscall_stub: syscall 192 failed, return value = 0xfffffff4, expected return value = 0x280e3000
> 2013-04-06T14:52:40.422+02:00 trinity kernel: syscall parameters: 0x280e3000 0x1000 0x7 0x11 0x3 0xde37
> 2013-04-06T14:52:40.422+02:00 trinity kernel: Failed to flush page for address 0x280e3000
>
> and the appropriate linux - process at the host process runs at 100%

You are running out of available memory mappings on the host side.
mmap() fails because you have too much mappings installed.
See vm.max_map_count

--
Thanks,
//richard

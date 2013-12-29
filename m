Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3L2Uqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 15:46:31 -0500
Received: from ext190.halfdog.net ([88.116.147.190]:52572 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab3L2Uqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 15:46:30 -0500
Message-ID: <52C089AC.4000401@halfdog.net>
Date: Sun, 29 Dec 2013 20:44:28 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24a1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sanitize CPU-state when switching from virtual-8086 mode to other
 task
References: <52BF4A80.3010503@halfdog.net> <52BF8AEE.6020904@zytor.com>
In-Reply-To: <52BF8AEE.6020904@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> On 12/28/2013 02:02 PM, halfdog wrote:
>> It seems that missing CPU-state sanitation during task switching
>>  triggers kernel-panic. This might be related to unhandled 
>> FPU-errors. See [1] for POC and serial console log of OOPs. Due
>> to missing real 32-bit x86-hardware it is not clear, if this
>> issue might be related to subtle differences in virtual-8086
>> mode handling when inside a virtualbox guest.
>> 
> 
> This oops happens inside the guest?  Either way, I would be *very* 
> skeptical of Virtualbox in this case.
> 
> You can run a 32-bit kernel on 64-bit hardware, you know...

I know, but hardware was occupied with long-running simulation.

With the initial POC, there might be a timing issue involved, with
different process layout, exception does not occur in swith_to but
sometimes on other locations.

I created a new random-code testcase [1] , which works around that
problem. When booted a Debian initrd and tried id, OOPSes are fired
like wild but at least system does not lock up immediately.

hd

[1]
http://www.halfdog.net/Security/2013/Vm86SyscallTaskSwitchKernelPanic/Virtual86RandomCode.c

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLAiZEACgkQxFmThv7tq+5dsgCeIqOicLB17PuV7C6AzfZIY9J9
I0UAnA7YftR+4Jz2d5jP6YbpmBBtNOAz
=9MJY
-----END PGP SIGNATURE-----

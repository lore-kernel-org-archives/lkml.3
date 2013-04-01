Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab3DAJ2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:28:44 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35923 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab3DAJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:28:42 -0400
Message-ID: <5159534A.1070500@googlemail.com>
Date: Mon, 01 Apr 2013 10:28:42 +0100
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130312 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, mmarek@suse.cz
Subject: Re: linux-3.9.0-rc1+: Output from "make kernelrelease"contains incorrect
 data
References: <513B8FA7.9040200@googlemail.com>
In-Reply-To: <513B8FA7.9040200@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping!

This is still happening with 3.9-rc5.

[chris:~/kernel/linux]$ make bzImage
...
Kernel: arch/x86/boot/bzImage is ready  (#14)
[chris:~/kernel/linux]$ make kernelrelease
scripts/kconfig/conf --silentoldconfig Kconfig
3.9.0-rc5
[chris:~/kernel/linux]$ make kernelrelease
3.9.0-rc5

I'm assuming that the output from 'make kernelrelease' should be the 
string that represents the kernel release and only that string.

Chris


On 03/09/13 19:38, Chris Clayton wrote:
> In Linus' current tree, the first time the command "make kernelrelease"
> is run after building a kernel, the output contains some unwanted text.
> Subsequent uses of the command produce the expected output. This appears
> to be a regression - 3.8.2 does not have this problem.
>
> This is easily demonstrated from the command line by the following:
>
> <build the kernel>
> ...
> System is 2311 kB
> CRC a4e38b86
> Kernel: arch/x86/boot/bzImage is ready  (#186)
> $ make kernelrelease
> scripts/kconfig/conf --silentoldconfig Kconfig 3.9.0-rc1+
> $ make kernelrelease
> 3.9.0-rc1+
>
> Happy to test the fix.
>
> Chris
>
>
>

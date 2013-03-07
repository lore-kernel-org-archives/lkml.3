Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab3CGPzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:55:13 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:60082 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3CGPzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:55:11 -0500
Message-ID: <5138B85C.5010501@free-electrons.com>
Date: Thu, 07 Mar 2013 16:55:08 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: 3.9-rc1: hz.bc compilation breakage
References: <5137546B.2090801@free-electrons.com> <51380C65.50202@zytor.com> <51386F0D.8060105@free-electrons.com> <5138ACE2.9030105@zytor.com>
In-Reply-To: <5138ACE2.9030105@zytor.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 07/03/2013 16:06, H. Peter Anvin a écrit :
> On 03/07/2013 02:42 AM, Maxime Ripard wrote:
>>
>> I triggered this issue when switching to 3.9-rc1, and oldconfig runs at
>> that time, and now, running menuconfig doesn't generates it either.
>>
>>> I am not sure what you mean with "clean out-of-tree", however.
>>
>> make O=$(pwd) -C /path/to/linux/source some_configs
>> make
>>
> 
> Can you give the exact set of commands you are running when you see
> this?  I cannot reproduce this no matter what I do, and it doesn't seem
> like it is being a common problem.
> 
> In the example above the first "make" command does indeed not create any
> files in include/config, but they get created immediately on the second
> "make"...

Hmmm, It looks indeed that it can happen only on already existing
directories, I can't reproduce neither with a new build, and not
everyone seems to be impacted by that bug neither, since some colleagues
did the same thing without any trouble (with a completely different
architecture though).

So it's not that bad.

However, when I do:

In my source dir
git checkout v3.9-rc1

In my build dir
ARCH=arm make clean
ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- make zImage

And then it breaks.

So I suspect it's something not cleaned properly, or not generated
properly. Here is what's left after the make clean

http://code.bulix.org/eh1e6c-83108?raw

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

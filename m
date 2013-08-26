Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3HZE4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 00:56:20 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62329 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3HZE4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 00:56:19 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <521ADFEF.2010307@roeck-us.net>
Date: Sun, 25 Aug 2013 21:56:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Steve Cotton <steve@s.cotton.clara.co.uk>
Subject: Re: Commit 9a11899 (USB: OHCI: add missing PCI PM callbacks to ohci-pci.c)
 breaks several builds
References: <521ACBEF.60006@roeck-us.net> <521AD347.1090601@roeck-us.net> <20130826042653.GA2778@kroah.com>
In-Reply-To: <20130826042653.GA2778@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2013 09:26 PM, Greg Kroah-Hartman wrote:
> On Sun, Aug 25, 2013 at 09:02:15PM -0700, Guenter Roeck wrote:
>> On 08/25/2013 08:30 PM, Guenter Roeck wrote:
>>> Broken builds:
>>>       mips:ath79_defconfig
>>>       parisc:defconfig
>>>       sparc32:defconfig
>>>       sparc64:defconfig
>>>       tile:defconfig
>>>
>> Add:
>> 	powerpc:ppc64e_defconfig
>> 	powerpc:cell_defconfig
>> 	powerps:maple_defconfig
>>
>> That makes it 8 out of 82 builds, or roughly 10% of all builds.
>>
>> My qemu test build for powerpc (which has its own config file)  fails as well :(.
>
> Ugh, I got no reports of this from linux-next or the 0-day build system,
> odd.
>

Maybe the build system isn't as comprehensive as mine, or it just takes a bit longer.
My system caught it because you updated linux-stable to 3.11-rc7, which triggers all builds.

The functions are only declared if CONFIG_PM is defined, yet are called unconditionally.
This means the patch breaks in all configurations where CONFIG_PM is undefined and
CONFIG_USB_OHCI_HCD_PCI is defined.

Add this to the agenda at the kernel summit: We need more automated test coverage.
It is a bit scary that my little pc-based server farm catches problems like this
faster than everything else out there. And it isn't even the kind of problem
I am looking for, but rather a side effect of the builds I am running.

Guenter


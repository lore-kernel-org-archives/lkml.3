Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3HPJVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:21:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50542 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3HPJVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:21:12 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520DEF05.9030803@roeck-us.net>
Date: Fri, 16 Aug 2013 02:21:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux kernel cross-compilers
References: <520C9A39.3030808@roeck-us.net> <CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com> <20130816054823.GB28445@thor.bakeyournoodle.com> <CAMo8Bf+veq_DU7-hnB0yySy6YWpwU2TYx3U9e89c_m8Mv9Cv5w@mail.gmail.com> <520DD9CA.90305@roeck-us.net> <CAMo8BfLvVk+2CyQD28otU265J4rvbt0Eg11Vqr4u4zjKjrTanw@mail.gmail.com>
In-Reply-To: <CAMo8BfLvVk+2CyQD28otU265J4rvbt0Eg11Vqr4u4zjKjrTanw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 01:31 AM, Max Filippov wrote:
> On Fri, Aug 16, 2013 at 11:50 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On 08/16/2013 12:22 AM, Max Filippov wrote:
>>>
>>> On Fri, Aug 16, 2013 at 9:48 AM, Tony Breeds <tony@bakeyournoodle.com>
>>> wrote:
>>>>
>>>> On Thu, Aug 15, 2013 at 01:46:16PM +0400, Max Filippov wrote:
>>>>
>>>>> Yes, xtensa compiler/linker is known to have issues with link-time
>>>>> relaxation; e.g. it may fail to build linux image without
>>>>> CONFIG_LD_NO_RELAX.
>>>>
>>>>
>>>> Is there something I can do at linker build time to help with this?
>>>
>>>
>>> I don't think so. Apparently it's not a linker configuration issue, it's a
>>> bug.
>>>
>> CONFIG_LD_NO_RELAX doesn't help.
>>
>> For reference, here is the error:
>>
>> xtensa-linux-objcopy: Unable to change endianness of input file(s)
>> make[2]: *** [arch/xtensa/boot/boot-elf/Image.o] Error 1
>> make[1]: *** [boot-elf] Error 2
>> make: *** [zImage] Error 2
>>
>> Oddly enough, I only see the problem on one of three servers.
>
> Guenter,
> can you share a complete build log with V=1?
>

http://roeck-us.net/linux/logs/make.xtensa.log.bad
http://roeck-us.net/linux/logs/make.xtensa.log.ok

Key difference: the failing command in the bad case is
	xtensa-linux-objcopy -O elf32-xtensa-le
and in the good case
	xtensa-linux-objcopy -O elf32-xtensa-be

Same compiler (4.6.3 from kernel.org), same configuration file, same command line.
Configuration file is generated from defconfig, and the resulting .config file
is the same in both cases.

If I execute make and expicitly set BIG_ENDIAN=1 on the failing system as parameter to it,
it works fine. If I set BIG_ENDIAN=0 on the passing system, it fails.

I am puzzled. Guess there must be something different, but I have no idea what it might be.

If I execute the command which sets BIG_ENDIAN manually from the shell (from
arch/xtensa/boot/Makefile), it returns 1 on both systems.

If you have an idea what is going on please let me know.

Thanks,
Guenter


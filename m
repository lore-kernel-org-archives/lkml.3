Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3HPJpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 05:45:01 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:48202 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3HPJpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 05:45:00 -0400
MIME-Version: 1.0
In-Reply-To: <520DEF05.9030803@roeck-us.net>
References: <520C9A39.3030808@roeck-us.net>
	<CAMo8BfKyqZYMkh96wyZSpYUpXwqFQZkco=XgtjUrNG-jSzW5pA@mail.gmail.com>
	<20130816054823.GB28445@thor.bakeyournoodle.com>
	<CAMo8Bf+veq_DU7-hnB0yySy6YWpwU2TYx3U9e89c_m8Mv9Cv5w@mail.gmail.com>
	<520DD9CA.90305@roeck-us.net>
	<CAMo8BfLvVk+2CyQD28otU265J4rvbt0Eg11Vqr4u4zjKjrTanw@mail.gmail.com>
	<520DEF05.9030803@roeck-us.net>
Date: Fri, 16 Aug 2013 13:45:00 +0400
Message-ID: <CAMo8BfKWFGxr6a48tFqGCourOcWOTO9rmCHy3Q05jR_QEuq=Cg@mail.gmail.com>
Subject: Re: Linux kernel cross-compilers
From: Max Filippov <jcmvbkbc@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Guenter,
>> can you share a complete build log with V=1?
>>
>
> http://roeck-us.net/linux/logs/make.xtensa.log.bad
> http://roeck-us.net/linux/logs/make.xtensa.log.ok
>
> Key difference: the failing command in the bad case is
>         xtensa-linux-objcopy -O elf32-xtensa-le
> and in the good case
>         xtensa-linux-objcopy -O elf32-xtensa-be
>
> Same compiler (4.6.3 from kernel.org), same configuration file, same command
> line.
> Configuration file is generated from defconfig, and the resulting .config
> file
> is the same in both cases.
>
> If I execute make and expicitly set BIG_ENDIAN=1 on the failing system as
> parameter to it,
> it works fine. If I set BIG_ENDIAN=0 on the passing system, it fails.
>
> I am puzzled. Guess there must be something different, but I have no idea
> what it might be.

What is the output of

echo -e __XTENSA_EB__ | xtensa-linux-gcc -E -

on the failing system?

-- 
Thanks.
-- Max

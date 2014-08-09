Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaHIER0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 00:17:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60625 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaHIERY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 00:17:24 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E5A0D1.10507@roeck-us.net>
Date: Fri, 08 Aug 2014 21:17:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
References: <20140808213457.511493898@linuxfoundation.org> <53E57279.1030106@roeck-us.net> <20140809034911.GA2348@kroah.com> <20140809034950.GB2348@kroah.com>
In-Reply-To: <20140809034950.GB2348@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 08:49 PM, Greg Kroah-Hartman wrote:
> On Fri, Aug 08, 2014 at 08:49:11PM -0700, Greg Kroah-Hartman wrote:
>> On Fri, Aug 08, 2014 at 05:59:37PM -0700, Guenter Roeck wrote:
>>> On 08/08/2014 02:35 PM, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 3.16.1 release.
>>>> There are 17 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Sun Aug 10 21:34:49 UTC 2014.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> Build results:
>>> 	total: 136 pass: 136 fail: 0
>>
>> That's more than 3.15, nice!
>
> Oops, no, one less.  What got dropped from 3.16 that was working in 3.14
> and 3.15?
>

3.16 adds arm:axm55x_defconfig, and drops ppc:chroma_defconfig.
ppc is built twice, once with binutils 2.23 and once with binutils 2.24,
so it counts double. So net it is one less build. I may make up for that
and select a different configuration as replacement, but that will have
to wait until 3.17-rc1 is out.

Just for reference, in mainline, we currently have
	total: 133 pass: 127 fail: 6
plus four (!) qemu tests failing (arm, mips, mips64, and ppc),
meaning there will be three more dropped configurations (all arm
as far as I can see), and there is already a bunch of failures.
This is with v3.16-9794-g8065be8. next-20140808 build result is
	total: 133 pass: 121 fail: 12
with the same failed qemu tests, so it will only get worse :-(.

Some improved quality assurance may be helpful going forward,
especially since many of the failures seem to be due to lack of
(build) testing and could easily have been avoided. Something
to discuss in Chicago, maybe.

Guenter


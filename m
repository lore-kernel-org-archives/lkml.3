Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaJECv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 22:51:58 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58675 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJECvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 22:51:55 -0400
Message-ID: <5430B3A5.5000302@gmail.com>
Date: Sun, 05 Oct 2014 10:57:41 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, Greg KH <gregkh@linuxfoundation.org>
CC: rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com,
        ulf.hansson@linaro.org, khilman@linaro.org, geert+renesas@glider.be,
        tomasz.figa@gmail.com, richard@nod.at, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: power: domain: Use 'pm_cpu_data' instead
 of 'cpu_data' for compiling break
References: <54300206.3020206@gmail.com> <20141004160037.GB16969@kroah.com> <5430B021.1080709@infradead.org>
In-Reply-To: <5430B021.1080709@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/14 10:42, Randy Dunlap wrote:
> On 10/04/14 09:00, Greg KH wrote:
>> On Sat, Oct 04, 2014 at 10:19:50PM +0800, Chen Gang wrote:
>>> 'cpu_data' is too common to be already used by some architectures (e.g.
>>> um, m32r, and mn10300), so need use 'pm_cpu_data' instead of, or cause
>>> compiling break. The related error (with allmodconfig under um):
>>>
>>>     CC      drivers/base/platform.o
>>>   In file included from ./arch/x86/um/asm/processor.h:31:0,
>>>                    from ./arch/um/include/asm/uaccess.h:16,
>>>                    from ./arch/um/include/asm/thread_info.h:13,
>>>                    from include/linux/thread_info.h:54,
>>>                    from include/asm-generic/current.h:4,
>>>                    from arch/um/include/generated/asm/current.h:1,
>>>                    from include/linux/mutex.h:13,
>>>                    from include/linux/kernfs.h:13,
>>>                    from include/linux/sysfs.h:15,
>>>                    from include/linux/kobject.h:21,
>>>                    from include/linux/device.h:17,
>>>                    from include/linux/platform_device.h:14,
>>>                    from drivers/base/platform.c:14:
>>>   ./arch/um/include/asm/processor-generic.h:107:19: error: expected identifier or '(' before '&' token
>>>    #define cpu_data (&boot_cpu_data)
>>>                      ^
>>>   include/linux/pm_domain.h:74:23: note: in expansion of macro 'cpu_data'
>>>     struct gpd_cpu_data *cpu_data;
>>>                        ^
>>>
>>> Also need notice about 80 columns boundary.
>>
>> I don't object to this change at all, but it could be easier to solve
>> this by fixing up 'cpu_data' to be named something a bit less "generic"?
>> What does x86 use for this data type?
> 
> The patch makes sense to me.
> 
> These arch-es already have 'cpu_data' in some form:
> 
> mips, sparc, arm64, blackfin, frv, mn10300, parisc, um(l), c6x, x86, xtensa,
> alpha, m32r, arm, ia64, metag, sn.
> 

Yeah, and m32r, mn10300 and um may let cpu_data as macro variable, which
may cause this issue. And others let cpu_data as function (or like a
function), I guess, they may not cause this issue.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

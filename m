Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab3ISXBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 19:01:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48343 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3ISXBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 19:01:10 -0400
Message-ID: <523B8225.9040504@infradead.org>
Date: Thu, 19 Sep 2013 16:00:53 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Jeff P. Zacher" <ad_sicks@yahoo.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: [stable] Re: Dependency bug in the uvcvideo Kconfig
References: <1828294.VXnhqsmrEo@localhost> <CA+MoWDp0zFXaEhYbwsEV_uMg3H0Nabx9iu25ixyuJvgWGxi=Gg@mail.gmail.com> <523A2EB4.6070407@infradead.org> <1697645.iYIvpGsUS4@localhost> <523B5BD6.4000500@infradead.org>
In-Reply-To: <523B5BD6.4000500@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/13 13:17, Randy Dunlap wrote:
> On 09/18/13 20:44, Jeff P. Zacher wrote:
>>  
>>
>> You are correct that this problem shown in the forum was in 3.5.4. However, I am 
>> having wither the same or similar problem in 3.10.7.
>> Here is the broken config file, saved as .config-bad
>>
> 
> The failing kernel config file is attached.

For Linux 3.10.x:


This is already fixed in mainline but patches need to be backported.
Specifically these 2 commits (in this order):


commit a0f9354b1a319cb29c331bfd2e5a15d7f9b87fa4
Author: Randy Dunlap <rdunlap@infradead.org>
Date:   Wed May 8 17:28:13 2013 -0300

    [media] media/usb: fix kconfig dependencies

and

commit 5077ac3b8108007f4a2b4589f2d373cf55453206
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Wed May 22 11:25:52 2013 -0300

    Properly handle tristate dependencies on USB/PCI menus


>>  
>>
>>  
>>
>> On Wednesday, September 18, 2013 03:52:36 PM you wrote:
>>
>>> On 09/18/13 08:37, Peter Senna Tschudin wrote:
>>
>>>> Hi Randy,
>>
>>>>
>>
>>>> I've tried to download the .config file from the link on the forum,
>>
>>>> but it tries to install something in my browser and the file is not
>>
>>>> downloadable for me. Can you provide it over an simpler interface such
>>
>>>> as pastebin.com?
>>
>>>>
>>
>>>> Thanks
>>
>>>
>>
>>> The original poster (Jeff) should have mentioned that is is a build bug
>>
>>> problem in Linux 3.5.4. Jeff, have you tried 3.5.7? I expect that this
>>
>>> problem is already fixed, if not in 3.5.x then in some later kernel
>>
>>> version.
>>
>>>
>>
>>> Jeff, also please provide the kernel .config file as an attachment here
>>
>>> since the one posted in the forum does not download (or has been deleted).
>>
>>>> On Wed, Sep 18, 2013 at 4:59 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>>>>> [adding linux-media mailing list]
>>
>>>>>
>>
>>>>> On 09/18/13 06:18, Jeff P. Zacher wrote:
>>
>>>>>> Not subscribed, please CC'me in replies:
>>
>>>>>>
>>
>>>>>> There seems to be a dependency bug in the Kconfig for the uvcvideo
>>
>>>>>> kernel
>>
>>>>>> module. If uvcvideo is built in and usb support is built as a module,
>>
>>>>>> the
>>
>>>>>> kernel build will fail with the obviously missing dependanies.
>>
>>>>>>
>>
>>>>>>
>>
>>>>>> Error logs:
>>
>>>>>>
>>
>>>>>> * ERROR: Failed to compile the "bzImage" target...
>>
>>>>>> *
>>
>>>>>> * -- Grepping log... --
>>
>>>>>> *
>>
>>>>>> * SHIPPED scripts/genksyms/keywords.hash.c
>>
>>>>>> * SHIPPED scripts/genksyms/parse.tab.h
>>
>>>>>> * SHIPPED scripts/genksyms/parse.tab.c
>>
>>>>>> * HOSTCC scripts/genksyms/lex.lex.o
>>
>>>>>> *scripts/genksyms/lex.lex.c_shipped: In function ‘yylex1’:
>>
>>>>>> *scripts/genksyms/lex.lex.c_shipped:904:1: warning: ignoring return
>>
>>>>>> value of ‘fwrite’, declared with attribute warn_unused_result
>>
>>>>>> [-Wunused-result] *--
>>
>>>>>> * CC drivers/video/console/font_8x16.o
>>
>>>>>> * CC drivers/video/console/softcursor.o
>>
>>>>>> * CC sound/core/seq/seq_memory.o
>>
>>>>>> * CC drivers/video/console/fbcondecor.o
>>
>>>>>> * CC sound/core/seq/seq_queue.o
>>
>>>>>> *drivers/video/console/fbcondecor.c:511:6: warning: function declaration
>>
>>>>>> isn’t a prototype [-Wstrict-prototypes]
>>
>>>>>> *--
>>
>>>>>> *(.text+0xf8fb1): undefined reference to `usb_submit_urb'
>>
>>>>>> *drivers/built-in.o: In function `uvc_init':
>>
>>>>>> *uvc_driver.c:(.init.text+0x908a): undefined reference to
>>
>>>>>> `usb_register_driver'
>>
>>>>>> *drivers/built-in.o: In function `uvc_cleanup':
>>
>>>>>> *uvc_driver.c:(.exit.text+0x67e): undefined reference to
>>
>>>>>> `usb_deregister'
>>
>>>>>> *make: *** [vmlinux] Error 1
>>
>>>>>> *--
>>
>>>>>> * Running with options: --lvm --menuconfig all
>>
>>>>>> * Using genkernel.conf from /etc/genkernel.conf
>>
>>>>>> * Sourcing arch-specific config.sh from
>>
>>>>>> /usr/share/genkernel/arch/x86_64/config.sh ..
>>
>>>>>> * Sourcing arch-specific modules_load from
>>
>>>>>> /usr/share/genkernel/arch/x86_64/modules_load ..
>>
>>>>>> *
>>
>>>>>> * ERROR: Failed to compile the "bzImage" target...
>>
>>>>>> *
>>
>>>>>> * -- End log... --
>>
>>>>>>
>>
>>>>>> Compiling uvc as a module allows the compilation to complete.
>>
>>>>>>
>>
>>>>>> Platform x86_64
>>
>>>>>>
>>
>>>>>> Ref: http://forums.gentoo.org/viewtopic-p-7398782.html#7398782


-- 
~Randy

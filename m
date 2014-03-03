Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaCCOWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:22:25 -0500
Received: from smtp-out-144.synserver.de ([212.40.185.144]:1029 "EHLO
	smtp-out-014.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754139AbaCCOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:22:23 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 14488
Message-ID: <53149037.20305@metafoo.de>
Date: Mon, 03 Mar 2014 15:22:47 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
CC: "'Takashi Iwai'" <tiwai@suse.de>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <liam.r.girdwood@intel.com>
Subject: Re: [alsa-devel] change kmalloc into vmalloc for large memory allocations
References: <35FD53F367049845BC99AC72306C23D102844605F38C@CNBJMBX05.corpusers.net> <s5hlhwvb9q8.wl%tiwai@suse.de> <35FD53F367049845BC99AC72306C23D102844605F38E@CNBJMBX05.corpusers.net> <s5hob1nabb5.wl%tiwai@suse.de> <s5hmwh7ab5w.wl%tiwai@suse.de> <35FD53F367049845BC99AC72306C23D102844605F392@CNBJMBX05.corpusers.net> <531468CA.6040302@metafoo.de> <35FD53F367049845BC99AC72306C23D102844605F393@CNBJMBX05.corpusers.net> <53146B6F.4000601@metafoo.de> <35FD53F367049845BC99AC72306C23D102844605F394@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D102844605F394@CNBJMBX05.corpusers.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 02:29 PM, Wang, Yalin wrote:
> Hi
>
>
> I find the num_links are defined here:
> https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/sound/soc/msm/msm8226.c?h=msm-3.10&id=d681c8e79c597a5e1ae79803dc0215d02df8fe34#n1812
>
>
> the ARRAY_SIZE is 42 , you mean the driver can't define so many elements ?
> how to implement it if we can't do like this ?
>

Looks like your platform is a bit special in this regard and requires quite 
a few more links than usual.

> Thanks
>
> -----Original Message-----
> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
> Sent: Monday, March 03, 2014 7:46 PM
> To: Wang, Yalin
> Cc: 'Takashi Iwai'; 'alsa-devel@alsa-project.org'; Mark Brown; 'linux-kernel@vger.kernel.org'; Liam Girdwood
> Subject: Re: [alsa-devel] change kmalloc into vmalloc for large memory allocations
>
> On 03/03/2014 12:36 PM, Wang, Yalin wrote:
>> Hi
>>
>> I am curious what number range is correct here for card->num_links ?
>
> It depends on your board. But typically I'd say <= 5, for most boards it's either 1 or 2.
>
>>
>>
>> Thanks
>>
>> -----Original Message-----
>> From: Lars-Peter Clausen [mailto:lars@metafoo.de]
>> Sent: Monday, March 03, 2014 7:35 PM
>> To: Wang, Yalin
>> Cc: 'Takashi Iwai'; 'alsa-devel@alsa-project.org'; Mark Brown;
>> 'linux-kernel@vger.kernel.org'; Liam Girdwood
>> Subject: Re: [alsa-devel] change kmalloc into vmalloc for large memory
>> allocations
>>
>> On 03/03/2014 12:13 PM, Wang, Yalin wrote:
>>> Hi
>>>
>>>
>>> I add logs in kernel , the result is :
>>>
>>> 532 <4>[    5.690094] @@ sizeof(struct snd_soc_pcm_runtime)=1488 card->num_links=42 card->num_aux_devs=0
>>>
>>> card->num_links=42 , is it correct ?
>>
>> Very unlikely. Make sure that it is properly initialized in your machine driver.
>>
>>>
>>> our hardware is qcom msm8x26 platform .
>>
>> This one doesn't seem to be in upstream.
>>
>>>
>>> Thanks
>>>
>>> -----Original Message-----
>>> From: Takashi Iwai [mailto:tiwai@suse.de]
>>> Sent: Monday, March 03, 2014 5:23 PM
>>> To: Wang, Yalin
>>> Cc: 'linux-kernel@vger.kernel.org'; Mark Brown; 'perex@perex.cz';
>>> 'alsa-devel@alsa-project.org'; Liam Girdwood
>>> Subject: Re: change kmalloc into vmalloc for large memory allocations
>>>
>>> At Mon, 03 Mar 2014 10:19:58 +0100,
>>> Takashi Iwai wrote:
>>>>
>>>> [Dropped unrelated subsystem MLs, and corrected Liam's address]
>>>
>>> Grrr, even Mark's address was obsoleted.  Here corrected.
>>>
>>>
>>> Takashi
>>>
>>>>
>>>> At Mon, 3 Mar 2014 09:55:15 +0800,
>>>> Wang, Yalin wrote:
>>>>>
>>>>> Hi  Takashi,
>>>>>
>>>>> For this one:
>>>>> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/tree/so
>>>>> u
>>>>> nd/soc/soc-core.c?h=master#n3772
>>>>>
>>>>> in my kernel log,
>>>>> the allocation size 62496,
>>>>> about 62KB,
>>>>
>>>> This looks way too much than expected.  I thought each struct
>>>> snd_soc_pcm_runtime should be 1 or 2kB.  The code allocating an
>>>> arary of snd_soc_pcm_runtime, so this might be due to some invalid
>>>> values there.
>>>>
>>>>> I think need to  change to vmalloc .
>>>>> How do you think of it ?
>>>>
>>>> This looks rather like a bug somewhere around it.
>>>>
>>>> Could you check the values there, sizeof(struct
>>>> snd_soc_pcm_runtime),
>>>> card->num_links and card->num_aux_devs?
>>>>
>>>> And, with which hardware is the issue examined?
>>>>
>>>>
>>>> thanks,
>>>>
>>>> Takashi
>>>>
>>>>>
>>>>> Logs:
>>>>> <4>[   11.469789] ------------[ cut here ]------------
>>>>> <4>[   11.469803] WARNING: at /media/00DE7FE2DE7FCE82/jb-mr2-yukon/kernel/include/linux/slub_def.h:265 __kmalloc+0x38/0x29c()
>>>>> <4>[   11.469811] size=62496 flags=80d0
>>>>> <4>[   11.469815] Modules linked in:
>>>>> <4>[   11.469835] [<c010c534>] (unwind_backtrace+0x0/0x11c) from [<c018ab04>] (warn_slowpath_common+0x4c/0x64)
>>>>> <4>[   11.469850] [<c018ab04>] (warn_slowpath_common+0x4c/0x64) from [<c018ab9c>] (warn_slowpath_fmt+0x2c/0x3c)
>>>>> <4>[   11.469864] [<c018ab9c>] (warn_slowpath_fmt+0x2c/0x3c) from [<c0249ab4>] (__kmalloc+0x38/0x29c)
>>>>> <4>[   11.469879] [<c0249ab4>] (__kmalloc+0x38/0x29c) from [<c06a0124>] (snd_soc_register_card+0x184/0x104c)
>>>>> <4>[   11.469896] [<c06a0124>] (snd_soc_register_card+0x184/0x104c) from [<c088183c>] (msm8226_asoc_machine_probe+0x298/0x7f0)
>>>>> <4>[   11.469913] [<c088183c>] (msm8226_asoc_machine_probe+0x298/0x7f0) from [<c044b1fc>] (platform_drv_probe+0x14/0x18)
>>>>> <4>[   11.469927] [<c044b1fc>] (platform_drv_probe+0x14/0x18) from [<c0449f2c>] (driver_probe_device+0x134/0x334)
>>>>> <4>[   11.469940] [<c0449f2c>] (driver_probe_device+0x134/0x334) from [<c044a194>] (__driver_attach+0x68/0x8c)
>>>>> <4>[   11.469953] [<c044a194>] (__driver_attach+0x68/0x8c) from [<c044849c>] (bus_for_each_dev+0x48/0x80)
>>>>> <4>[   11.469965] [<c044849c>] (bus_for_each_dev+0x48/0x80) from [<c0449528>] (bus_add_driver+0x100/0x26c)
>>>>> <4>[   11.469978] [<c0449528>] (bus_add_driver+0x100/0x26c) from [<c044a66c>] (driver_register+0x9c/0x120)
>>>>> <4>[   11.469992] [<c044a66c>] (driver_register+0x9c/0x120) from [<c010052c>] (do_one_initcall+0x90/0x160)
>>>>> <4>[   11.470007] [<c010052c>] (do_one_initcall+0x90/0x160) from [<c0d00b74>] (kernel_init+0xec/0x1a8)
>>>>> <4>[   11.470022] [<c0d00b74>] (kernel_init+0xec/0x1a8) from [<c0106aec>] (kernel_thread_exit+0x0/0x8)
>>>>> <4>[   11.470030] ---[ end trace 1b75b31a2719ed4d ]---
>>>>>
>>>>> BRs/ Yalin
>>>>> -----Original Message-----
>>>>> From: Takashi Iwai [mailto:tiwai@suse.de]
>>>>> Sent: Friday, February 28, 2014 10:20 PM
>>>>> To: Wang, Yalin
>>>>> Cc: 'linux-kernel@vger.kernel.org'; 'linux-arm-msm@vger.kernel.org'; 'linux-arm-kernel@lists.infradead.org'; 'linux-input@vger.kernel.org'; 'balbi@ti.com'; 'gregkh@linuxfoundation.org'; 'lrg@ti.com'; 'broonie@opensource.wolfsonmicro.com'; 'perex@perex.cz'; 'pablo@netfilter.org'; 'kaber@trash.net'; 'davem@davemloft.net'; 'rostedt@goodmis.org'; 'fweisbec@gmail.com'; 'mingo@redhat.com'; 'dmitry.torokhov@gmail.com'; 'rydberg@euromail.se'; 'linux-usb@vger.kernel.org'; 'alsa-devel@alsa-project.org'; 'netfilter-devel@vger.kernel.org'; 'netfilter@vger.kernel.org'; 'coreteam@netfilter.org'; 'netdev@vger.kernel.org'
>>>>> Subject: Re: change kmalloc into vmalloc for large memory
>>>>> allocations
>>>>>
>>>>> At Fri, 28 Feb 2014 16:15:23 +0800, Wang, Yalin wrote:
>>>>>>
>>>>>> Hi
>>>>>>
>>>>>>
>>>>>> I find there is some drivers use kmalloc to allocate large Memorys
>>>>>> during module_init,  some can be changed to use vmalloc To save
>>>>>> some low mem, I add log in kernel to track , And list them here:
>>>>>>
>>>>>> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/tree/d
>>>>>> rive
>>>>>> rs/usb/gadget/f_mass_storage.c?h=master#n2724
>>>>>>
>>>>>> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/tree/s
>>>>>> ound
>>>>>> /soc/soc-core.c?h=master#n3772
>>>>>
>>>>> At least the ASoC runtime case doesn't use the allocated memory as buffer, and they are allocated only once per device, thus it shouldn't be the problem you stated.  If it really consumes so much memory, we need to rethink, instead of allocating an array but allocate each object, for example.
>>>>>
>>>>>
>>>>> thanks,
>>>>>
>>>>> Takashi
>>>>>
>>>>>
>>>>>> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/tree/n
>>>>>> et/n
>>>>>> etfilter/nf_conntrack_ftp.c?h=master#n603
>>>>>> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/tree/n
>>>>>> et/n
>>>>>> etfilter/nf_conntrack_h323_main.c?h=master#n1849
>>>>>> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/tree/n
>>>>>> et/n
>>>>>> etfilter/nf_conntrack_irc.c?h=master#n247
>>>>>> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/tree/n
>>>>>> et/n
>>>>>> etfilter/nf_conntrack_sane.c?h=master#n195
>>>>>>
>>>>>> https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/tree/d
>>>>>> rive
>>>>>> rs/input/evdev.c?h=master#n403
>>>>>>
>>>>>>
>>>>>> they allocate large memory from 10k~64K , this will use lots of
>>>>>> low mem, instead if we use vmalloc for these drivers , it will be
>>>>>> good for some devices like smart phone, we often encounter some
>>>>>> errors like kmalloc failed because there is not enough low mem ,
>>>>>> especially when the device has physical memory less than 1GB .
>>>>>>
>>>>>>
>>>>>> could this module change the memory allocation into vmalloc ?
>>>>>>
>>>>>> I was thinking that if we can introduce a helper function in kmalloc.h like this :
>>>>>>
>>>>>> Kmalloc(size, flags)
>>>>>> {
>>>>>> 	If (size > PAGE_SIZE && flags&CAN_USE_VMALLOC_FLAG)
>>>>>> 		return vmalloc(size);
>>>>>> 	Else
>>>>>> 		return real_kmalloc(size);
>>>>>> }
>>>>>>
>>>>>> Kfree(ptr)
>>>>>> {
>>>>>> 	If (is_vmalloc_addr(ptr))
>>>>>> 		Vfree(ptr);
>>>>>> 	Else
>>>>>> 		Kfree(ptr);
>>>>>> }
>>>>>>
>>>>>>
>>>>>> But we need add some flags to ensure always use kmalloc for Some
>>>>>> special use (dma etc..)
>>>>>>
>>>>>> How do you think of it ?
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>>
>>>>>>
>>>>>
>>> _______________________________________________
>>> Alsa-devel mailing list
>>> Alsa-devel@alsa-project.org
>>> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>>>
>>
>


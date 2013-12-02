Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3LBSpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:45:13 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:10610 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab3LBSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:45:11 -0500
X-AuditID: cbfec37c-b7f9d6d000003434-36-529cd535e27b
Message-id: <529CD528.9000709@samsung.com>
Date: Mon, 02 Dec 2013 11:44:56 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Manuel Krause <manuelkrause@netscape.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-input@vger.kernel.org,
        linux-serial <linux-serial@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: 3.12.x looses serial mouse over hibernate + resume
References: <52951E69.7090602@netscape.net>
 <529B591F.1020909@hurleysoftware.com> <529CB07C.2040609@netscape.net>
 <19253701.sgP3OieFUq@dtor-d630.eng.vmware.com>
 <20131202164525.GA32406@core.coreip.homeip.net> <529CD303.4040103@netscape.net>
In-reply-to: <529CD303.4040103@netscape.net>
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9hP13Tq3OCDNp/aFscXvSC0aJ58Xo2
	i5ufvrFaXN41h83izOJedouuiQtZLI5d+sdo8XjFW3aLrz8dHDg9ds66y+6x4s96No/Fe14y
	eeyfu4bd42PPI2aPz5vkAtiiuGxSUnMyy1KL9O0SuDJ23TzLUvBAu+LDaeMGxvnKXYycHBIC
	JhI7925hhbDFJC7cW8/WxcjFISSwjFHi9sVlLBBOL5PE47Vz2SGcTYwSZy7OZwFp4RXQkjj2
	5CYziM0ioCrx4kknI4jNJqAu8fn1DnYQW0hATqJpyWqwGlGBCImjq5+xQvQKSvyYfA9sjohA
	jMT8zStYQRYwCxxmkph5ey1YQljAXuLgvu9Qm78xSjRO+Aa2gVNAR+JW53SgYzmAOmwkDs5P
	AwkzC8hLbF7zlhlisbLEn8unmEBKJAQUJbavtprAKDILyepZCM2zkDQvYGRexShWWpxcUJyU
	nlphrFecmFtcmpeul5yfu4kREmM1OxjvfbU5xCjAwajEw9uxdU6QEGtiWXFl7iFGCQ5mJRHe
	6ReAQrwpiZVVqUX58UWlOanFhxiZODilGhhnMpZP0duXM6PRXjrt54uYOUt7alrkF320a+gt
	ZnnzVHbaBQkG6+Tlzy5nrP7/PeXVjaWtlyQOWLbWtBpO3Pj2lI0c1xSZHX/16lvZn++/OeWP
	R+v9G69q5r8++qNeVOAsZ2+P7YHJvf2ubd80jef4Mdkzp7v0xE0I5L+tdq147TJmHyuhumAl
	luKMREMt5qLiRAC5289KjwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 11:35 AM, Manuel Krause wrote:
> On 2013-12-02 17:45, Dmitry Torokhov wrote:
>> On Mon, Dec 02, 2013 at 08:38:16AM -0800, Dmitry Torokhov wrote:
>>> On Monday, December 02, 2013 05:08:28 PM Manuel Krause wrote:
>>>> On 2013-12-01 16:43, Peter Hurley wrote:
>>>>> [ +cc Dmitry Torokhov, Greg Kroah-Hartman, linux-input,
>>>>> linux-serial ]
>>>>>
>>>>> On 11/26/2013 05:19 PM, Manuel Krause wrote:
>>>>>> Since kernel 3.12.0 I have a problem with hibernate+resume
>>>>>> not reactivating my serial mouse (trackball) with my HP notebook.
>>>>>> Kernels 3.11.0 til 9 don't show this behaviour.
>>>>>>
>>>>>> Machine:           HP Notebook with Core2Duo CPU (Penryn)
>>>>>> Distro:            openSUSE 12.3, 64bit, continuously updated
>>>>>> Desktop:           KDE 4.11.3
>>>>>> MESA & drm & Xorg: most recent ones from:
>>>>>>
>>>>>> http://download.opensuse.org/repositories/home:/pontostroy:/X11/openSUSE_
>>>>>>
>>>>>> 12.3/x86_64/
>>>>>>
>>>>>> Current kernel:    3.12.1 vanilla from openSUSE repos, with
>>>>>>
>>>>>>                      -ck1 and BFQ patches
>>>>>>
>>>>>> The Logitech Trackman Marble FX is a PS/2 device and connected
>>>>>> via an original Logitech
>>>>>> PS/2-COM-port adapter and manually configured via my xorg.conf.
>>>>>>
>>>>>> At first, I blamed the -ck1 patches from Con Kolivas for this
>>>>>> behaviour that I use in
>>>>>> addition  to the BFQ patches, what has showed up as not right:
>>>>>> This happens with the
>>>>>> normal vanilla kernel
>>>>>> schedulers for CPU and disk I/O, too.
>>>>>>
>>>>>> By coincidence I found a weird(!) way to reactivate the serial
>>>>>> mouse:
>>>>>> (1) call Hibernate (suspend-to-disk) from KDE desktop as normal
>>>>>> (2) resume --> the PS/2 touchpad is working, the serial
>>>>>> trackball NOT
>>>>>> (3) call suspend-to-RAM (Sleep) from KDE, serial trackball
>>>>>> still dead
>>>>>> (4) execute `setserial -a /dev/ttyS0` in a konsole window or a
>>>>>> tty* console
>>>>>> (5) ==> serial trackball is back with all configuration from
>>>>>> xorg.conf
>>>>>>
>>>>>> It's fully reproducible over multiple hibernations. This also
>>>>>> happens when calling
>>>>>> `pm-hibernate` (to-disk) and `pm-suspend` (to-RAM) and the
>>>>>> setserial from a root shell
>>>>>> in KDE or any tty*.
>>>>>>
>>>>>> Please, _always_CC_me_ -- as I'm not on the kernel mailing list.
>>>>>
>>>>> Manuel,
>>>>>
>>>>> Please attach complete dmesgs (zipped, if necessary) of a
>>>>> suspend/resume cycle
>>>>> on a vanilla 3.12.x (where resume fails) _and_ a vanilla 3.11.x
>>>>> (where resume succeeds).
>>>>>
>>>>> For the test configurations, please do not apply patches.
>>>>>
>>>>> Regards,
>>>>> Peter Hurley
>>>>
>>>> Thank you very much for your reply!
>>>> Attached you'll find a zip file with the two edited dmesg logs of
>>>> plain vanilla kernel runs.
>>>>
>>>> I have to add, that the resumes _do_ succeed in both cases, only
>>>> the serial mouse doesn't get activated after hibernate in 3.12.x
>>>> automatically. Just scan for and compare the lines indicating
>>>> "serial 00:08: disabled" or "serial 00:08: activated". In 3.12.x
>>>> the activation doesn't happen after hibernate, but after
>>>> suspend-to-ram (sleep). That only after STR and not before a
>>>> setserial gets my mouse back... a miracle. ;-)
>>>
>>> I do not see
>>>
>>>> [  206.577370] serial 00:08: activated
>>>
>>> in the restore from hibernation log of 3.12 which shoudl come from PNP
>>> layer.
>>>
>>> [dtor@dtor-d630 work]$ git log --oneline v3.11..v3.12 -- drivers/pnp/
>>> 729377d pnp: change pnp bus pm_ops to invoke pnp driver dev_pm_ops if
>>> specified
>>> ce63e18 Merge branch 'pnp'
>>> 8ad928d ACPI / PM: Use ACPI_STATE_D3_COLD instead of ACPI_STATE_D3
>>> everywhere
>>> eaf140b PNP: convert PNP driver bus legacy pm_ops to dev_pm_ops
>>>
>>> I'd start looking into these commits.
>>>
>>
>> Does the following patch fixes the issue?
>>
>
> PNP: fix restoring devices after hibernation
>
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> On returning from hibernation 'restore; callback is called, not 'resume'.
> This fixes breakage introduced by commit
> eaf140b60ec961252083ab8adaf67aef29a362dd
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>   drivers/pnp/driver.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
> index a39ee38..185a24a 100644
> --- a/drivers/pnp/driver.c
> +++ b/drivers/pnp/driver.c
> @@ -235,8 +235,9 @@ static int pnp_bus_resume(struct device *dev)
>
>   static const struct dev_pm_ops pnp_bus_dev_pm_ops = {
>       .suspend = pnp_bus_suspend,
> -    .freeze = pnp_bus_freeze,
>       .resume = pnp_bus_resume,
> +    .freeze = pnp_bus_freeze,
> +    .restore = pnp_bus_resume,
>   };
>
>   struct bus_type pnp_bus_type = {
>
>
> YES! This patch fixes the issue!!! (Even if compiled with a patched
> kernel.)   ;-)
>
> Many thanks for your work!
>
> Manuel Krause
>

I am glad the problem is fixed. But I am puzzled. pnp_bus_resume() 
didn't handle restore prior to this change. state doesn't get passed in 
to legacy resume routines. I had to add freeze to handle PMSG_FREEZE 
case, sounds like restore is needed as well, however I don't see where 
how restore is handled prior to this change.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

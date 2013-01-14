Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3ANINl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:13:41 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:60965 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3ANINj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:13:39 -0500
MIME-Version: 1.0
In-Reply-To: <CADpTngV4N-JtVKgT+FN_VoNWUyKdfvb=bsTVJC9MktREmdrSAg@mail.gmail.com>
References: <1520620637.200975.1355955029721.JavaMail.root@elliptictech.com>
	<1425298.zMcaSB7taE@calvin>
	<CADpTngUE7H9K2j3yCsm+TUx+X2RJZKaSz8kKn-ehpxzx1O2=fA@mail.gmail.com>
	<CAKMK7uF1ZyFu5JMUH91bUWzQey2RCH1awN2GVeu5w=nXkfJrEQ@mail.gmail.com>
	<CADpTngV4N-JtVKgT+FN_VoNWUyKdfvb=bsTVJC9MktREmdrSAg@mail.gmail.com>
Date: Mon, 14 Jan 2013 09:13:38 +0100
Message-ID: <CADpTngVJqvXfgnd2cMRFL49nt9so+dcwKos8cSLPRj6L0eEPMg@mail.gmail.com>
Subject: Re: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Cc: Tom St Denis <tstdenis@elliptictech.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at a different issue (rfkill), related to this commit:
====
> a57f7f9175b8ccbc9df83ac13860488913115de4 is the first bad commit
> commit a57f7f9175b8ccbc9df83ac13860488913115de4
> Author: Bob Moore <robert.moore@intel.com>
> Date: Fri Aug 17 10:55:02 2012 +0800
>
> ACPICA: Add Windows8/Server2012 string for _OSI method.
> This change adds a new _OSI string, "Windows 2012" for both Windows 8
> and Windows Server 2012.
> >From Microsoft document "How to Identify the Windows Version in ACPI
> by Using _OSI", July 13, 2012.
>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
====

I discovered that reverting this commit (or, as suggested by joeyli
<jlee@suse.com>, booting with acpi_osi="!Windows 2012" ) also fixes
the brightness issue. So it seems related to the same ACPI issue, now
I wonder how it's happened that I got the wrong commit while
bisecting. Sorry for the noise, now the issue is still there but makes
more sense ):)



2013/1/12 Fabio Coatti <fabio.coatti@gmail.com>:
> well, I tried to do that, bisecting between 3.6.10 and 3.7. I'm not
> sure to have done that properly, as the result seems quite harmless,
> however here it is:
>
> d978348b300595b067b80980f6a78db09fcd584c is the first bad commit
> commit d978348b300595b067b80980f6a78db09fcd584c
> Author: Bob Moore <robert.moore@intel.com>
> Date:   Fri Aug 17 10:51:47 2012 +0800
>
>     ACPICA: Split ACPICA initialization functions to new file, utxfinit.c
>
>     Split utxface.c to improve modularity and reduce file size.
>
>     Signed-off-by: Bob Moore <robert.moore@intel.com>
>     Signed-off-by: Feng Tang <feng.tang@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
>
> :040000 040000 57bc8451026afe02fdbc2970b152164ff4e5412a
> 55311ce2f9fed66501b06f93f67fa99b54d46e86 M      drivers
>
> Please let me know If I've done something wrong or if I can help in other ways.
>
> Many thanks for the hint.
>
>
> 2013/1/12 Daniel Vetter <daniel.vetter@ffwll.ch>:
>> On Sat, Jan 12, 2013 at 12:22 PM, Fabio Coatti <fabio.coatti@gmail.com> wrote:
>>> I'm seeing the same behaviour on 3.7.2; even
>>> echo "NN" > brightness has no effect.
>>> I've tried to look at changes between 3.6.11 and 3.7.2 but probably
>>> this is beyond my skills ;)
>>
>> If the regression is with the acpi_video backlight, then it's very
>> likely not a bug in drm/i915. Quickest way to figure that out is to do
>> a git bisect between 3.6 and 3.7, my favourite howto is:
>> http://www.reactivated.net/weblog/archives/2006/01/using-git-bisect-to-find-buggy-kernel-patches/
>>
>> Cheers, Daniel
>>
>>> 2012/12/20 Fabio Coatti <fabio.coatti@gmail.com>:
>>>> In data mercoledì 19 dicembre 2012 17:10:29, hai scritto:
>>>>> ----- Original Message -----
>>>>>
>>>>> > From: "Fabio Coatti" <fabio.coatti@gmail.com>
>>>>> > To: linux-kernel@vger.kernel.org
>>>>> > Sent: Wednesday, 19 December, 2012 5:01:30 PM
>>>>> > Subject: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
>>>>> >
>>>>> > Hi,
>>>>> > I'm testing kernels 3.7.X vs 3.6.11 on an HP Folio 9470m machine,
>>>>> > i915
>>>>> > driver for a VGA compatible controller: Intel Corporation 3rd Gen
>>>>> > Core
>>>>> > processor Graphics Controller (rev 09) 8086:0166
>>>>> >
>>>>> > With 3.6.11, the brightness can be correctly set using fn+f9/10: kde
>>>>> > shows the bar and brightness changes.
>>>>> >
>>>>> > With 3.7.1 kde shows the percentage bar and
>>>>> > /sys/class/backlight/acpi_video0/brightness is updated, but the
>>>>> > screen
>>>>> > brightness does not changes.
>>>>>
>>>>> I had a similar problem with my Dell laptop and i915/acpi...
>>>>>
>>>>> Is there another acpi_video? device?  In my case two showed up in 3.7
>>>>> whereas in 3.6 there was one.  In 3.7 it was controlling the wrong one
>>>>> apparently.
>>>>
>>>> Well, this seems not to be the case, I have only one acpi_video:
>>>>
>>>> calvin ~ # ls -l /sys/class/backlight/
>>>> totale 0
>>>> lrwxrwxrwx 1 root root 0 20 dic 09.20 acpi_video0 ->
>>>> ../../devices/pci0000:00/0000:00:02.0/backlight/acpi_video0
>>>>
>>>> calvin ~ # ls -l /sys/devices/pci0000:00/0000:00:02.0/backlight
>>>> totale 0
>>>> drwxr-xr-x 3 root root 0 20 dic 09.20 acpi_video0
>>>>
>>>>
>>>>
>>>> --
>>>> Fabio
>>>
>>>
>>>
>>> --
>>> Fabio
>>
>>
>>
>> --
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>
>
>
> --
> Fabio



-- 
Fabio

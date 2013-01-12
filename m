Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3ALMme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 07:42:34 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:38874 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3ALMmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 07:42:33 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CADpTngUE7H9K2j3yCsm+TUx+X2RJZKaSz8kKn-ehpxzx1O2=fA@mail.gmail.com>
References: <1520620637.200975.1355955029721.JavaMail.root@elliptictech.com>
	<1425298.zMcaSB7taE@calvin>
	<CADpTngUE7H9K2j3yCsm+TUx+X2RJZKaSz8kKn-ehpxzx1O2=fA@mail.gmail.com>
Date: Sat, 12 Jan 2013 13:42:31 +0100
Message-ID: <CAKMK7uF1ZyFu5JMUH91bUWzQey2RCH1awN2GVeu5w=nXkfJrEQ@mail.gmail.com>
Subject: Re: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: Tom St Denis <tstdenis@elliptictech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 12:22 PM, Fabio Coatti <fabio.coatti@gmail.com> wrote:
> I'm seeing the same behaviour on 3.7.2; even
> echo "NN" > brightness has no effect.
> I've tried to look at changes between 3.6.11 and 3.7.2 but probably
> this is beyond my skills ;)

If the regression is with the acpi_video backlight, then it's very
likely not a bug in drm/i915. Quickest way to figure that out is to do
a git bisect between 3.6 and 3.7, my favourite howto is:
http://www.reactivated.net/weblog/archives/2006/01/using-git-bisect-to-find-buggy-kernel-patches/

Cheers, Daniel

> 2012/12/20 Fabio Coatti <fabio.coatti@gmail.com>:
>> In data mercoledì 19 dicembre 2012 17:10:29, hai scritto:
>>> ----- Original Message -----
>>>
>>> > From: "Fabio Coatti" <fabio.coatti@gmail.com>
>>> > To: linux-kernel@vger.kernel.org
>>> > Sent: Wednesday, 19 December, 2012 5:01:30 PM
>>> > Subject: 3.7.X vs 3.6.11 HP Folio 9470m brightness regression?
>>> >
>>> > Hi,
>>> > I'm testing kernels 3.7.X vs 3.6.11 on an HP Folio 9470m machine,
>>> > i915
>>> > driver for a VGA compatible controller: Intel Corporation 3rd Gen
>>> > Core
>>> > processor Graphics Controller (rev 09) 8086:0166
>>> >
>>> > With 3.6.11, the brightness can be correctly set using fn+f9/10: kde
>>> > shows the bar and brightness changes.
>>> >
>>> > With 3.7.1 kde shows the percentage bar and
>>> > /sys/class/backlight/acpi_video0/brightness is updated, but the
>>> > screen
>>> > brightness does not changes.
>>>
>>> I had a similar problem with my Dell laptop and i915/acpi...
>>>
>>> Is there another acpi_video? device?  In my case two showed up in 3.7
>>> whereas in 3.6 there was one.  In 3.7 it was controlling the wrong one
>>> apparently.
>>
>> Well, this seems not to be the case, I have only one acpi_video:
>>
>> calvin ~ # ls -l /sys/class/backlight/
>> totale 0
>> lrwxrwxrwx 1 root root 0 20 dic 09.20 acpi_video0 ->
>> ../../devices/pci0000:00/0000:00:02.0/backlight/acpi_video0
>>
>> calvin ~ # ls -l /sys/devices/pci0000:00/0000:00:02.0/backlight
>> totale 0
>> drwxr-xr-x 3 root root 0 20 dic 09.20 acpi_video0
>>
>>
>>
>> --
>> Fabio
>
>
>
> --
> Fabio



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

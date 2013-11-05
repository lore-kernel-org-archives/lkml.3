Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3KEO3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:29:43 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:46653 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3KEO3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:29:41 -0500
MIME-Version: 1.0
In-Reply-To: <20131105125228.GB18093@kroah.com>
References: <1383641987-4403-1-git-send-email-felipe.contreras@gmail.com>
	<20131105125228.GB18093@kroah.com>
Date: Tue, 5 Nov 2013 08:29:40 -0600
Message-ID: <CAMP44s0i-xCNHW_PPyO57p9yt0X_9OaYSQDkVPoNKum=nEHQbw@mail.gmail.com>
Subject: Re: [PATCH] staging: new asus fan driver
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 6:52 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 05, 2013 at 02:59:47AM -0600, Felipe Contreras wrote:
>> Simple driver to enable control of the fan in ASUS laptops. So far this
>> has only been tested in ASUS Zenbook Prime UX31A, but according to some
>> online reference [1], it should work in other models as well.
>>
>> The implementation is very straight-forward, the only caveat is that the
>> fan speed needs to be saved after it has been manually changed because
>> it won't be reported properly until it goes back to 'auto' mode.
>>
>> [1] http://forum.notebookreview.com/asus/705656-fan-control-asus-prime-ux31-ux31a-ux32a-ux32vd.html
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> ---
>>
>> Two incarnations of this code exists [1][2], one that used ACPI methods
>> directly, and one through WMI. Unfortunately the WMI version needs us to pass
>> physicall addresses which is not exactly clean, and that's the only reason the
>> code is proposed for staging.
>>
>> Most likely this cannot graduate until acpica gets support to receive virtual
>> addresses.
>
> When is that going to happen?

I don't know. Presumably when I get it done, which might be never, or
a few days from now. Most likely it will take some time.

>>  [1] http://article.gmane.org/gmane.linux.power-management.general/36774
>>  [2] http://article.gmane.org/gmane.linux.kernel/1576463
>>
>>  drivers/staging/Kconfig                     |   2 +
>>  drivers/staging/Makefile                    |   1 +
>>  drivers/staging/asus-thermal/Kconfig        |   7 ++
>>  drivers/staging/asus-thermal/asus_thermal.c | 166 ++++++++++++++++++++++++++++
>
> I need a TODO file for a staging driver listing who is responsible for
> it, and what is needed to be done to it in order to get it out of
> staging.

Done.

-- 
Felipe Contreras

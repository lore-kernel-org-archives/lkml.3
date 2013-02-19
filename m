Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3BSMnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:43:41 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:63042 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3BSMnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:43:39 -0500
MIME-Version: 1.0
In-Reply-To: <511E7038.9010205@metafoo.de>
References: <CAMNxYswRsYtRF3kXKR676TZMCUsZPvk0auYTxpGVS2mRLmS8xw@mail.gmail.com>
	<20130122163655.GA21090@kroah.com>
	<CAMNxYswbiH-fW6YVvtWEr1W+SWRBU6ELv1bVRfNawpwcy+PZsA@mail.gmail.com>
	<20130129133346.GA1505@kroah.com>
	<CAMNxYszZNTh69-y+5RFVC9c5kgcyPaVET7784OPsTarB0fWm5w@mail.gmail.com>
	<CAMNxYszE+qQv2vVw6DqNGuow+30K-=+S8TfgyNJwFeEN=EfEsA@mail.gmail.com>
	<511E7038.9010205@metafoo.de>
Date: Tue, 19 Feb 2013 18:13:37 +0530
Message-ID: <CAMNxYszHu7SDSGk_FJ6A=VPEGu46NCRpgqFX3vcGS+=2fXEyqw@mail.gmail.com>
Subject: Re: Query related to MSR(Magnetic Stripe Reader) Device Driver
From: Priyaranjan Das <priyaranjan456789@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, mankad.maulik@gmail.com,
        linux-input@vger.kernel.org, sameo@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,Lars,

>>>
>>
>> The MSR IP can be also be used either as a general purpose ADC or in
>> Magnetic stripe card reader mode.The IP supports both the modes and
>> provides FIFO for storing ADC data.
>>
>> I also got to know about IIO subsystem where  ADC drivers are
>> implemented. Our use-case will be to use either Magnetic Stripe reader
>> mode or general purpose ADC mode in a given configuration. Can I use
>> IIO subsystem for the Magnetic Stripe driver?
>
> Hi,
>
> Well for the ADC functionality it certainly makes sense to use the IIO
> framework. The magnetic stripe reader functionality should probably go into
> drivers/input. How to do this exactly depends a bit on how exactly the
> hardware works. A good idea is probably to use a mfd driver which
> instantiates both the input and the IIO driver and does some arbitration
> between them. If the magnetic stripe reader is a feature that's build on top
> of the ADC functionality you could use the IIO in-kernel API to do ADC
> conversions from your input driver. If the ADC and magnetic stripe reader
> mode are exclusive-or it probably makes sense to only instantiate one of
> them at a time from the MFD driver.
>

The Hardware consists of an ADC and an in-built FIFO in it. The Device
can either be configured  as a Magnetic stripe reader or a GPADC.
After the ADC conversion,the data will be saved in the FIFO and the
driver has to read it and send it to the upper layers.Here the ADC and
Magnetic Stripe reader functionality are exclusively-or. In MSR mode,
the FIFO shall contain the track data for magnetic stripe card. This
data will be given to input subsystem.

To summarize below is my understanding:
1) drivers/input/misc: shall have the MSR driver.
2) drivers/iio/adc:   shall have the GPADC driver.
3) drivers/mfd:     shall support both above drivers and does arbitration.

Regards,
Priyaranjan

PS: Complete discussion can be found at [1]

[1] http://marc.info/?t=135884722400002&r=1&w=2

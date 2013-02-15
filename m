Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3BOR1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:27:05 -0500
Received: from smtp-out-045.synserver.de ([212.40.185.45]:1050 "EHLO
	smtp-out-045.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3BOR1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:27:03 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16436
Message-ID: <511E7038.9010205@metafoo.de>
Date: Fri, 15 Feb 2013 18:28:24 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Priyaranjan Das <priyaranjan456789@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, mankad.maulik@gmail.com
Subject: Re: Query related to MSR(Magnetic Stripe Reader) Device Driver
References: <CAMNxYswRsYtRF3kXKR676TZMCUsZPvk0auYTxpGVS2mRLmS8xw@mail.gmail.com> <20130122163655.GA21090@kroah.com> <CAMNxYswbiH-fW6YVvtWEr1W+SWRBU6ELv1bVRfNawpwcy+PZsA@mail.gmail.com> <20130129133346.GA1505@kroah.com> <CAMNxYszZNTh69-y+5RFVC9c5kgcyPaVET7784OPsTarB0fWm5w@mail.gmail.com> <CAMNxYszE+qQv2vVw6DqNGuow+30K-=+S8TfgyNJwFeEN=EfEsA@mail.gmail.com>
In-Reply-To: <CAMNxYszE+qQv2vVw6DqNGuow+30K-=+S8TfgyNJwFeEN=EfEsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 12:18 PM, Priyaranjan Das wrote:
> Hi Greg,
> 
> On Thu, Jan 31, 2013 at 11:09 AM, Priyaranjan Das
> <priyaranjan456789@gmail.com> wrote:
>> Hi Greg,
>>
>> On Tue, Jan 29, 2013 at 7:03 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Mon, Jan 28, 2013 at 03:25:08PM +0530, Priyaranjan Das wrote:
>>>> Hi Greg,
>>>>
>>>> On Tue, Jan 22, 2013 at 10:06 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>> On Tue, Jan 22, 2013 at 03:02:32PM +0530, Priyaranjan Das wrote:
>>>>>> Hi All,
>>>>>>
>>>>>> I am working on MSR(Magnetic Stripe Reader) for a product . I wish to
>>>>>> know whether any MSR( Magnetic Stripe/card Reader) driver is available
>>>>>> in the current source or not. I need this for reference. Could anyone
>>>>>> please help me?
>>>>>
>>>>> Most of these types of devices that I have worked with always show up as
>>>>> a keyboard device (ps/2 pass-through or a USB hid device.)  What type of
>>>>> interface does your device present to the operating system?
>>>>>
>>>>
>>>> The MSR will be a part of a SoC. It is  a memory mapped device hence
>>>> there is no interface like USB.
>>>
>>> Ok, that's different.  But how will your driver want to communicate the
>>> reader data to userspace?  That will probably determine where you want
>>> to put it.
>>>
>>> I would recommend making it an input device and sending keystrokes that
>>> you read from the card, so you can properly integrate into userspace
>>> applications that are used to using a card reader.
>>>
>>>> MSR IP contains an ADC which the driver will read and interpret the
>>>> data. I am planning to write a Driver for the same. Will this driver
>>>> fall under drivers/mfd/* ?
>>>
>>> As per the above, I would think drivers/input/ wouldn't you?
>>>
>>> Hope this helps,
>>>
>>
>> Thanks for your help!.
>>
>> Yes, you are right, it should be under drivers/input.
>> I am trying to prepare the design right now.
>>
>>
> 
> The MSR IP can be also be used either as a general purpose ADC or in
> Magnetic stripe card reader mode.The IP supports both the modes and
> provides FIFO for storing ADC data.
> 
> I also got to know about IIO subsystem where  ADC drivers are
> implemented. Our use-case will be to use either Magnetic Stripe reader
> mode or general purpose ADC mode in a given configuration. Can I use
> IIO subsystem for the Magnetic Stripe driver?

Hi,

Well for the ADC functionality it certainly makes sense to use the IIO
framework. The magnetic stripe reader functionality should probably go into
drivers/input. How to do this exactly depends a bit on how exactly the
hardware works. A good idea is probably to use a mfd driver which
instantiates both the input and the IIO driver and does some arbitration
between them. If the magnetic stripe reader is a feature that's build on top
of the ADC functionality you could use the IIO in-kernel API to do ADC
conversions from your input driver. If the ADC and magnetic stripe reader
mode are exclusive-or it probably makes sense to only instantiate one of
them at a time from the MFD driver.

- Lars


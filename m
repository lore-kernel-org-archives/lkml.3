Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935677Ab3BOLSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 06:18:35 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:57240 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926Ab3BOLSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 06:18:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAMNxYszZNTh69-y+5RFVC9c5kgcyPaVET7784OPsTarB0fWm5w@mail.gmail.com>
References: <CAMNxYswRsYtRF3kXKR676TZMCUsZPvk0auYTxpGVS2mRLmS8xw@mail.gmail.com>
	<20130122163655.GA21090@kroah.com>
	<CAMNxYswbiH-fW6YVvtWEr1W+SWRBU6ELv1bVRfNawpwcy+PZsA@mail.gmail.com>
	<20130129133346.GA1505@kroah.com>
	<CAMNxYszZNTh69-y+5RFVC9c5kgcyPaVET7784OPsTarB0fWm5w@mail.gmail.com>
Date: Fri, 15 Feb 2013 16:48:33 +0530
Message-ID: <CAMNxYszE+qQv2vVw6DqNGuow+30K-=+S8TfgyNJwFeEN=EfEsA@mail.gmail.com>
Subject: Re: Query related to MSR(Magnetic Stripe Reader) Device Driver
From: Priyaranjan Das <priyaranjan456789@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mankad.maulik@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Jan 31, 2013 at 11:09 AM, Priyaranjan Das
<priyaranjan456789@gmail.com> wrote:
> Hi Greg,
>
> On Tue, Jan 29, 2013 at 7:03 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Mon, Jan 28, 2013 at 03:25:08PM +0530, Priyaranjan Das wrote:
>>> Hi Greg,
>>>
>>> On Tue, Jan 22, 2013 at 10:06 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> > On Tue, Jan 22, 2013 at 03:02:32PM +0530, Priyaranjan Das wrote:
>>> >> Hi All,
>>> >>
>>> >> I am working on MSR(Magnetic Stripe Reader) for a product . I wish to
>>> >> know whether any MSR( Magnetic Stripe/card Reader) driver is available
>>> >> in the current source or not. I need this for reference. Could anyone
>>> >> please help me?
>>> >
>>> > Most of these types of devices that I have worked with always show up as
>>> > a keyboard device (ps/2 pass-through or a USB hid device.)  What type of
>>> > interface does your device present to the operating system?
>>> >
>>>
>>> The MSR will be a part of a SoC. It is  a memory mapped device hence
>>> there is no interface like USB.
>>
>> Ok, that's different.  But how will your driver want to communicate the
>> reader data to userspace?  That will probably determine where you want
>> to put it.
>>
>> I would recommend making it an input device and sending keystrokes that
>> you read from the card, so you can properly integrate into userspace
>> applications that are used to using a card reader.
>>
>>> MSR IP contains an ADC which the driver will read and interpret the
>>> data. I am planning to write a Driver for the same. Will this driver
>>> fall under drivers/mfd/* ?
>>
>> As per the above, I would think drivers/input/ wouldn't you?
>>
>> Hope this helps,
>>
>
> Thanks for your help!.
>
> Yes, you are right, it should be under drivers/input.
> I am trying to prepare the design right now.
>
>

The MSR IP can be also be used either as a general purpose ADC or in
Magnetic stripe card reader mode.The IP supports both the modes and
provides FIFO for storing ADC data.

I also got to know about IIO subsystem where  ADC drivers are
implemented. Our use-case will be to use either Magnetic Stripe reader
mode or general purpose ADC mode in a given configuration. Can I use
IIO subsystem for the Magnetic Stripe driver?

Regards,
Priyaranjan

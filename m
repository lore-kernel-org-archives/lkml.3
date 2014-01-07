Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbaAGGin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 01:38:43 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41190 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaAGGij convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 01:38:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140107035312.GA13379@kroah.com>
References: <CANthSfZij7=q1azM1wrRNDWjFY972zFpe4njBKr3bzUVsm5m-Q@mail.gmail.com>
	<20140107024050.GA8903@kroah.com>
	<CANthSfb+t53BZSXGe2VUUuHRYzphuT=-3vJtCSoERF_WChUr-A@mail.gmail.com>
	<20140107035312.GA13379@kroah.com>
Date: Tue, 7 Jan 2014 14:38:36 +0800
Message-ID: <CANthSfZGP1zHd2kog04DT6GO_0NrkyLuAm=oGpKWmQC+onYUBA@mail.gmail.com>
Subject: Re: [PATCH] usb:hub set hub->change_bits when over-current happens
From: Shen Guang <shenguang10@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 11:53 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jan 07, 2014 at 11:35:50AM +0800, 沈光 wrote:
>> On Tue, Jan 7, 2014 at 10:40 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Tue, Jan 07, 2014 at 10:33:14AM +0800, 沈光 wrote:
>> >> set hub->change_bits when we plug in a device which causes
>> >> over-current condition, so that hub_events() will check it.
>> >
>> > Why?
>> >
>> > What does this solve?  Is this a bug with existing devices that needs to
>> > be backported to older kernels?
>> >
>> > thanks,
>> >
>> > greg k-h
>>
>> This is something that we found when we are doing compliance test with xHCI.
>> If we enable CONFIG_USB_SUSPEND, and plug in a bad device which causes
>> over-current condition to the root port, the hub->change_bits will not
>> be set in current code in the function of hub_activate.
>
> Now that's something that should go in the changelog, don't you think?
>
> thanks,
>
> greg k-h

Sure, I agree.
I am sorry I didn't make it clear enough.
And the reason why over-current can be detected if CONFIG_USB_SUSPEND
is disabled, is that the interrupt pipe of the hub will report the
change and set hub->event_bits, and then hub_events() will check what
events happened.

Thanks,

Shen Guang

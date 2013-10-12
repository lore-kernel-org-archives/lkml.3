Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3JLG4C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 02:56:02 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:48898 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3JLG4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 02:56:00 -0400
MIME-Version: 1.0
In-Reply-To: <F6FB0E698C9B3143BDF729DF222866466FD67CA7@ORSMSX110.amr.corp.intel.com>
References: <1381460298-1097-1-git-send-email-ethan.kernel@gmail.com>
	<20131011153544.GA14715@kroah.com>
	<CAErSpo7KHk66uxqerQfo60OLU=WVO6zMtfH24L8QPy9RcMHJ6g@mail.gmail.com>
	<20131011161210.GB32305@kroah.com>
	<F6FB0E698C9B3143BDF729DF222866466FD67CA7@ORSMSX110.amr.corp.intel.com>
Date: Sat, 12 Oct 2013 14:55:59 +0800
Message-ID: <CABawtvMB9J+wxJNZzROvWcUO4UXMwZxpugCRMEHtk3CPqZLh5Q@mail.gmail.com>
Subject: Re: [PATCH] drivers/base/core.c: always output device renaming messages.
From: Ethan Zhao <ethan.kernel@gmail.com>
To: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 1:26 AM, Skidmore, Donald C
<donald.c.skidmore@intel.com> wrote:
>> -----Original Message-----
>> From: Greg KH [mailto:gregkh@linuxfoundation.org]
>> Sent: Friday, October 11, 2013 9:12 AM
>> To: Bjorn Helgaas
>> Cc: ethan.zhao; linux-kernel@vger.kernel.org; Skidmore, Donald C; e1000-
>> devel@lists.sourceforge.net
>> Subject: Re: [PATCH] drivers/base/core.c: always output device renaming
>> messages.
>>
>> On Fri, Oct 11, 2013 at 10:08:09AM -0600, Bjorn Helgaas wrote:
>> > [+cc Don, e1000-devel]
>> >
>> > On Fri, Oct 11, 2013 at 9:35 AM, Greg KH <gregkh@linuxfoundation.org>
>> wrote:
>> > > On Fri, Oct 11, 2013 at 10:58:18AM +0800, ethan.zhao wrote:
>> > >> From: "ethan.zhao" <ethan.kernel@gmail.com>
>> > >>
>> > >> While loading ixgbevf driver,every vf detected will be output as
>> > >> the same name 'eth4':
>> > >>
>> > >>  ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network
>> > >> Driver -  version 2.8.7  Copyright (c) 2009-2012 Intel Corporation.
>> > >>  ixgbevf 0000:20:10.0: enabling device (0000 -> 0002)  ixgbe
>> > >> 0000:20:00.0 eth0: VF Reset msg received from vf 0  ixgbevf
>> > >> 0000:20:10.0: irq 199 for MSI/MSI-X  ixgbevf 0000:20:10.0: irq 200
>> > >> for MSI/MSI-X
>> > >>  ixgbevf: eth%d: ixgbevf_init_interrupt_scheme: Multiqueue
>> > >> Disabled: Rx Queue  count = 1, Tx Queue count = 1
>> > >
>> > > What is that message?  That's not good, "eth%d"?
>> >
>> > Just a reminder that ixgbevf 2.8.7 is not the driver version that's in
>> > the kernel tree, so it's easy to spend time on mainline issue that
>> > have been fixed in the out-of-tree versions, or vice versa.
>> >
>> > Per Don, the latest ixgbevf driver is here:
>> > https://sourceforge.net/projects/e1000/files/ixgbevf%20stable/
>>
>> I hate to ask why isn't this merged upstream, but given that this is an Intel
>> network driver, I know the answer :(
>>
>> Thanks for pointing this out, saved me a trip through the kernel tree...
>>
>
> That message sure does look strange "eth%d"?   From reading your email I'm implying that it came from a 2.8.7 out or tree driver, is that correct?  The reason I'm asking is I want to make sure this is not an issue in the kernel tree or the latest out of tree driver.
Yes, it came from ixgbevf 2.8.7
>
> Also for what it is worth I do have all the patches queued in Jeff K. tree that gets the kernel tree and latest out of tree driver functionally in sync.  Once they pass our internal validation he should be pushing them upstream.
>
> Thanks for pointing out the error,
> -Don Skidmore <donald.c.skidmore@intel.com>
>
>

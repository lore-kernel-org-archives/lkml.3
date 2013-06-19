Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171Ab3FSCxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:53:07 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:52741 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836Ab3FSCxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:53:05 -0400
MIME-Version: 1.0
In-Reply-To: <51C0E73F.1060708@redhat.com>
References: <20130530183955.14686.89444.stgit@bling.home> <20130618172819.GA16134@google.com>
 <1371579648.22681.209.camel@ul30vt.home> <CAErSpo5mRKhBYun_i=iFppmQ5+7ODCY7q=sehHjBXWqPRH=ZZw@mail.gmail.com>
 <1371594159.22659.34.camel@ul30vt.home> <51C0E73F.1060708@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Jun 2013 20:52:43 -0600
Message-ID: <CAErSpo7ambrpYm6Lw5bfb5k83ZpHgMvcZxtohVJvo2iTLOF1EQ@mail.gmail.com>
Subject: Re: [PATCH] pci: Enable overrides for missing ACS capabilities
To: Don Dutile <ddutile@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 5:03 PM, Don Dutile <ddutile@redhat.com> wrote:
> On 06/18/2013 06:22 PM, Alex Williamson wrote:
>>
>> On Tue, 2013-06-18 at 15:31 -0600, Bjorn Helgaas wrote:
>>>
>>> On Tue, Jun 18, 2013 at 12:20 PM, Alex Williamson
>>> <alex.williamson@redhat.com>  wrote:
>>>>
>>>> On Tue, 2013-06-18 at 11:28 -0600, Bjorn Helgaas wrote:
>>>>>
>>>>> On Thu, May 30, 2013 at 12:40:19PM -0600, Alex Williamson wrote:
> ...
>>>>> Who do you expect to decide whether to use this option?  I think it
>>>>> requires intimate knowledge of how the device works.
>>>>>
>>>>> I think the benefit of using the option is that it makes assignment of
>>>>> devices to guests more flexible, which will make it attractive to
>>>>> users.
>>>>> But most users have no way of knowing whether it's actually *safe* to
>>>>> use this.  So I worry that you're adding an easy way to pretend
>>>>> isolation
>>>>> exists when there's no good way of being confident that it actually
>>>>> does.

> ...

>>> I wonder if we should taint the kernel if this option is used (but not
>>> for specific devices added to pci_dev_acs_enabled[]).  It would also
>>> be nice if pci_dev_specific_acs_enabled() gave some indication in
>>> dmesg for the specific devices you're hoping to add to
>>> pci_dev_acs_enabled[].  It's not an enumeration-time quirk right now,
>>> so I'm not sure how we'd limit it to one message per device.
>>
>> Right, setup vs use and getting single prints is a lot of extra code.
>> Tainting is troublesome for support, Don had some objections when I
>> suggested the same to him.
>>
> For RH GSS (Global Support Services), a 'taint' in the kernel printk means
> RH doesn't support that system.  The 'non-support' due to 'taint' being
> printed
> out in this case may be incorrect -- RH may support that use, at least until
> a more sufficient patched kernel is provided.
> Thus my dissension that 'taint' be output.  WARN is ok. 'driver beware',
> 'unleashed dog afoot'.... sure...

So ...  that's really a RH-specific support issue, and easily worked
around by RH adding a patch that turns off tainting.

It still sounds like a good idea to me for upstream, where use of this
option can very possibly lead to corruption or information leakage
between devices the user claimed were isolated, but in fact were not.

Bjorn

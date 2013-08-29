Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab3H2WWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:22:45 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:61056 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab3H2WWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX9gU-S9X_eeB=JwqS8130CONKgrv+mGj1cEgShmxgS-Q@mail.gmail.com>
References: <CAErSpo4cC7XKQn+2Pg9r+VDrcqKP4M4KQFRqQAvegTbnkUWf+A@mail.gmail.com>
 <CAE9FiQX9gU-S9X_eeB=JwqS8130CONKgrv+mGj1cEgShmxgS-Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 29 Aug 2013 16:22:22 -0600
Message-ID: <CAErSpo4qEPQq==rmzy+8a2FHgaKmWbG7BvopKqbBZC551kgdcg@mail.gmail.com>
Subject: Re: [PATCH v8 6/6] PCI: update device mps when doing pci hotplug
To: Yinghai Lu <yinghai@kernel.org>
Cc: Yijing Wang <wangyijing@huawei.com>, Jon Mason <jdmason@kudzu.us>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Jin Feng <joe.jin@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 3:47 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Aug 29, 2013 at 2:09 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> [+cc linux-kernel, since more folks might be interested]
>
>> I don't know what the BIOS "auto" setting means, but it must mean
>> something in case 3, because that's the only case where OS support is
>> required.  But if the OS is smart enough to manage MPS for hot-added
>> devices, why can't the OS also program MPS for the whole system at
>> boot-time?
>>
>> That's why I don't understand what BIOS wants to do.  It sounds like
>> they want the performance benefit of larger MPS for devices present in
>> hot-plug slots at boot-time, even if the OS doesn't actively manage
>> MPS and things blow up if that device is replaced with one that
>> supports a smaller MPS.  That choice doesn't make sense.
>>
>> In case 3, with a non-MPS-aware OS, you get better performance for a
>> while, but blow up if a card is replaced.  And with an MPS-aware OS,
>> there should be no advantage to case 3: the OS should be able to get
>> good performance by programming MPS itself, even without help from the
>> BIOS.
>
> With OS default setting on case 3, other two OS are ok with hotplug,
> but Linux does not.

I'm not disputing that.  I said plainly that in case 3, things blow up
if the OS doesn't actively manage MPS.  By default Linux doesn't touch
MPS, so it blows up if a card is replaced.

I am suggesting that it doesn't make any sense for a BIOS to use case
3.  Please make an argument for why it *does* make sense to use case
3.

Note that I think Linux *should* eventually actively manage MPS, and
when it does, case 3 should "just work".  I just don't understand what
the point of the BIOS using case 3 is.

I suppose other OSes must get better performance in this "auto" mode?
(What exactly is that mode, anyway?)  That means the other OS must be
smart enough to deal with hotplug device replacement, but not smart
enough to configure MPS all by itself starting from scratch.  I don't
know what rules would tell us "this MPS must be configured by the BIOS
and the OS should leave it alone" and "the OS must configure MPS on
this device for hotplug."  How can we make sense out of that?

Bjorn

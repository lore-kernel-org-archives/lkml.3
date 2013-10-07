Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3JGUsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:48:24 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44374 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab3JGUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <20131007204128.GB7600@kroah.com>
References: <1381128950-28125-1-git-send-email-gregkh@linuxfoundation.org>
 <1381128950-28125-2-git-send-email-gregkh@linuxfoundation.org>
 <CAErSpo7srZ8K_0EChA3Tqv5Zt4bA4MdKEx-n4KRNfrgSwcazyQ@mail.gmail.com> <20131007204128.GB7600@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Oct 2013 14:47:59 -0600
Message-ID: <CAErSpo6WSEUt6kfTxL+L77nvRY8X2MLLuA1pscD5UmN9X+KZaw@mail.gmail.com>
Subject: Re: [PATCH 01/11] pci: convert bus code to use dev_groups
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 2:41 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 07, 2013 at 12:21:36PM -0600, Bjorn Helgaas wrote:
>> [+cc Sachin]
>>
>> On Mon, Oct 7, 2013 at 12:55 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > The dev_attrs field of struct bus_type is going away soon, dev_groups
>> > should be used instead.  This converts the PCI bus code to use the
>> > correct field.
>> >
>> > Cc: Bjorn Helgaas <bhelgaas@google.com>
>> > Cc: <linux-pci@vger.kernel.org>
>> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > ---
>> >
>> > Bjorn, I can take this through my driver-core tree if you like, just let
>> > me know what would be the easiest for you.
>>
>> Let me take it, if I can figure out how to do it.  I already tripped
>> over a conflict where Sachin made pci_bus_attrs static, which is fine
>> in linux-next (with your 244afeca ("PCI: convert bus code to
>> use bus_groups") commit), but not fine in pci/next, which didn't have that.
>
> Ah, yeah, that will conflict, sorry.
>
>> I should be able to "git merge --no-ff --log gregkh/driver-core-next"
>> into my "next" branch, then apply your patch as usual, right?
>
> You can, but do you really want all of my driver-core changes in there?
> I can just send you the one pci change and you can then apply both of
> them.  Then when we merge with Linus, there will not be any conflicts as
> the same patches just showed up in two different trees, which should be
> fine.

Yes, putting just the PCI changes in my tree sounds much better.  I'll
try to work out what I need, and I'll poke you again if I need help :)

Bjorn

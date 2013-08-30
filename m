Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3H3PlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:41:23 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:50207 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab3H3PlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVXri56BzLviVjSPnqQvo25Q36AA26V_28kfy_=9EunjA@mail.gmail.com>
References: <CAErSpo4cC7XKQn+2Pg9r+VDrcqKP4M4KQFRqQAvegTbnkUWf+A@mail.gmail.com>
 <CAE9FiQX9gU-S9X_eeB=JwqS8130CONKgrv+mGj1cEgShmxgS-Q@mail.gmail.com>
 <CAErSpo4qEPQq==rmzy+8a2FHgaKmWbG7BvopKqbBZC551kgdcg@mail.gmail.com> <CAE9FiQVXri56BzLviVjSPnqQvo25Q36AA26V_28kfy_=9EunjA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 30 Aug 2013 09:41:00 -0600
Message-ID: <CAErSpo69TBOz6FJv8gPoAA9GFdJLuxyZWPy6gPHRbBAZKN047Q@mail.gmail.com>
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

On Thu, Aug 29, 2013 at 4:46 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Aug 29, 2013 at 3:22 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> Note that I think Linux *should* eventually actively manage MPS, and
>> when it does, case 3 should "just work".  I just don't understand what
>> the point of the BIOS using case 3 is.
>>
>> I suppose other OSes must get better performance in this "auto" mode?
>
> Yes.

My take on this is that "auto" mode really means "Windows" mode,
because it's a BIOS workaround for shortcomings in Windows.  It's
tailored to do system-wide MPS configuration that Windows doesn't do,
while relying on Windows to do minimal reconfiguration after a
hot-plug.  I don't feel any particular urgency to make Linux work with
that.

In my opinion, a BIOS should configure the machine in the safest
possible way.  Then everything works, and if we boot an OS that is
smart enough to reconfigure it in a more optimal way, that's great,
but it's not required.  For MPS, I think that means configuring the
machine as I outlined in case 1 (MPS=128 always) or case 2 (larger MPS
allowed on non-hotplug paths if the BIOS knows the root complex splits
packets).

>> (What exactly is that mode, anyway?)  That means the other OS must be
>> smart enough to deal with hotplug device replacement, but not smart
>> enough to configure MPS all by itself starting from scratch.  I don't
>> know what rules would tell us "this MPS must be configured by the BIOS
>> and the OS should leave it alone" and "the OS must configure MPS on
>> this device for hotplug."  How can we make sense out of that?
>
> So my suggestion:
> We scan mps of in the bridges to find out if any is set to other than 128.
> if there is any bridge that mps is not 128 and it is hotplug slot.
> We change to PCI_BUS_TUNE_PERF for that system.

That seems too arbitrary and magic to me.  I don't really want to set
modes based on what we discover in the machine.  If we're going to do
MPS config, we should just do it right and do it everywhere.

This discussion is not really going anywhere because we don't have any
concrete changes on the table, so I'm going to try to resist
continuing this thread :)

Bjorn

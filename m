Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3JDP4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:56:23 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55650 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3JDP4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:56:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVYZ2pRTs5Xsc2MKgUiWfLbSExLA-vF0HK2iy=tVw2OHA@mail.gmail.com>
References: <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
 <1380399187-4962-1-git-send-email-yinghai@kernel.org> <20131003220628.GA14835@google.com>
 <CAE9FiQVYZ2pRTs5Xsc2MKgUiWfLbSExLA-vF0HK2iy=tVw2OHA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 Oct 2013 09:55:59 -0600
Message-ID: <CAErSpo79xHn7RNNrbQBa49M464xryqjwi_iTPjTCnhEphkCvEg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Workaround missing pci_set_master in pci drivers
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 5:35 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Oct 3, 2013 at 3:06 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sat, Sep 28, 2013 at 01:13:07PM -0700, Yinghai Lu wrote:
>>> @@ -1156,8 +1156,14 @@ static void pci_enable_bridge(struct pci
>>>
>>>       pci_enable_bridge(dev->bus->self);
>>>
>>> -     if (pci_is_enabled(dev))
>>> +     if (pci_is_enabled(dev)) {
>>> +             if (!dev->is_busmaster) {
>>> +                     dev_warn(&dev->dev, "driver skip pci_set_master, fix it!\n");
>>
>> I know this is already in Linus' tree, but if we're going to enable
>> bus mastering here, what's the point of the warning?  If somebody
>> fixes the driver by adding a pci_set_master() call there, does that
>> improve something?
>
> Help us to catch other offender and fix them.

What is improved by doing it in the driver instead of here?

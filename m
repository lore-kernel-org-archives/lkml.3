Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3JCXfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:35:43 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:32843 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JCXfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:35:41 -0400
MIME-Version: 1.0
In-Reply-To: <20131003220628.GA14835@google.com>
References: <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
	<1380399187-4962-1-git-send-email-yinghai@kernel.org>
	<20131003220628.GA14835@google.com>
Date: Thu, 3 Oct 2013 16:35:40 -0700
X-Google-Sender-Auth: 8FYEry4PJz1lrR5YZRW_cUoq_Ow
Message-ID: <CAE9FiQVYZ2pRTs5Xsc2MKgUiWfLbSExLA-vF0HK2iy=tVw2OHA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Workaround missing pci_set_master in pci drivers
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 3:06 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sat, Sep 28, 2013 at 01:13:07PM -0700, Yinghai Lu wrote:
>> @@ -1156,8 +1156,14 @@ static void pci_enable_bridge(struct pci
>>
>>       pci_enable_bridge(dev->bus->self);
>>
>> -     if (pci_is_enabled(dev))
>> +     if (pci_is_enabled(dev)) {
>> +             if (!dev->is_busmaster) {
>> +                     dev_warn(&dev->dev, "driver skip pci_set_master, fix it!\n");
>
> I know this is already in Linus' tree, but if we're going to enable
> bus mastering here, what's the point of the warning?  If somebody
> fixes the driver by adding a pci_set_master() call there, does that
> improve something?

Help us to catch other offender and fix them.

Yinghai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936133AbaH1CSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:18:16 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:58796 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaH1CSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:18:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9twcfXzFMgHEqj4aQAjsrewOfCK6o4ibrJ5ENP1Z8epM8g@mail.gmail.com>
References: <20140827190125.29558.80166.stgit@gimli.home>
	<CADnq5_MaPBTm-PtCq57KLJqZuxw4qTuZgyzHGqhfQoY95YxYsQ@mail.gmail.com>
	<CAPM=9twcfXzFMgHEqj4aQAjsrewOfCK6o4ibrJ5ENP1Z8epM8g@mail.gmail.com>
Date: Wed, 27 Aug 2014 22:18:13 -0400
Message-ID: <CADnq5_MG2savPeRfUQ-pojCY=jVsvZVBO0TVGJ1LjhKxqR08nA@mail.gmail.com>
Subject: Re: [PATCH] radeon: Test for PCI root bus before assuming bus->self
From: Alex Deucher <alexdeucher@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 9:32 PM, Dave Airlie <airlied@gmail.com> wrote:
>> On Wed, Aug 27, 2014 at 3:01 PM, Alex Williamson
>> <alex.williamson@redhat.com> wrote:
>>> If we assign a Radeon device to a virtual machine, we can no longer
>>> assume a fixed hardware topology, like the GPU having a parent device.
>>> This patch simply adds a few pci_is_root_bus() tests to avoid passing
>>> a NULL pointer to PCI access functions, allowing the radeon driver to
>>> work in a QEMU 440FX machine with an assigned HD8570 on the emulated
>>> PCI root bus.
>>>
>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>
>
> Does this mean inside a VM we can't enable pcie 2 speeds?
>
> This could lead to a quite disappointing speed decrease for DMA transfers.

It depends on the sbios, but most boards negotiate the highest speed at boot.

Alex

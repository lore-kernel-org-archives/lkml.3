Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbaH1BdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:33:01 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:40806 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaH1Bc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <CADnq5_MaPBTm-PtCq57KLJqZuxw4qTuZgyzHGqhfQoY95YxYsQ@mail.gmail.com>
References: <20140827190125.29558.80166.stgit@gimli.home>
	<CADnq5_MaPBTm-PtCq57KLJqZuxw4qTuZgyzHGqhfQoY95YxYsQ@mail.gmail.com>
Date: Thu, 28 Aug 2014 11:32:58 +1000
Message-ID: <CAPM=9twcfXzFMgHEqj4aQAjsrewOfCK6o4ibrJ5ENP1Z8epM8g@mail.gmail.com>
Subject: Re: [PATCH] radeon: Test for PCI root bus before assuming bus->self
From: Dave Airlie <airlied@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
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

> On Wed, Aug 27, 2014 at 3:01 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
>> If we assign a Radeon device to a virtual machine, we can no longer
>> assume a fixed hardware topology, like the GPU having a parent device.
>> This patch simply adds a few pci_is_root_bus() tests to avoid passing
>> a NULL pointer to PCI access functions, allowing the radeon driver to
>> work in a QEMU 440FX machine with an assigned HD8570 on the emulated
>> PCI root bus.
>>
>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>

Does this mean inside a VM we can't enable pcie 2 speeds?

This could lead to a quite disappointing speed decrease for DMA transfers.

Dave.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaAGSqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:46:50 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:33280 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaAGSqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:46:32 -0500
MIME-Version: 1.0
In-Reply-To: <20140107104611.GI4770@phenom.ffwll.local>
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140107104611.GI4770@phenom.ffwll.local>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 7 Jan 2014 11:46:11 -0700
Message-ID: <CAErSpo4E8T18NLtgJ3A9ge_bLEsShrxC7pvZfMH4wP5fObPoLA@mail.gmail.com>
Subject: Re: [PATCH v7 00/15] PCI: Allocate 64-bit BARs above 4G when possible
To: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 3:46 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Mon, Jan 06, 2014 at 05:55:12PM -0700, Bjorn Helgaas wrote:
>> This is basically v7 of Yinghai's patch series:
>> http://lkml.kernel.org/r/1387485843-17403-1-git-send-email-yinghai@kernel.org
>>
>> The goal is to try to put 64-bit BARs above 4G so we can preserve the
>> 32-bit bus address space for 32-bit BARs.
>>
>> There are a whole bunch of AGP updates at the beginning because some AGP
>> devices have 64-bit BARs, but most of the AGP drivers read the aperture
>> bus address directly from the BAR, and they only handle 32-bit BARs.
>> Putting BARs above 4G would break those drivers, so we tried to fix them
>> up first.  Yinghai fixed intel-gtt.c, and I made similar fixes to all
>> the other AGP drivers I could find.
>>
>> Some of the AGP updates are related to the fact that most of the drivers
>> assume the PCI bus address is the same as the CPU physical address.  For
>> example, they read the bus address from the BAR, then call ioremap() on
>> it.  This is wrong, because ioremap() expects a CPU physical address,
>> not a bus address.  In most cases, I think AGP devices are in simple
>> systems where (bus_address == CPU_physical_address), so these updates
>> probably don't fix any broken systems.  I'm pretty sure there are more
>> things like this that should be fixed.
>> ...

> Patches 4-11 are Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Thanks a lot!  I added your Reviewed-by to those patches.

Bjorn

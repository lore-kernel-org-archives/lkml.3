Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3IZG7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:59:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab3IZG73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:59:29 -0400
Message-ID: <5243DB2A.7090609@vlnb.net>
Date: Wed, 25 Sep 2013 23:58:50 -0700
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: rob.gittins@linux.intel.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@veger.org,
        linux-pmfs@lists.infradead.org
Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>	 <522AB5AD.6070206@vlnb.net> <1379976688.5886.12.camel@Virt-Centos-6.lm.intel.com>
In-Reply-To: <1379976688.5886.12.camel@Virt-Centos-6.lm.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:oqH0DwJH0JvxKhKDr/tzKTN4uRyg0W6XIbywtuqc6zp
 xFIZeNo2amg5DBRNfZFgDgpSfYlvWTOQUvP3Z1xcSQHVt1lRst
 Ak6Wnhgwccrff84r23nufAe9SPRh5XyP07oRdJo2pwONvgvhuf
 s1c3W8QpqXOiDglCD8WFGEJG1now16E2qFoZbe7OnmRTBvsdmb
 L/RZDa2LqXF7mG36WQqGT8AsPEjtELzt4xRpM/gvKbrF4mmMHl
 sODonMqat8qC62feYNd0iXegxYItbs03J2iPVaYX18M+y1NN2E
 7MdUhA6Q8VRGOFLsWQLSoqDBM/I+zzMznDma0FCgBGStORNqA=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

Rob Gittins, on 09/23/2013 03:51 PM wrote:
> On Fri, 2013-09-06 at 22:12 -0700, Vladislav Bolkhovitin wrote:
>> Rob Gittins, on 09/04/2013 02:54 PM wrote:
>>> Non-volatile DIMMs have started to become available.  A NVDIMMs is a
>>> DIMM that does not lose data across power interruptions.  Some of the
>>> NVDIMMs act like memory, while others are more like a block device
>>> on the memory bus. Application uses vary from being used to cache
>>> critical data, to being a boot device.
>>>
>>> There are two access classes of NVDIMMs,  block mode and
>>> “load/store” mode DIMMs which are referred to as Direct Memory
>>> Mappable.
>>>
>>> The block mode is where the DIMM provides IO ports for read or write
>>> of data.  These DIMMs reside on the memory bus but do not appear in the
>>> application address space.  Block mode DIMMs do not require any changes
>>> to the current infrastructure, since they provide IO type of interface.
>>>
>>> Direct Memory Mappable DIMMs (DMMD) appear in the system address space
>>> and are accessed via load and store instructions.  These NVDIMMs
>>> are part of the system physical address space (SPA) as memory with
>>> the attribute that data survives a power interruption.  As such this
>>> memory is managed by the kernel which can  assign virtual addresses and
>>> mapped into application’s address space as well as being accessible
>>> by the kernel.  The area mapped into the system address space is
>>> being referred to as persistent memory (PMEM).
>>>
>>> PMEM introduces the need for new operations in the
>>> block_device_operations to support the specific characteristics of
>>> the media.
>>>
>>> First data may not propagate all the way through the memory pipeline
>>> when store instructions are executed.  Data may stay in the CPU cache
>>> or in other buffers in the processor and memory complex.  In order to
>>> ensure the durability of data there needs to be a driver entry point
>>> to force a byte range out to media.  The methods of doing this are
>>> specific to the PMEM technology and need to be handled by the driver
>>> that is supporting the DMMDs.  To provide a way to ensure that data is
>>> durable adding a commit function to the block_device_operations vector.
>>>
>>>    void (*commitpmem)(struct block_device *bdev, void *addr);
>>
>> Why to glue to the block concept for apparently not block class of devices? By pushing
>> NVDIMMs into the block model you both limiting them to block devices capabilities as
>> well as have to expand block devices by alien to them properties
> Hi Vlad,
> 
> We chose to extent the block operations for a couple of reasons.  The
> majority of NVDIMM usage is by emulating block mode.  We figure that
> over time usages will appear that use them directly and then we can
> design interfaces to enable direct use.  
> 
> Since a range of NVDIMM needs a name, security and other attributes mmap
> is a really good model to build on.  This quickly takes us into the
> realm of a file systems, which are easiest to build on the existing
> block infrastructure.  
> 
> Another reason to extend block is that all of the existing
> administrative interfaces and tools such as mkfs still work and we have
> not added some new management tools and requirements that may inhibit
> the adoption of the technology.  Basically if it works today for block
> the same cli commands will work for NVDIMMs.
> 
> The extensions are so minimal that they don't negatively impact the
> existing interfaces.

Well, they will negatively impact them, because those NVDIMM additions are conceptually
alien for the block devices concept.

You didn't answer, why not create a new class of devices for NVDIMM devices, and
implement one-fit-all block driver for them? Simple, clean and elegant solution, which
will fit your need to have block device from NVDIMM device pretty well with minimal effort.

Vlad

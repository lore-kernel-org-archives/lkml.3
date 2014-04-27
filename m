Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaD0HxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:53:04 -0400
Received: from hosting.rozsnyo.com ([77.93.220.61]:46296 "EHLO
	smtp.rozsnyo.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753355AbaD0HxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:53:01 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2014 03:53:01 EDT
Message-ID: <535CB615.7070504@rozsnyo.com>
Date: Sun, 27 Apr 2014 09:47:33 +0200
From: =?UTF-8?B?IkluZy4gRGFuaWVsIFJvenNuecOzIg==?= <daniel@rozsnyo.com>
Organization: REAS
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Provision for direct device to device DMA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are working on a product with PCIe based backplane (with PLX switch 
chips) to connect various high-bandwidth devices (namely an image sensor 
and multiple SSDs). The Linux system runs on a small (ARM based) 
processor, which has limited memory bandwidth (32bit/800MHz) and more 
importantly limited PCIe bandwidth (x1 root port). From linux sources, 
we could understand, that all DMA is towards or from system memory, 
which is the bottleneck in our use case (we peak at 2000MB/s).

What is the advised way of doing disk i/o with data coming from/to 
another PCIe device? We would prefer to keep a filesystem on the target 
drives, but it is not a hard requirement. The storage solution is AHCI 
(multiple ASM1061) and the other end are our FPGA devices. For future, 
it would be nice to stream over PCIe fabric into a 10GE nic, like i82599 
(ixgbe), from both the storage and from FPGA.

Do we need to write a kernel module to handle such transfers on a very 
low level (like a combined ahci-fpga-nic driver)?

Or a special mmap() before write() would auto-magically do the right job?


Thank you,
Daniel Rozsnyo


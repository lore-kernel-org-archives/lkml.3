Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaIJRsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:48:02 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34625 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIJRsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:48:00 -0400
Message-ID: <54108ECA.6090200@plexistor.com>
Date: Wed, 10 Sep 2014 20:47:54 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <openosd@gmail.com>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvdimm@ml01.01.org
Subject: Re: [Linux-nvdimm] [PATCH v2] pmem: Initial version of persistent
 memory driver
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>	<540F2977.7010006@plexistor.com>	<CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>	<541050E5.60502@gmail.com> <CAPcyv4hfNX4Q75AERfF4g5MVvG82j3tXWcunWiGpBgDS2+7_1Q@mail.gmail.com>
In-Reply-To: <CAPcyv4hfNX4Q75AERfF4g5MVvG82j3tXWcunWiGpBgDS2+7_1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 08:03 PM, Dan Williams wrote:
> Hi Boaz,
> 
<>
>> We please need to start somewhere, no?
> 
> Sure, but you used the operative term "start", as in you already
> expect to enhance this capability down the road, right?
> 

Yes

> It's fine to dismiss this request_firmware() based approach, but don't
> mis-characterize it in the process.  With regards to describing device
> boundaries, a bus-descriptor-blob handed to the kernel is a superset
> of the capability provided by the kernel command line.  It can be
> injected statically at compile time, or dynamically loaded from the
> initrd or the rootfs.  It has the added benefit of being flexible to
> change whereas the kernel command line is a more permanent contract
> that we will need to maintain compatibility with in perpetuity.
> 

initrd or rootfs means for me "make install". But I want my fedora
to never make or install. Pre-compiled binary blobs including rootfs and
it needs to work.

> If you already see this bus description as a "starting" point, then I
> think we need an interface that is more amenable to ongoing change,
> that's not the kernel-command-line.
> 

module-command-line. a module can be loaded via udev and/or module param
can be changed dynamically on the fly. And also be specified via
kernel-command-line. So it is much less permanent contract API than
"rootfs"

And yes, I intend to add more interfaces. And No! I do not intend to
ever extend this module-param interface, that I can see. This one is
that, which it is right now. Later a sysfs/ objects will enable dynamic
management of devices. So both: initial device list on load - more devices
or removal on the fly, unload all on unload. This is my plan. So right
now I do not see this map= need ever change in the future. Only more
interfaces added in (the very near) future.

Thanks
Boaz


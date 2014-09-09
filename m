Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbaIIQxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:53:55 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:52021 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaIIQxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:53:53 -0400
MIME-Version: 1.0
In-Reply-To: <540F2977.7010006@plexistor.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
	<540F2977.7010006@plexistor.com>
Date: Tue, 9 Sep 2014 09:53:52 -0700
Message-ID: <CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2] pmem: Initial version of persistent
 memory driver
From: Dan Williams <dan.j.williams@intel.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvdimm@ml01.01.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 9:23 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> From: Ross Zwisler <ross.zwisler@linux.intel.com>
>
> PMEM is a new driver that presents a reserved range of memory as a
> block device.  This is useful for developing with NV-DIMMs, and
> can be used with volatile memory as a development platform.
>
> [boaz]
> SQUASHME: pmem: Remove unused #include headers
> SQUASHME: pmem: Request from fdisk 4k alignment
> SQUASHME: pmem: Let each device manage private memory region
> SQUASHME: pmem: Support of multiple memory regions
>
> The API to pmem module a single string parameter named "map"
> of the form:
>                  map=mapS[,mapS...]
>
>                  where mapS=nn[KMG]$ss[KMG],
>                  or    mapS=nn[KMG]@ss[KMG],
>
>                  nn=size, ss=offset
>
> Just like the Kernel command line map && memmap parameters,
> so anything you did at grub just copy/paste to here.
>
> The "@" form is exactly the same as the "$" form only that
> at bash prompt we need to escape the "$" with \$ so also
> support the '@' char for convenience.

Hmm this looks like a "ACPI/DeviceTree-over-kernel-command-line"
description language.  I understand that this is borrowed from the
memmap= precedent, but, if I'm not mistaken, that's really more for
debug rather than a permanent platform-device descriptor.  <strawman>
Since this looks like firmware why not go ahead and use
request_firmware() to request a pmem range descriptor blob</strawman>?
 Given you can compile such a blob into a kernel image  or provide it
in an initrd I think it makes deployment more straightforward, also
the descriptor format can be extended going forward whereas the
command line approach mandates ever increasingly complicated strings.

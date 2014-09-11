Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbaIKQbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:31:19 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:58101 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbaIKQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:31:15 -0400
MIME-Version: 1.0
In-Reply-To: <54117D3A.3010305@plexistor.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
	<540F2977.7010006@plexistor.com>
	<CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>
	<541050E5.60502@gmail.com>
	<CAPcyv4hfNX4Q75AERfF4g5MVvG82j3tXWcunWiGpBgDS2+7_1Q@mail.gmail.com>
	<54108ECA.6090200@plexistor.com>
	<CAPcyv4gqyiTaSJY56ZrJh05kwh9O9sXNKOz40fGu5s_=eY=U6Q@mail.gmail.com>
	<54117D3A.3010305@plexistor.com>
Date: Thu, 11 Sep 2014 09:31:14 -0700
Message-ID: <CAPcyv4io2P1TiXdnhQJMiWsYE5Rz+BiiAHqKZhDe5gh88PEWUA@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2] pmem: Initial version of persistent
 memory driver
From: Dan Williams <dan.j.williams@intel.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Boaz Harrosh <openosd@gmail.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvdimm@ml01.01.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 3:45 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> On 09/11/2014 02:01 AM, Dan Williams wrote:
> <>
>>
>> Imagine you want to deploy a policy like "use half of the memory
>> provided by the dimm in slot3, i.e. the only one with a battery".
>> That sort of thing gets unwieldy in a command line string compared to
>> a description table format that we can update at will.
>>
>
> Actually it is easy to do, why? I do this here in the lab all the time.
> with a "command line" with this code you see here.
>
> [DDR3 NvDIMM which means I need memmap=16G\$32G on Kernel command line.
>  Then: modprobe pmem map=8G@32G,4G@44G,...
>  and so on Just as a simple example where 2/4-3/4 addresses are not used.
>  You can have holes in the middle or what ever you want. This here is just
>  a table in comma-separated format. If we need like flags in future we can
>  extend the format to nn@ss:flags, but I do no have any 3rd column yet]

The point I am getting at is not requiring a priori knowledge of the
physical memory map of a system.  Rather, place holder variables to
enable simple dynamic discovery.

> And again I have in the pipe a dynamic interface added on top of
> the module param one. So it will all be there soon. Without reverting
> the old one.

Why start on step 2 when we haven't got agreement on step 1?

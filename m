Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbaISQ1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 12:27:38 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37127 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbaISQ1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 12:27:37 -0400
MIME-Version: 1.0
In-Reply-To: <x497g133c2x.fsf@segfault.boston.devel.redhat.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
	<540F2977.7010006@plexistor.com>
	<CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>
	<541050E5.60502@gmail.com>
	<CAPcyv4hfNX4Q75AERfF4g5MVvG82j3tXWcunWiGpBgDS2+7_1Q@mail.gmail.com>
	<54108ECA.6090200@plexistor.com>
	<CAPcyv4gqyiTaSJY56ZrJh05kwh9O9sXNKOz40fGu5s_=eY=U6Q@mail.gmail.com>
	<54117D3A.3010305@plexistor.com>
	<CAPcyv4io2P1TiXdnhQJMiWsYE5Rz+BiiAHqKZhDe5gh88PEWUA@mail.gmail.com>
	<5415797A.7000700@plexistor.com>
	<x497g133c2x.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 19 Sep 2014 09:27:36 -0700
Message-ID: <CAPcyv4hb_qpJbCg6n0m0d87=Gi10kw3P3Rx6tHCOTNYffHa_fw@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2] pmem: Initial version of persistent
 memory driver
From: Dan Williams <dan.j.williams@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <boaz@plexistor.com>
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

On Tue, Sep 16, 2014 at 6:54 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Boaz Harrosh <boaz@plexistor.com> writes:
>
>> On 09/11/2014 07:31 PM, Dan Williams wrote:
>> <>
>>>
>>> The point I am getting at is not requiring a priori knowledge of the
>>> physical memory map of a system.  Rather, place holder variables to
>>> enable simple dynamic discovery.
>>>
>>
>> "simple dynamic discovery" does not yet exist and when the DDR4 NvDIMM
>> will be released then we still have those DDR3 out there which will
>> not work with the new discovery, which I need to support as well.
>
> Boaz,
>
> Are you telling me that vendors are shipping parts that present
> themselves as E820_RAM, and that you have to manually block off the
> addresses from the kernel using the kernel command line?  If that is
> true, then that is just insane and unsupportable.  All the hardware I
> have access to:
> 1) does not present itself as normal memory and
> 2) provides some means for discovering its address and size

Jeff,

Yes, agree.

Boaz,

The UEFI organization is in the process of defining a generic
specification for platform non-volatile memory resources.  Let's wait
until that is publicly available before adding any new device
discovery capabilities to pmem.

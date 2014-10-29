Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbaJ2VID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:08:03 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:33080 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbaJ2VH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <x49bnoupulp.fsf@segfault.boston.devel.redhat.com>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
	<20141029182345.4879.98373.stgit@stg-AndroidDev-VirtualBox>
	<x49bnoupulp.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 29 Oct 2014 14:07:58 -0700
Message-ID: <CAPcyv4hgeoGJMG3aAb4auQj+bwnv4J__AkC_MvRHWdNP9gOGPg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] block, ioprio: include caching advice via ionice
From: Dan Williams <dan.j.williams@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Jason B. Akers" <jason.b.akers@intel.com>,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>, axboe@fb.com,
        "Karkra, Kapil" <kapil.karkra@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 12:02 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> "Jason B. Akers" <jason.b.akers@intel.com> writes:
>
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Steal one unused bit from the priority class and two bits from the
>> priority data, to implement a 3 bit cache-advice field.  Similar to the
>> page cache advice from fadvise() these hints are meant to be consumed
>> by hybrid drives.  Solid State Hyrbid-Drives, as defined by the SATA-IO
>> Specification, implement up to a 4-bit cache priority that can be
>> specified along with a FPDMA command.
>
> ionice is about setting an I/O scheduling class for a *process*.  So,
> unless I've missed something, this does not seem like the right
> interface for passing I/O hints.
>
> You mention fadvise hints, which sounds like a good fit (and madvise
> would be equally interesting), but I don't see where you've wired them
> up in this patch set.  Did I miss it?

It turns out we didn't need it.  It's straightforward to add, but I
think "80%" of the benefit can be had by just having a per-thread
cache priority.  It's more powerful to say "any page cache page this
thread touches, or any direct i/o this thread does, goes down the
stack at the given priority".

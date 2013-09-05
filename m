Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3IERT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:19:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab3IERT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:19:28 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: rob.gittins@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@veger.org,
        linux-pmfs@lists.infradead.org
Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
	<x49y57ba2ne.fsf@segfault.boston.devel.redhat.com>
	<1378398821.3768.116.camel@Virt-Centos-6.lm.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 05 Sep 2013 13:19:02 -0400
In-Reply-To: <1378398821.3768.116.camel@Virt-Centos-6.lm.intel.com> (Rob
	Gittins's message of "Thu, 05 Sep 2013 10:33:41 -0600")
Message-ID: <x49vc2f89vd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Gittins <rob.gittins@linux.intel.com> writes:

>> >    void (*commitpmem)(struct block_device *bdev, void *addr);
>> 
>> Seems like this would benefit from a length argument as well, no?
>
> Yes.  Great point.  I will add that in.

Rob, taking it a step further, maybe a vectored interface would be more
flexible.  Something to consider, anyway.

>> > Another area requiring extension is the need to be able to clear PMEM
>> > errors.  When data is fetched from errored PMEM it is marked with the
>> > poison attribute.  If the CPU attempts to access the data it causes a
>> > machine check.  How errors are cleared is hardware dependent and needs
>> > to be handled by the specific device driver.  The following function
>> > in the block_device_operations vector would clear the correct range
>> > of PMEM and put new data there.  If the argument data is null or the
>> > size is zero the driver is free to put any data in PMEM it wishes.
>> >
>> > 	void (*clearerrorpmem)(struct block_device *bdev, void *addr,
>> > 			size_t len, void *data);
>
>> What is the size of data?
>
> clearerrorpmem as part of the process of clearing an error 
> can effectively write a buffer of data as part of the
> clear process.  If the len is zero or the data pointer is null then
> only a error clear happens.    

So data would be of 'len' size, then?  In other words, this would be a
way to restore data that may have been there?

> The existing partitioning mechanism was intended for small drives
> and works best for a single fs/device.  We are approaching NV-DIMMs
> as if they were more like LUNs in storage arrays.  Each range is 
> treated as a device.  A range of an NV-DIMM could be partitioned if
> someone wanted to do such a thing.

OK, that clears things up, thanks.

-Jeff

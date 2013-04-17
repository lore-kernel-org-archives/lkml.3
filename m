Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3DQFTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 01:19:41 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45330 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3DQFTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 01:19:40 -0400
Message-ID: <516E30DC.5070601@linux.vnet.ibm.com>
Date: Wed, 17 Apr 2013 10:49:24 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jkenisto@linux.vnet.ibm.com,
        mahesh@linux.vnet.ibm.com, anton@samba.org
Subject: Re: [PATCH 4/8] Read/Write oops nvram partition via pstore
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420> <20130410072303.20150.61382.stgit@aruna-ThinkPad-T420> <20130415075555.GE30156@concordia> <516CEDB4.9090005@linux.vnet.ibm.com>
In-Reply-To: <516CEDB4.9090005@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041705-0260-0000-0000-000002D22642
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 April 2013 11:50 AM, Aruna Balakrishnaiah wrote:
>
> Currently with this patchset, pstore is not supporting compression of 
> oops-messages
> since it involves some changes in the pstore framework.
>
> big_oops_buf will hold the large part of oops data which will be compressed 
> and put
> to oops_buf.
>
> big_oops_buf: (1.45 of oops_partition_size)

Sorry, big_oops_buf is (2.22 of oops_data_sz)

where oops_data_sz is oops_partition_size - sizeof(oops_log_info).

where oops_log_info is oops header.

> _________________________
> |  header |   oops-text |
> |_________|_____________|
>
> <header> is added by the pstore.
>
> So in case compression fails:
>
> we would need to log the header + last few bytes of big_oops_buf to oops_buf.
> oops_buf: (this is of oops_partition_size)
>

We would need to log the header + last oops_data_sz bytes of big_oops_buf to 
oops_buf.
So that we can have the header while throwing away the data that immediately
follows it.

> we need last few bytes of big_oops_buf as we need to log the recent messages of
> printk buffer. For which we need to know the header size and it involves some
> changes in the pstore framework.
>

Just communicating the header size from pstore would do the job for us.

> I have the compression patches ready, will be posting it soon as a separate set.
>
>> cheers
>>
>


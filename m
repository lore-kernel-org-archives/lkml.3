Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaCYMJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:09:30 -0400
Received: from mfow510.mose-mail.jp ([203.180.220.223]:34146 "EHLO
	mfow.mose-mail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaCYMJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:09:28 -0400
X-Greylist: delayed 1822 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2014 08:09:28 EDT
Message-ID: <53316AC2.2050304@labs.cybozu.co.jp>
Date: Tue, 25 Mar 2014 20:38:42 +0900
From: Takashi HOSHINO <hoshino@labs.cybozu.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matias Bjorling <m@bjorling.me>, Bart Van Assche <bvanassche@acm.org>,
        device-mapper development <dm-devel@redhat.com>
CC: snitzer@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for
 open firmware SSDs
References: <1395383538-18019-1-git-send-email-m@bjorling.me>	<1395383538-18019-2-git-send-email-m@bjorling.me> <20140321153749.GA17155@infradead.org> <532FCCFB.7010007@acm.org> <5330F84C.8090803@bjorling.me>
In-Reply-To: <5330F84C.8090803@bjorling.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matias,

(2014/03/25 12:30), Matias Bjorling wrote:
> On 03/23/2014 11:13 PM, Bart Van Assche wrote:
>> On 03/21/14 16:37, Christoph Hellwig wrote:
>>> Just curious:  why do you think implementing this as a block remapper
>>> inside device mapper is a better idea than as a blk-mq driver?
>>>
>>> At the request layer you already get a lot of infrastructure for all the
>>> queueing infrastructure for free, as well as all kinds of other helpers.
>>> And the driver never remaps bios anyway but always submits new ones as
>>> far as I can tell.
>>>
>>> Does it even make sense to expose the underlying devices as block
>>> devices?  It surely would help to send this together with a driver
>>> that you plan to use it on top of.
>>
>> There might be some overlap between the functionality available in the
>> lightnvm driver and the WalB driver announced last year. That last
>> driver might have a wider user base and hence may have received more
>> testing. See also http://thread.gmane.org/gmane.linux.file-systems/75124.
>>
>
> Hi Bart,
>
> Thanks! There seems to be a little bit that can be reused. It does seem
> from the github page that there haven't been any development since its
> been posted. Maybe the development is moved elsewhere?

I'm one of WalB developers and the github site is currently official.
The latest code seems work with Linux kernel 3.13 but the code does not 
support the latest block-layer features like blk-mq.
Its code is currently a bit legacy... I will rework with it but I'm 
developing related userland tools and having no time for kernel code.

WalB is being developed for incremental backup and asynchrounous 
replication with legacy block devices. Its code will not be used for 
dm-lightnvm directly but its algorithm may be useful for some purposes 
because it is similar to FTL.

It must be nice if dm-lightnvm software will have incremental backup and 
replication functionality with FTL management.

>> Bart.
>>
>
>

Takashi

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab3IMABK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:01:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3IMABG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:01:06 -0400
Message-ID: <523255BB.7050109@redhat.com>
Date: Thu, 12 Sep 2013 20:00:59 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matt Wilson <msw@amazon.com>
CC: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] hpet, allow user controlled mmap for user processes
References: <51487B59.6010607@ladisch.de> <1363959174-28999-1-git-send-email-prarit@redhat.com> <20130829060151.GA7439@u109add4315675089e695.ant.amazon.com>
In-Reply-To: <20130829060151.GA7439@u109add4315675089e695.ant.amazon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/29/2013 02:01 AM, Matt Wilson wrote:
> On Fri, Mar 22, 2013 at 09:32:54AM -0400, Prarit Bhargava wrote:
>> The CONFIG_HPET_MMAP Kconfig option exposes the memory map of the HPET
>> registers to userspace.  The Kconfig help points out that in some cases this
>> can be a security risk as some systems may erroneously configure the map such
>> that additional data is exposed to userspace.
>>
>> This is a problem for distributions -- some users want the MMAP functionality
>> but it comes with a significant security risk.  In an effort to mitigate this
>> risk, and due to the low number of users of the MMAP functionality, I've
>> introduced a kernel parameter, hpet_mmap_enable, that is required in order
>> to actually have the HPET MMAP exposed.
>>
>> [v2]: Clemens suggested modifying the Kconfig help text and making the
>> default setting configurable.
>> [v3]: Fixed up Documentation and Kconfig entries, default now "Y"
>> [v4]: After testing, found that I need to modify CONFIG_HPET_MMAP_DEFAULT usage
>>
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>> Cc: Clemens Ladisch <clemens@ladisch.de>
>> ---
>>  Documentation/kernel-parameters.txt |    4 ++++
>>  drivers/char/Kconfig                |    9 +++++++--
>>  drivers/char/hpet.c                 |   25 +++++++++++++++++++++++--
>>  3 files changed, 34 insertions(+), 4 deletions(-)
> 
> It doesn't seem like this patch got picked up and seems like a good
> idea to me. Clemens, what do you think?
> 
> Acked-by: Matt Wilson <msw@amazon.com>
> 

Clemens?  I didn't see a reply...

P.

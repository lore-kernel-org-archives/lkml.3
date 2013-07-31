Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab3GaJvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:51:41 -0400
Received: from relay.parallels.com ([195.214.232.42]:38665 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab3GaJvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:51:38 -0400
Message-ID: <51F8DE28.4000508@parallels.com>
Date: Wed, 31 Jul 2013 13:51:36 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Kleikamp <dave.kleikamp@oracle.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com> <20130730142820.313f1af6827276df31913106@linux-foundation.org>
In-Reply-To: <20130730142820.313f1af6827276df31913106@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07/31/2013 01:28 AM, Andrew Morton пишет:
> On Thu, 25 Jul 2013 12:50:26 -0500 Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
>
>> This patch series adds a kernel interface to fs/aio.c so that kernel code can
>> issue concurrent asynchronous IO to file systems.  It adds an aio command and
>> file system methods which specify io memory with pages instead of userspace
>> addresses.
>>
>> This series was written to reduce the current overhead loop imposes by
>> performing synchronus buffered file system IO from a kernel thread.  These
>> patches turn loop into a light weight layer that translates bios into iocbs.
> Do you have any performance numbers?
>
> Does anyone care much about loop performance?  What's the value here?
>
>

OpenVZ uses loopback-device to keep per-container filesystems. We care 
much about overhead introduced by loop: IO-bound applications run on top 
of per-container filesystem shouldn't perform worse than on top of host 
filesystem. So the value for us is zero overhead.

Thanks,
Maxim

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaHGLON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:14:13 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:52089 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbaHGLOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:14:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140806214216.GA16530@kroah.com>
References: <87k36ltoob.fsf@gmail.com> <20140806214216.GA16530@kroah.com>
From: Evgeny Budilovsky <budevg@gmail.com>
Date: Thu, 7 Aug 2014 14:13:50 +0300
Message-ID: <CAGDhxoe4+jU=vCDedMC4VXfuNMmqP3-E1Lu3LLStbFLbd=BRSA@mail.gmail.com>
Subject: Re: [PATCH] staging/lustre: use rcu_dereference to access rcu
 protected current->real_parent field
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <green@linuxhacker.ru>, Peng Tao <bergwolf@gmail.com>,
        Lai Siyao <lai.siyao@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 12:42 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Aug 06, 2014 at 09:22:43PM +0300, Evgeny Budilovsky wrote:
>>
>>
>> Signed-off-by: Evgeny Budilovsky <budevg@gmail.com>
>
> Why is this needed?  Is the current code a bug?  Where was the reference
> added?  Is this causing a problem without this patch applied?  How far
> back should it be backported, if at all?
>
> I need lots more details here before I can take this patch, sorry.

Sorry for the little information in the previous mail.

The motivation for this patch was to clean some of the warnings that
were generated
on drivers/staging by the sparse utility.

For this particular case the warning was
staging/lustre/lustre/llite/lproc_llite.c:913:51: warning: dereference
of noderef expression

And this is since current->real_parent is accessed directly and not
trough the rcu_dereference,
which is the common way to access it throughout the kernel.

This is not a critical bug and in the worst case the code here may
cause miss of statistics counter increase.
This is why I think it is not worth to backport the patch at all.

>
> greg k-h



-- 
Best Regards,
Evgeny

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaEAPxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:53:45 -0400
Received: from mout.gmx.net ([212.227.15.18]:56048 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbaEAPxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:53:43 -0400
Message-ID: <53626DFC.6050200@gmx.de>
Date: Thu, 01 May 2014 17:53:32 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Fwd: Re: [PATCH 1/1] fanotify: for FAN_MARK_FLUSH check flags
References: <1398290151-6502-1-git-send-email-xypron.glpk@gmx.de> <20140424100300.GL17824@quack.suse.cz>
In-Reply-To: <20140424100300.GL17824@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:E71VCDTQ8VaXBkotSsvXAgVMvSOMbhI5n8UdyAmCmIZKUjd9gqi
 F3ouZDpT434yX9zL+IvLY0RFcvKqZLhMY+QSOAFN5XKtt2NbKLCrIeQBBEC7cMEt4MTYJHN
 hD4QN6z1gXiRy4C5LdtxLAyNTeW5jhwQU83o0cifrRTmR3qlAauwGATL07eQcxlGGTHNIDO
 5vlT3nXBz1yJ2yJaicoFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

the patch below was
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
https://lkml.org/lkml/2014/4/24/23
Acked-by: Jan Kara <jack@suse.cz>
https://lkml.org/lkml/2014/4/24/1048

Please, consider it for inclusion in the mm tree.

Best regards

Heinrich Schuchardt


On 24.04.2014 12:03, Jan Kara wrote:
> On Wed 23-04-14 23:55:51, Heinrich Schuchardt wrote:
>> If fanotify_mark is called with illegal value of arguments flags and marks
>> it usually returns EINVAL.
>>
>> When fanotify_mark is called with FAN_MARK_FLUSH the argument flags is not
>> checked for irrelevant flags like FAN_MARK_IGNORED_MASK.
>>
>> The patch removes this inconsistency.
>>
>> If an irrelevant flag is set error EINVAL is returned.
>    OK, as Michael I think this shouldn't cause real userspace breakage and
> it's better to have the flags checked. So feel free to add:
> Acked-by: Jan Kara <jack@suse.cz>
>
> 							Honza
>
>>
>> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
>> ---
>>   fs/notify/fanotify/fanotify_user.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
>> index 287a22c..8bba549 100644
>> --- a/fs/notify/fanotify/fanotify_user.c
>> +++ b/fs/notify/fanotify/fanotify_user.c
>> @@ -819,7 +819,10 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
>>   	case FAN_MARK_REMOVE:
>>   		if (!mask)
>>   			return -EINVAL;
>> +		break;
>>   	case FAN_MARK_FLUSH:
>> +		if (flags & ~(FAN_MARK_MOUNT | FAN_MARK_FLUSH))
>> +			return -EINVAL;
>>   		break;
>>   	default:
>>   		return -EINVAL;
>> --
>> 1.9.2
>>


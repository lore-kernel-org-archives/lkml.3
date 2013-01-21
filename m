Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3AUK1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:27:55 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:36683 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3AUK1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:27:53 -0500
MIME-Version: 1.0
In-Reply-To: <1358760001.8234.150.camel@kjgkr>
References: <20130120150258.GB32551@elgon.mountain>
	<20130121083245.GA11592@core.coreip.homeip.net>
	<1358760001.8234.150.camel@kjgkr>
Date: Mon, 21 Jan 2013 19:27:52 +0900
Message-ID: <CAKYAXd-H0KHMavYRk3PEshXNtN_ke5rH_qa-8XTT6RWZXYmFcw@mail.gmail.com>
Subject: Re: [patch] f2fs: use _safe() version of list_for_each
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/21, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-01-21 (월), 00:32 -0800, Dmitry Torokhov:
>> On Sun, Jan 20, 2013 at 06:02:58PM +0300, Dan Carpenter wrote:
>> > This is calling list_del() inside a loop which is a problem when we try
>> > move to the next item on the list.  I've converted it to use the _safe
>> > version.  And also, as a cleanup, I've converted it to use
>> > list_for_each_entry instead of list_for_each.
>> >
>> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> > ---
>> > Static analysis stuff.  Untested.  Please review carefully.
>>
>> Makes sense to me.
>>
>> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>>
>
> No doubt, applied.
> Thanks,
I agree in cases – where we will have chances of parallel access and
modification to the linked we should use list_for_each_entry_safe()
But my point was related with this code change case in the patch.
We will have path like this:
f2fs_fill_super->recover_fsync_data->destroy_fsync_dnodes()
>From this calling path – there can only be a single caller at any
given time. So, we will not have the case of having parallel access to
the list which is local to recover_fsync_data() and destroyed on exit
from this function.
>From the real issue point of view – this does not looks convincing to
me why expensive _safe fucntion should used.

Thanks.
>
> --
> Jaegeuk Kim
> Samsung
>

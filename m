Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbaIDU6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:58:39 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:40138 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaIDU6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:58:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140830204246.GA16563@kroah.com>
References: <20140817114336.GA24984@ada>
	<20140830204246.GA16563@kroah.com>
Date: Thu, 4 Sep 2014 23:58:36 +0300
Message-ID: <CALDM6bpomcGJk1Ut2hb8qO0gYeKkHruJZ0duBwAaonFf6HbZwA@mail.gmail.com>
Subject: Re: [PATCH] rtl8188eu: Replace rcu_dereference() with rcu_access_pointer()
From: Andreea Bernat <bernat.ada@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Larry.Finger@lwfinger.net, Elena Oat <oat.elena@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I cloned this:
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

and after moved to staging-next branch, but in both cases, in
those files I don't find any use of rcu_dereference() call (the call
which I am looking for to modify).

Thank you,
Andreea

2014-08-30 23:42 GMT+03:00 Greg KH <gregkh@linuxfoundation.org>:
> On Sun, Aug 17, 2014 at 02:43:37PM +0300, Andreea-Cristina Bernat wrote:
>> The "rcu_dereference()" call is used directly in a condition.
>> Since its return value is never dereferenced it is recommended to use
>> "rcu_access_pointer()" instead of "rcu_dereference()".
>> Therefore, this patch makes the replacement.
>>
>> The following Coccinelle semantic patch was used:
>> @@
>> @@
>>
>> (
>>  if(
>>  (<+...
>> - rcu_dereference
>> + rcu_access_pointer
>>   (...)
>>   ...+>)) {...}
>> |
>>  while(
>>  (<+...
>> - rcu_dereference
>> + rcu_access_pointer
>>   (...)
>>   ...+>)) {...}
>> )
>>
>> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
>> ---
>>  drivers/staging/rtl8188eu/core/rtw_mlme.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> This patch fails to apply to my tree, can you refresh it against the
> staging-next branch of the staging.git tree on kernel.org and resend?
>
> thanks,
>
> greg k-h

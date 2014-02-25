Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBYBHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:07:15 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:38171 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaBYBHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:07:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140225004357.GA28255@kroah.com>
References: <6036697.Bsd6uoTeJ1@daeseok-laptop.cloud.net>
	<20140225004357.GA28255@kroah.com>
Date: Tue, 25 Feb 2014 10:00:48 +0900
Message-ID: <CAHb8M2AigGWHvA4enc=JKbhvts6G-JT-9E0SPcvyeTWBZRnfKg@mail.gmail.com>
Subject: Re: [PATCH v2] staging: ced401: fix double unlock bug
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>, paul.gortmaker@windriver.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Elena Ufimtseva <ufimtseva@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok.

I will make a patch based on linux-next branch and send it again.
Thanks.

Daeseok Youn

2014-02-25 9:43 GMT+09:00 Greg KH <gregkh@linuxfoundation.org>:
> On Mon, Feb 24, 2014 at 07:23:15PM +0900, Daeseok Youn wrote:
>>
>> After spin_lock() is called, all of if-else conditions in this brace
>> should reach the end of else and spin_unlock() must be called.
>> So It doesn't need to call spin_unlock() without a return statement
>> for handling an error.
>>
>> Also sparse says:
>> drivers/staging/ced1401/usb1401.c:1080:28: warning:
>>  context imbalance in 'Handle1401Esc' - unexpected unlock
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>
> This patch doesn't apply to my tree, can you please redo it against
> linux-next and resend it so that I can apply it?
>
> thanks,
>
> greg k-h

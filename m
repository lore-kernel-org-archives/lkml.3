Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbaJIPbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:31:09 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:50108 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaJIPbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <20141008224414.GA25262@kroah.com>
References: <20141002084745.GF23154@mwanda>
	<1412253146-3568-1-git-send-email-nitinkuppelur@gmail.com>
	<20141008224414.GA25262@kroah.com>
Date: Thu, 9 Oct 2014 21:00:58 +0530
Message-ID: <CAJTjWg8QuvrdwD9rrHYW25LbJ6aq7ttyih1sxGkZEvtoBA8Ntg@mail.gmail.com>
Subject: Re: [PATCH V3] Staging: rtl8712 removed unnecessary else after return
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Sorry for noob question. I am still new to Kernel development.

I understood from your comment that the patch did not apply cleanly to
your tree (may be due to change in the code which I have modified)

But what should I do after this?
1) Send patch on rebased file to same mail chain with (--in-reply-to)
and [PATCH V4] ? OR
2) Create new PATCH and start new mail chain done on latest code.

Regards,
Nitin

On Thu, Oct 9, 2014 at 4:14 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Oct 02, 2014 at 02:32:26PM +0200, Nitin Kuppelur wrote:
>> Removed unnecessary else after return to solve
>> checkpatch.pl warning
>>
>> Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
>> ---
>>  drivers/staging/rtl8712/hal_init.c | 7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
>> index 81cd654..fbaba11 100644
>> --- a/drivers/staging/rtl8712/hal_init.c
>> +++ b/drivers/staging/rtl8712/hal_init.c
>> @@ -387,12 +387,9 @@ uint rtl8712_hal_deinit(struct _adapter *padapter)
>>  uint rtl871x_hal_init(struct _adapter *padapter)
>>  {
>>       padapter->hw_init_completed = false;
>> -     if (padapter->halpriv.hal_bus_init == NULL)
>> +     if (padapter->halpriv.hal_bus_init == NULL ||
>> +         padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
>>               return _FAIL;
>> -     else {
>> -             if (padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
>> -                     return _FAIL;
>> -     }
>>       if (rtl8712_hal_init(padapter) == _SUCCESS)
>>               padapter->hw_init_completed = true;
>>       else {
>
> This doesn't apply to my tree :(

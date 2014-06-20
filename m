Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbaFTJRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:17:13 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:40952 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaFTJRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:17:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140620090937.GS5500@mwanda>
References: <20140620051958.GA17076@devel.8.8.4.4>
	<20140620090937.GS5500@mwanda>
Date: Fri, 20 Jun 2014 18:17:11 +0900
Message-ID: <CAHb8M2C4mAoPnx4ZiQLU2BqxuhKDcS0s=dmp8tO_tkbYGieoJg@mail.gmail.com>
Subject: Re: [PATCH] staging: dgap: make dgap_found_board() return a brd pointer
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan.

2014-06-20 18:09 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Fri, Jun 20, 2014 at 02:19:58PM +0900, Daeseok Youn wrote:
>> -     rc = dgap_found_board(pdev, ent->driver_data, dgap_numboards);
>> -     if (rc)
>> +     brd = dgap_found_board(pdev, ent->driver_data, dgap_numboards);
>> +     if (IS_ERR(brd))
>>               return rc;
>
>                 return ERR_PTR(brd);
ok.. you mean PTR_ERR(brd), right?
I will send it again after changing from rc to "PTR_ERR(brd)"

>
>
>>
>> -     brd = dgap_board[dgap_numboards++];
>>       rc = dgap_firmware_load(pdev, ent->driver_data, brd);
>>       if (rc)
>>               goto cleanup_brd;
>> @@ -617,6 +617,8 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>       brd->state = BOARD_READY;
>>       brd->dpastatus = BD_RUNNING;
>>
>> +     dgap_board[dgap_numboards++] = brd;
>
> You need to update the error handling of this function to remove the
> reference do dgap_board[] as well.
Yes, It need to update code in cleanup_brd label.

Thanks
regards,
Daeseok Youn
>
>> +
>>       return 0;
>>
>
> regards,
> dan carpenter
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaJMUih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:38:37 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:37657 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJMUif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:38:35 -0400
MIME-Version: 1.0
In-Reply-To: <543B97FA.8050207@mev.co.uk>
References: <1413116604-18554-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <543B97FA.8050207@mev.co.uk>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 13 Oct 2014 22:38:14 +0200
Message-ID: <CAFo99gav65WUeME3=x-7mTHGD4tKh8Qj_h2pFCbc3ON-Mr4yfg@mail.gmail.com>
Subject: Re: [PATCH] staging: comedi: drivers: comedi_bond.c: Changed from
 using strncat to strlcat
To: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@yahoo.com>,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-13 11:14 GMT+02:00 Ian Abbott <abbotti@mev.co.uk>:
> On 12/10/14 13:23, Rickard Strandqvist wrote:
>>
>> Changed from using strncat to strlcat to simplify the code
>>
>> Signed-off-by: Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se>
>> ---
>>   drivers/staging/comedi/drivers/comedi_bond.c |    6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/comedi_bond.c
>> b/drivers/staging/comedi/drivers/comedi_bond.c
>> index 8450c99..5d19861 100644
>> --- a/drivers/staging/comedi/drivers/comedi_bond.c
>> +++ b/drivers/staging/comedi/drivers/comedi_bond.c
>> @@ -262,12 +262,10 @@ static int do_dev_config(struct comedi_device *dev,
>> struct comedi_devconfig *it)
>>                         {
>>                                 /* Append dev:subdev to devpriv->name */
>>                                 char buf[20];
>> -                               int left =
>> -                                   MAX_BOARD_NAME - strlen(devpriv->name)
>> - 1;
>>                                 snprintf(buf, sizeof(buf), "%u:%u ",
>>                                          bdev->minor, bdev->subdev);
>> -                               buf[sizeof(buf) - 1] = 0;
>> -                               strncat(devpriv->name, buf, left);
>> +                               strlcat(devpriv->name, buf,
>> +                                       sizeof(devpriv->name));
>>                         }
>>
>>                 }
>>
>
> Looks good.  Additionally, the #define MAX_BOARD_NAME could be eliminated as
> now it is only used to to set the length of the 'name' member in 'struct
> comedi_bond_private'.
>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>


Hi

Sounds like a good idea Ian.
I'll send a new patch where I removed the MAX_BOARD_NAME  tomorrow.


Kind regards
Rickard Strandqvist

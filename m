Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaGHGW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:22:29 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:56642 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaGHGW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:22:27 -0400
MIME-Version: 1.0
In-Reply-To: <53BB53BE.3040208@realsil.com.cn>
References: <1404717004-29540-1-git-send-email-fabio.falzoi84@gmail.com>
	<1404717004-29540-5-git-send-email-fabio.falzoi84@gmail.com>
	<53BB53BE.3040208@realsil.com.cn>
Date: Tue, 8 Jul 2014 08:22:27 +0200
Message-ID: <CACar8LmgpTwxXrb0nJNT-FRs8A+jJ9P5cuTnyOS=t=vfs3t3Uw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] Staging: rts5208: Fix a format specifier for dev_err
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: micky <micky_ching@realsil.com.cn>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        wei_wang@realsil.com.cn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Micky,

in the latest linux-tree sources, lun field in struct scsi_device from
include/scsi/scsi_device.h is a u64:

        unsigned int id, channel;
        u64 lun;
        unsigned int manufacturer;

so we get a compiler warning if we keep the %u specifier.

Regards,
Fabio

On Tue, Jul 8, 2014 at 4:13 AM, micky <micky_ching@realsil.com.cn> wrote:
> On 07/07/2014 03:10 PM, Fabio Falzoi wrote:
>>
>> Fix an incorrect use of the %d format specifier in dev_err that caused a
>> warning.
>>
>> Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
>> ---
>>   drivers/staging/rts5208/rtsx.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/rts5208/rtsx.c
>> b/drivers/staging/rts5208/rtsx.c
>> index 4f5f7a3..9aae7ac 100644
>> --- a/drivers/staging/rts5208/rtsx.c
>> +++ b/drivers/staging/rts5208/rtsx.c
>> @@ -463,14 +463,14 @@ static int rtsx_control_thread(void *__dev)
>>                  * the maximum known LUN
>>                  */
>>                 else if (chip->srb->device->id) {
>> -                       dev_err(&dev->pci->dev, "Bad target number
>> (%d:%d)\n",
>> +                       dev_err(&dev->pci->dev, "Bad target number
>> (%d:%llu)\n",
>
> here exist some compile warning.
> drivers/staging/rts5208/rtsx.c:468:5: warning: format ‘%llu’ expects
> argument of type ‘long long unsigned int’, but argument 4 has type ‘unsigned
> int’ [-Wformat]
>
>
>>                                 chip->srb->device->id,
>>                                 chip->srb->device->lun);
>>                         chip->srb->result = DID_BAD_TARGET << 16;
>>                 }
>>                 else if (chip->srb->device->lun > chip->max_lun) {
>> -                       dev_err(&dev->pci->dev, "Bad LUN (%d:%d)\n",
>> +                       dev_err(&dev->pci->dev, "Bad LUN (%d:%llu)\n",
>>                                 chip->srb->device->id,
>>                                 chip->srb->device->lun);
>>                         chip->srb->result = DID_BAD_TARGET << 16;
>
>

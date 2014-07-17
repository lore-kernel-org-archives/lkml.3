Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbaGQM0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:26:30 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36420 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaGQM01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140610182719.GA28752@pd.tnic>
References: <1402341618-10674-1-git-send-email-fabf@skynet.be>
	<20140610182719.GA28752@pd.tnic>
Date: Thu, 17 Jul 2014 15:26:26 +0300
Message-ID: <CANZNk83PDVa56z9iomRbWQWoRCfrmzUpcMCTO1zUv5CtAOSaZQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers/edac/edac_module.c: remove unnecessary test
 on unsigned value
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Fabian Frederick <fabf@skynet.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-10 21:27 GMT+03:00 Borislav Petkov <bp@alien8.de>:
> On Mon, Jun 09, 2014 at 09:20:18PM +0200, Fabian Frederick wrote:
>> unsigned long value is never < 0
>>
>> Cc: Doug Thompson <dougthompson@xmission.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>> ---
>>  drivers/edac/edac_module.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
>> index a66941f..e6d1691 100644
>> --- a/drivers/edac/edac_module.c
>> +++ b/drivers/edac/edac_module.c
>> @@ -28,7 +28,7 @@ static int edac_set_debug_level(const char *buf, struct kernel_param *kp)
>>       if (ret)
>>               return ret;
>>
>> -     if (val < 0 || val > 4)
>> +     if (val > 4)
>>               return -EINVAL;
>
> Ok, so I don't know how you caught this but FWIW, we have those W= build
> switches which trigger it too (which is a good thing that we have them
> :-))
>
> $ make W=1 drivers/edac/edac_module.o
>
> ...
>
> drivers/edac/edac_module.c: In function 'edac_set_debug_level':
> drivers/edac/edac_module.c:31:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
>   if (val < 0 || val > 4)
>
> Applied, thanks.

This hasn't got into none of v3.16-rc5 release, repos "linux-stable"
and "torvalds/linux".
See https://bugzilla.kernel.org/show_bug.cgi?id=80431

-- 
Andrey Utkin

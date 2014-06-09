Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbaFILIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:08:34 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:62499 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaFILIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:08:30 -0400
MIME-Version: 1.0
X-Originating-IP: [112.161.134.227]
In-Reply-To: <20140608175823.GC5500@mwanda>
References: <1402236777-10914-1-git-send-email-yong@gnoy.org>
	<20140608175823.GC5500@mwanda>
Date: Mon, 9 Jun 2014 20:08:29 +0900
Message-ID: <CAH4bKb2AbEUdewSz1BMJmv47C9ief78dG0BHsnH7kbZzq1TVBw@mail.gmail.com>
Subject: Re: [PATCH 2/2] Staging: speakup: ERROR: Fix macro parenthesis.
From: =?UTF-8?B?7LWcKENob2kp6riw7JqpKEdpLXlvbmcp?= <yong@gnoy.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made a stupid mistake, and I'm sorry.
https://lkml.org/lkml/2014/6/8/53

2014-06-09 2:58 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> It looks like this patch is adding blank lines not parenthesis like the
> subject says.
>
> regards,
> dan carpenter
>
> On Sun, Jun 08, 2014 at 11:12:57PM +0900, Choi Gi-yong wrote:
>> Signed-off-by: Choi Gi-yong <yong@gnoy.org>
>> ---
>>  drivers/staging/speakup/speakup_acntpc.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/speakup/speakup_acntpc.c b/drivers/staging/speakup/speakup_acntpc.c
>> index 31f952b..f70b698 100644
>> --- a/drivers/staging/speakup/speakup_acntpc.c
>> +++ b/drivers/staging/speakup/speakup_acntpc.c
>> @@ -35,7 +35,7 @@
>>  #include "speakup_acnt.h" /* local header file for Accent values */
>>
>>  #define DRV_VERSION "2.10"
>> -#define PROCSPEECH '\r'
>> +#define PROCSPEECH ('\r')
>>
>>  static int synth_probe(struct spk_synth *synth);
>>  static void accent_release(void);
>> @@ -152,8 +152,10 @@ static inline bool synth_full(void)
>>  static const char *synth_immediate(struct spk_synth *synth, const char *buf)
>>  {
>>       u_char ch;
>> +
>>       while ((ch = *buf)) {
>>               int timeout = SPK_XMITR_TIMEOUT;
>> +
>>               if (ch == '\n')
>>                       ch = PROCSPEECH;
>>               if (synth_full())
>> @@ -257,6 +259,7 @@ static int synth_probe(struct spk_synth *synth)
>>  {
>>       unsigned int port_val = 0;
>>       int i = 0;
>> +
>>       pr_info("Probing for %s.\n", synth->long_name);
>>       if (port_forced) {
>>               speakup_info.port_tts = port_forced;
>> --
>> 1.9.1
>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel



-- 

최     기용
Choi Gi-yong

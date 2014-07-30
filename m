Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaG3VUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:20:51 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59370 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaG3VUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:20:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140730191638.GA5493@pleinair.baobob.org>
References: <20140730191638.GA5493@pleinair.baobob.org>
Date: Wed, 30 Jul 2014 23:20:49 +0200
Message-ID: <CAGwOe2Yhd896GWU=2j2dw+PFgCS1mmP+vkZaoLKed54zi7US2Q@mail.gmail.com>
Subject: Re: [PATCH] Staging: vt6655: staticfy variable
From: =?UTF-8?Q?Fernando_Apestegu=C3=ADa?= 
	<fernando.apesteguia@gmail.com>
To: Guillaume Clement <gclement@baobob.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 9:16 PM, Guillaume Clement <gclement@baobob.org> wrote:
> Hello,
>
>> Add static to variable.
>> Signed-off-by: Fernando Apesteguia <fernando.apesteguia@gmail.com>
>> ---
>>  drivers/staging/vt6655/ioctl.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/vt6655/ioctl.c
>> b/drivers/staging/vt6655/ioctl.c
>> index 65e5933..cc6e47b 100644
>> --- a/drivers/staging/vt6655/ioctl.c
>> +++ b/drivers/staging/vt6655/ioctl.c
>> @@ -41,7 +41,7 @@
>>  static int msglevel = MSG_LEVEL_INFO;
>>
>>  #ifdef WPA_SM_Transtatus
>> -SWPAResult wpa_Result;
>> +static SWPAResult wpa_Result;
>>  #endif
>
> This changes breaks the compilation (actually the linking). wpa_Result
> is actually used in device_main.c in device_open with the following:

Argh... sorry, I missed that.

>
>> #ifdef WPA_SM_Transtatus
>>       extern SWPAResult wpa_Result;
>> #endif

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaDFTAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 15:00:16 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:53673 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbaDFTAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 15:00:12 -0400
Message-ID: <5341A43A.3020200@gmail.com>
Date: Sun, 06 Apr 2014 14:00:10 -0500
From: Joel Pelaez Jorge <joelpelaez@gmail.com>
Organization: DarkSoft Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Silvan Jegen <s.jegen@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: rtl8192e: Fix sparse warning
References: <5341A05A.5080403@gmail.com> <1396810170.2874.9.camel@joe-AO722>
In-Reply-To: <1396810170.2874.9.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 06/04/14 13:49, Joe Perches escribió:
> On Sun, 2014-04-06 at 13:43 -0500, Joel Pelaez Jorge wrote:
>> Fix a sparse warning, non static symbol is no declared as such.
>> And fix a conflict with static function declared extern to include
>> rtl_wx.h header.
>>
>> drivers/staging/rtl8192e/rtl8192e/rtl_wx.c:1323:24: warning:
>> symbol 'r8192_wx_handlers_def' was not declared. Should it be static?
>>
>> Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
>> ---
>>    drivers/staging/rtl8192e/rtl8192e/rtl_wx.c |    3 ++-
>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
>> b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
>> index 498995d..f17584d 100644
>> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
>> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
>> @@ -19,6 +19,7 @@
>>
>>    #include <linux/string.h>
>>    #include "rtl_core.h"
>> +#include "rtl_wx.h"
>>
>>    #define RATE_COUNT 12
>>    static u32 rtl8192_rates[] = {
>> @@ -1293,7 +1294,7 @@ static iw_handler r8192_private_handler[] = {
>>    	(iw_handler)r8192_wx_get_PromiscuousMode,
>>    };
>>
>> -static struct iw_statistics *r8192_get_wireless_stats(struct net_device
>> *dev)
>> +struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
>>    {
>>    	struct r8192_priv *priv = rtllib_priv(dev);
>>    	struct rtllib_device *ieee = priv->rtllib;
>
> As far as I can tell, there's no reason this should
> be declared in the .h file and it should stay static
> and not be exposed at all.
>
>
In the source "rtl_core.c" is possible to use the symbol
r8192_get_wireless_stats, if WIRELESS_EXT has specifics values.

Although this scenario is unlikely to happen, is better prepare
this code for it.

Also, a better way will be delete 'extern' reference to symbol
in header file and source file.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbaHGFZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:25:11 -0400
Received: from s87.loopia.se ([194.9.94.112]:51399 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbaHGFZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:25:10 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <53E30DFB.6090309@hanshq.net>
Date: Wed, 06 Aug 2014 22:26:19 -0700
From: Hans Wennborg <hans@hanshq.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/15] rtlwifi: rtl8192de: fix decimal printf format specifiers
 prefixed with 0x
References: <1407300186-32673-1-git-send-email-hans@hanshq.net> <53E23DFE.7070209@lwfinger.net>
In-Reply-To: <53E23DFE.7070209@lwfinger.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 07:38 AM, Larry Finger wrote:
> On 08/05/2014 11:43 PM, Hans Wennborg wrote:
>> The prefix suggests the number should be printed in hex, so use
>> the %x specifier to do that.
>>
>> Found by using regex suggested by Joe Perches.
>>
>> Signed-off-by: Hans Wennborg <hans@hanshq.net>
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8192de/fw.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
>> index 2317707..66e1760 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
>> @@ -234,7 +234,7 @@ static int _rtl92d_fw_init(struct ieee80211_hw *hw)
>>   			 rtl_read_byte(rtlpriv, FW_MAC1_READY));
>>   	}
>>   	RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
>> -		 "Polling FW ready fail!! REG_MCUFWDL:0x%08ul\n",
>> +		 "Polling FW ready fail!! REG_MCUFWDL:0x%08lx\n",
>>   		 rtl_read_dword(rtlpriv, REG_MCUFWDL));
>>   	return -1;
>>   }
>
> It would be best to actually build with your patches installed. This one yields
> the following warning:

Terribly sorry about that, and thanks for catching it. I naively assumed 
that the code was correct besides the decimal vs. hex issue.

>    CC [M]  drivers/net/wireless/rtlwifi/rtl8192de/fw.o
> drivers/net/wireless/rtlwifi/rtl8192de/fw.c: In function ‘_rtl92d_fw_init’:
> drivers/net/wireless/rtlwifi/rtl8192de/fw.c:236:2: warning: format ‘%lx’ expects
> argument of type ‘long unsigned int’, but argument 5 has type ‘u32’ [-Wformat=]
>    RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
>    ^
>
> The format specifier should be %04x, not %08lx.

Shouldn't it be %08x since it's a 32-bit value?

 > I have no idea why gcc did not complain as %08ul is also wrong.

I assume the compiler would have warned about %08lu, but %08ul takes an 
unsigned and just prints an l afterwards.

  - Hans

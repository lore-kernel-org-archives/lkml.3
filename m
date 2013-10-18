Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab3JRWoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:44:16 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:48576 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603Ab3JRWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <5261B5D6.2020002@lwfinger.net>
References: <1382134538-3719-1-git-send-email-felipensp@gmail.com> <5261B5D6.2020002@lwfinger.net>
From: Felipe Pena <felipensp@gmail.com>
Date: Fri, 18 Oct 2013 19:43:50 -0300
Message-ID: <CA+5g0SK1Sr-3k1i+vfL8vXcT36XZBF-_GwCFYmrmca3dsE6iww@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers: net: wireless: rtlwifi: Fix wrong assignment
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 7:27 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 10/18/2013 05:15 PM, Felipe Pena wrote:
>>
>> There is a typo in the struct member name on assignment when checking
>> rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20_40, the check uses
>> pwrgroup_ht40
>> for bound limit and uses pwrgroup_ht20 when assigning instead.
>>
>> Signed-off-by: Felipe Pena <felipensp@gmail.com>
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8192se/rf.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
>> b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
>> index 5061f1d..92d38ab 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
>> @@ -265,7 +265,7 @@ static void
>> _rtl92s_get_txpower_writeval_byregulatory(struct ieee80211_hw *hw,
>>                                     rtlefuse->pwrgroup_ht40
>>                                     [RF90_PATH_A][chnl - 1]) {
>>                                         pwrdiff_limit[i] =
>> -                                         rtlefuse->pwrgroup_ht20
>> +                                         rtlefuse->pwrgroup_ht40
>>                                           [RF90_PATH_A][chnl - 1];
>>                                 }
>>                         } else {
>
>
> Good catch. There is only one problem - by convention we skip
> drivers/net/wireless in the subject. That would probably be OK, but you are
> missing the rtl8192se part, which needs to be there. I suggest that you use
> the subject "rtlwifi: rtl8192de: Fix wrong assignment".
>
> Larry
>
>

Thanks for the reply. I'll re-send it with the suggested subject.

-- 
Regards,
Felipe Pena

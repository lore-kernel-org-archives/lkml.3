Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3LALud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 06:50:33 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61862 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3LALub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 06:50:31 -0500
Message-ID: <529B2283.7040808@gmail.com>
Date: Sun, 01 Dec 2013 19:50:27 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Joe Perches <joe@perches.com>, "John W. Linville" <linville@tuxdriver.com>,
        rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mac80211: tx.c: be sure of 'sdata->vif.type' must
 be NL80211_IFTYPE_AP when be in NL80211_IFTYPE_AP case
References: <528AEFB7.4060301@gmail.com>   <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>   <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>   <52957ADA.2080704@gmail.com>   (sfid-20131127_055211_558798_A7DF5684) <1385739487.8656.1.camel@jlt4.sipsolutions.net>   <5299D306.7070701@gmail.com>   (sfid-20131130_125901_519610_EDA4068E) <1385816013.4327.1.camel@jlt4.sipsolutions.net>   <5299ED38.4090509@gmail.com> <5299EFDD.6060405@gmail.com>   (sfid-20131130_150205_984535_068F14A9) <1385842134.6108.4.camel@jlt4.sipsolutions.net>  <1385843940.2664.4.camel@joe-AO722> <529A7955.9010507@gmail.com>  (sfid-20131201_004838_825869_AF1FBAAC) <1385890647.4171.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1385890647.4171.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2013 05:37 PM, Johannes Berg wrote:
> On Sun, 2013-12-01 at 07:48 +0800, Chen Gang wrote:
> 
>> If ieee80211_subif_start_xmit() is not performance sensitive (I guess
>> so), we can use some short static functions instead of some code blocks
>> within ieee80211_subif_start_xmit().
>>
>>  - ieee80211_subif_start_xmit() is a long function (600+ lines).
>>
>>  - use short static function can share some code.
>>
>>  - if code can be shared, the work flow can be more clearer too (don't
>>    need fall-through or goto).
> 
> Frankly, I'm getting tired of discussing this. Please don't try to
> rewrite this code until you've understood it. You suggesting that
> "start_xmit()" isn't a performance sensitive function makes me realize
> you haven't even tried.
> 

OK, thank you for "you are getting tired ...". Please help try when you
have time.  :-)

No I didn't try -- so use 'if' and 'guess' for discussing.

Hmm... if it is performance sensitive:

 - use static function instead of some code block and try to share them.
   it adds additional instructions, but can shrink binary code size.
   if the performance is acceptable, it is the best way to me.

 - else (1st way not acceptable), use macro instead of static function.
   it expends binary code size, but can save some instructions.
   if the performance is acceptable, it is the acceptable way to me.

 - If neither of static function nor macro are acceptable,
   I still prefer to use 'goto' instead of 'fall-through'.
   that can let all compilers feel well, and can not feel any strange.

     normally, when prev case uses fall-through,
     it need be sure of next case need not notice about it (prev case).
     or it will make a little strange for readers when read next case.


Welcome any suggestions or completions.

Thanks.
-- 
Chen Gang

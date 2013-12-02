Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3LBApy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 19:45:54 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38445 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3LBApw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 19:45:52 -0500
Message-ID: <529BD83B.4030103@gmail.com>
Date: Mon, 02 Dec 2013 08:45:47 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mac80211: tx.c: be sure of 'sdata->vif.type' must
 be NL80211_IFTYPE_AP when be in NL80211_IFTYPE_AP case
References: <528AEFB7.4060301@gmail.com>  <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>  <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>  <52957ADA.2080704@gmail.com>  (sfid-20131127_055211_558798_A7DF5684) <1385739487.8656.1.camel@jlt4.sipsolutions.net>  <5299D306.7070701@gmail.com>  (sfid-20131130_125901_519610_EDA4068E) <1385816013.4327.1.camel@jlt4.sipsolutions.net>  <5299ED38.4090509@gmail.com> <5299EFDD.6060405@gmail.com>  (sfid-20131130_150205_984535_068F14A9) <1385842134.6108.4.camel@jlt4.sipsolutions.net>  <1385843940.2664.4.camel@joe-AO722>  <1385890523.4171.1.camel@jlt4.sipsolutions.net> <1385937499.2664.21.camel@joe-AO722>
In-Reply-To: <1385937499.2664.21.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 06:38 AM, Joe Perches wrote:
> On Sun, 2013-12-01 at 10:35 +0100, Johannes Berg wrote:
>> Good try, but no, now ap_sdata isn't even assigned. :)
> 
> Right.  Oh well.  There's no improving this without
> significant rewrite.  Even then, there may not be much
> overall improvement.
> 
> btw: Chen, I think fall-throughs are fine as long as
> they are commented appropriately.
> 

Hmm... for me, when use fall-through, need 2 things:

 - need a comment.

 - next case need not notice about prev case which fall-through.


If we can not fit the 2 things above, either can not use sub functions
or macros for it because of performance reason, 'goto' is better than
'fall-through'.

For me, in most cases, when a function becomes a long function, it is
always better to use sub-fuctions or macros instead of some blocks (but
it is really not urgent :-) ).


Thanks.
-- 
Chen Gang

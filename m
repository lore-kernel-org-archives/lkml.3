Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3DBEMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:12:14 -0400
Received: from mail-gh0-f182.google.com ([209.85.160.182]:35485 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3DBEMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:12:12 -0400
Message-ID: <515A5966.7020203@lwfinger.net>
Date: Mon, 01 Apr 2013 23:07:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the wireless-next tree
References: <20130402133400.017b4ec5cd37725b32aa8079@canb.auug.org.au> <515A4B6C.2080805@lwfinger.net> <20130402143108.129f7a97a8a05e88e53f3ff4@canb.auug.org.au>
In-Reply-To: <20130402143108.129f7a97a8a05e88e53f3ff4@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 10:31 PM, Stephen Rothwell wrote:
> Hi Larry,
>
> On Mon, 01 Apr 2013 22:07:24 -0500 Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>> On 04/01/2013 09:34 PM, Stephen Rothwell wrote:
>>>
>>> After merging the wireless-next tree, today's linux-next build (x86_64
>>> allmodconfig) failed like this:
>>>
>>> drivers/net/wireless/rtlwifi/rtl8188ee/dm.c:30:18: fatal error: wifi.h: No such file or directory
>>>
>>> Caused by commit f0eb856e0b6c ("rtlwifi: rtl8188ee: Add new driver").
>>> Forgot a file?
>>
>> I do not understand. File wifi.h is definitely there and is in
>> drivers/net/wireless/rtlwifi/. Use of that directory as a source of include
>> files is handled by "ccflags-y += -I drivers/net/wireless/rtlwifi
>> -D__CHECK_ENDIAN__" in the Makefile for rtl8188ee. In fact, it builds just fine
>> here.
>>
>> What am I missing?
>
> I don't know, sorry.  The tree I have also has
> drivers/net/wireless/rtlwifi/wifi.h. All the other uses of wifi.h in the
> other drivers below that directory use
>
> #include "../wifi.h"
>
> Maybe it has something to do with using O=... on the command line (which I do).

I was trying to get rid of the relative directory notation, but I guess I 
screwed it up somewhere. Rather than "wifi.h, I suspect I should have used <wifi.h>.

Larry



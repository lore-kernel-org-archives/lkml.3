Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3FZMX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:23:29 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48103 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3FZMX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:23:27 -0400
Message-ID: <51CADD3D.2030502@free-electrons.com>
Date: Wed, 26 Jun 2013 14:23:25 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: davem@davemloft.net, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfg80211/mac80211: fix doc compilation warnings
References: <1372189700-6247-1-git-send-email-michael.opdenacker@free-electrons.com> <1372232238.8157.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1372232238.8157.2.camel@jlt4.sipsolutions.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

Thank you for your review!

On 06/26/2013 09:37 AM, Johannes Berg wrote:
> On Tue, 2013-06-25 at 21:48 +0200, Michael Opdenacker wrote:
>> This patch fixes countless "No description found for parameter"
>> warnings generating documentation (running "make htmldocs"),
>> because the comments do not match the actual prototypes in the code.
>>
>> This issue didn't exist in 3.9. It may we worth fixing in 3.10
>> (if it's not too late).
> I think it's way late. Besides, all of this is already fixed in -next
> trees.
Cool! That's good news :)
>
>
>> @@ -4153,6 +4153,7 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
>>   * cfg80211_crit_proto_stopped() - indicate critical protocol stopped by driver.
>>   *
>>   * @wdev: the wireless device for which critical protocol is stopped.
>> + * @gfp: the type of memory to allocate (see kmalloc).
> This is also wrong, the allocation flags don't really change the *type*
> of memory, but only *how* it is allocated.
I agree, but I chose to stick to the description I found 5 times in
include/linux/slab.h. I shouldn't have followed bad examples...

I'll submit another patch ;)

Thanks again,

Michael.

-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098


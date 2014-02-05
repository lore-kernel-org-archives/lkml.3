Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaBEEl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 23:41:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48923 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaBEElZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 23:41:25 -0500
Date: Tue, 04 Feb 2014 20:41:24 -0800 (PST)
Message-Id: <20140204.204124.155963712324513810.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: cwang@twopensource.com, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [bisected] Re: WARNING: at net/ipv4/devinet.c:1599
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdWrYj1te-7qhKg-uHmXpuLaBBdqCEmpv_fgYSmaN3yujw@mail.gmail.com>
References: <CAHA+R7Omv++NCg=nocVsW+tM=Zv_qCNhX1JjtFTuCzfz9B3Cig@mail.gmail.com>
	<CAMuHMdWUR-x=fwG26xg8AsUQwL+FXLaQAnkaWHbrVaep0QzHJQ@mail.gmail.com>
	<CAMuHMdWrYj1te-7qhKg-uHmXpuLaBBdqCEmpv_fgYSmaN3yujw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 4 Feb 2014 21:03:24 +0100

> On Tue, Feb 4, 2014 at 8:20 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Tue, Feb 4, 2014 at 7:08 PM, Cong Wang <cwang@twopensource.com> wrote:
>>> On Tue, Feb 4, 2014 at 6:19 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>>
>>>> Anyone with a clue?
>>>>
>>>
>>> Looks like we need:
>>>
>>> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
>>> index ac2dff3..bdbf68b 100644
>>> --- a/net/ipv4/devinet.c
>>> +++ b/net/ipv4/devinet.c
>>> @@ -1443,7 +1443,8 @@ static size_t inet_nlmsg_size(void)
>>>                + nla_total_size(4) /* IFA_LOCAL */
>>>                + nla_total_size(4) /* IFA_BROADCAST */
>>>                + nla_total_size(IFNAMSIZ) /* IFA_LABEL */
>>> -              + nla_total_size(4);  /* IFA_FLAGS */
>>> +              + nla_total_size(4)  /* IFA_FLAGS */
>>> +              + nla_total_size(sizeof(struct ifa_cacheinfo)); /*
>>> IFA_CACHEINFO */
>>>  }
>>
>> Thanks for your suggestion, but it doesn't help :-(
> 
> Bummer, I applied it to the wrong tree.
> 
> Yes, it works, thanks a lot!
> 
> David, Jiri, is this the right fix, or just a band-aid?

It looks correct, and if you look ipv6 does this correctly already,
someone please submit this formally.

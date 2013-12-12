Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3LLTCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:02:44 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39056 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab3LLTCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:02:43 -0500
Date: Thu, 12 Dec 2013 14:02:41 -0500 (EST)
Message-Id: <20131212.140241.899891225639224762.davem@davemloft.net>
To: olof@lixom.net
Cc: whiteheadm@acm.org, linux@arm.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: eth: 8390: remove section warning in etherh.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOesGMj_0m-Y8TvrZF=zgT33RuDtismjY=k6pbfm+MFmp2p=_w@mail.gmail.com>
References: <1386837577-15130-1-git-send-email-olof@lixom.net>
	<CAP8WD_aJEmBYbM0BmQodGJsOPqZ+vqk9B15n297q_+aCorR=VQ@mail.gmail.com>
	<CAOesGMj_0m-Y8TvrZF=zgT33RuDtismjY=k6pbfm+MFmp2p=_w@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Dec 2013 11:02:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>
Date: Thu, 12 Dec 2013 00:53:00 -0800

> On Thu, Dec 12, 2013 at 12:46 AM, tedheadster <tedheadster@gmail.com> wrote:
>> On Thu, Dec 12, 2013 at 3:39 AM, Olof Johansson <olof@lixom.net> wrote:
>>>
>>> Commit c45f812f0280 ('8390 : Replace ei_debug with msg_enable/NETIF_MSG_*
>>> feature') ended up moving the printout of version[] from something that
>>> will be compiled out due to defines, to something that is now evaluated
>>> at runtime.
>>>
>>> That means that what always used to be an access to an __initdata string
>>> from non-__init code started showing up as a section mismatch when it
>>> didn't before.
>>>
>>> All other 8390 versions skip __initdata on the version string, and
>>> starting to annotate the whole chain of callers with __init seems like
>>> more churn than it's worth on this driver, so remove it from etherh.c as
>>> well.
>>>
>>
>> Olof,
>>   should you also remove the __init tag from etherh_banner() since it is
>> called from etherh_probe(), which does not have an __init tag?
> 
> Hmm.
> 
> The section warning functionality is clever enough to not trigger when
> a function is named _probe() and references __initdata, and discarding
> etherh_banner() should be just fine so I don't see a need to remove
> it.

Right, applied, thanks Olof.

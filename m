Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3G3Gnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 02:43:46 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59082 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3G3Gnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 02:43:45 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-22-51f7609e6cb4
Message-ID: <51F7609A.5040305@hitachi.com>
Date: Tue, 30 Jul 2013 15:43:38 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, itoukzo@nttdata.co.jp
Subject: Re: Re: Re: [RFC PATCH 0/5] Add a hash value for each line in
 /dev/kmsg
References: <20130703014616.18745.34699.stgit@localhost.localdomain> <CAPXgP11HzstSBt1PQUgJeGC59yXc=DSYQuruB40LOsm=RZQBZA@mail.gmail.com> <51F6580B.30409@hitachi.com> <CAPXgP10uznC6gh39RzFNBz8ah+wE_V==PrC1=EyfOjy6anxN6g@mail.gmail.com>
In-Reply-To: <CAPXgP10uznC6gh39RzFNBz8ah+wE_V==PrC1=EyfOjy6anxN6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(2013/07/29 21:46), Kay Sievers wrote:> On Mon, Jul 29, 2013 at 1:54 PM, Hidehiro Kawai
> <hidehiro.kawai.ez@hitachi.com> wrote:
>
>> Also, I heard about the discussion
>> at the kernel summit 2 years ago.  According to the article of LWN,
>> it seems that Linus objected your approach (i.e. adding random bit as
>> message ID).  Were there some agreements on this issue at the kernel summit?
>
> No, there are no further discussions about this.

So, how are you going to push patches to add random 128-bit IDs into upstream?
To be honest, I don't mind if we take the way of adding random IDs, because
I'm interested in only limited number of messages for my use case (taking
some actions automatically when seeing particular messages).
The reasons why I took the way of message hashing are for upstream acceptance
and flexibility for various usages.

> Pre-allocated, static, randomly created 128-bit IDs are just the
> simplest and most robust option to identify messages. It's an
> unmanaged namespace that needs no coordination, the IDs are always
> stable, never change and are guaranteed to be unique. None of the
> hashing-of-the strings solutions can provide that by default.

I think it depends on use cases and user space tools.  Strict uniqueness
and stability wouldn't always be needed.

> I would expect that over time, the automatic hashes would end up
> becoming static numbers explicitly add to the messages anyway, because
> changing the message text will change the hash, which is nothing we
> really want to deal with. For that reason, I think that we can add the
> ID right away, without any of the hashing; and do that only for a very
> tiny fraction of the messages where such IDs make sense and add value.

Adding ID to particular printks will work well for some use cases, but
not all.  For example, there is a web service, OSS message pedia, which
provides kernel message details edited by community.  Currently, it
looks like it lists search results based on similarity with an input
string.  If it utilizes message hashes or IDs, it can provide more values.
However, the fixed message ID approach wouldn't work well, because
it deals with hundreds messages at this moment.

> Message IDs is how userspace logging works today; so from the
> userspace side this would fit into the already existing
> infrastructure, while possibly changing hashes which require another
> type of translation catalog would not.

Do you say about systemd?  It is one of the user space tools which
handle messages.  There can be several use cases and value-added tools
regarding that, so we shouldn't assume one particular tool, I think.


Randomly generated IDs make message handling in user space simple, but
put some maintenance costs on kernel developers.  Automatically
generated hashes give some complexity to user space tools, but there is
no maintenance cost for respective printks.  There are tradeoffs.
The problem is which ways are acceptable for the upstream kernel
(may be both or none?).

Regards,
-- 
Hidehiro Kawai
Hitachi, Yokohama Research Laboratory
Linux Technology Center



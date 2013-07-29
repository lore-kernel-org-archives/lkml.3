Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3G2Mq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:46:29 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37654 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3G2Mq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:46:28 -0400
MIME-Version: 1.0
In-Reply-To: <51F6580B.30409@hitachi.com>
References: <20130703014616.18745.34699.stgit@localhost.localdomain>
 <CAPXgP11HzstSBt1PQUgJeGC59yXc=DSYQuruB40LOsm=RZQBZA@mail.gmail.com> <51F6580B.30409@hitachi.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 29 Jul 2013 14:46:06 +0200
Message-ID: <CAPXgP10uznC6gh39RzFNBz8ah+wE_V==PrC1=EyfOjy6anxN6g@mail.gmail.com>
Subject: Re: Re: [RFC PATCH 0/5] Add a hash value for each line in /dev/kmsg
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, itoukzo@nttdata.co.jp
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 1:54 PM, Hidehiro Kawai
<hidehiro.kawai.ez@hitachi.com> wrote:

> Also, I heard about the discussion
> at the kernel summit 2 years ago.  According to the article of LWN,
> it seems that Linus objected your approach (i.e. adding random bit as
> message ID).  Were there some agreements on this issue at the kernel summit?

No, there are no further discussions about this.

Pre-allocated, static, randomly created 128-bit IDs are just the
simplest and most robust option to identify messages. It's an
unmanaged namespace that needs no coordination, the IDs are always
stable, never change and are guaranteed to be unique. None of the
hashing-of-the strings solutions can provide that by default.

I would expect that over time, the automatic hashes would end up
becoming static numbers explicitly add to the messages anyway, because
changing the message text will change the hash, which is nothing we
really want to deal with. For that reason, I think that we can add the
ID right away, without any of the hashing; and do that only for a very
tiny fraction of the messages where such IDs make sense and add value.

Message IDs is how userspace logging works today; so from the
userspace side this would fit into the already existing
infrastructure, while possibly changing hashes which require another
type of translation catalog would not.

Kay

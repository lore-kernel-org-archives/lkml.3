Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbaCZUMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:12:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46641 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbaCZUMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:12:47 -0400
Date: Wed, 26 Mar 2014 16:12:42 -0400 (EDT)
Message-Id: <20140326.161242.576245997077162750.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: jesse@nicira.com, pshelar@nicira.com, tgraf@redhat.com,
        dev@openvswitch.org, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        edumazet@google.com, dborkman@redhat.com, therbert@google.com,
        jasowang@redhat.com, fw@strlen.de, joe@perches.com, horms@verge.net.au,
        jiri@resnulli.us, mst@redhat.com, Paul.Durrant@citrix.com,
        JBeulich@suse.com, herbert@gondor.apana.org.au, mszeredi@suse.cz,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4] core, nfqueue, openvswitch: Orphan frags in
 skb_zerocopy and handle errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140326.155958.1928261590856069753.davem@davemloft.net>
References: <1395397894-9493-1-git-send-email-zoltan.kiss@citrix.com>
	<20140326.155958.1928261590856069753.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Mar 2014 13:12:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2QKD1CY001475

From: David Miller <davem@davemloft.net>
Date: Wed, 26 Mar 2014 15:59:58 -0400 (EDT)

> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Fri, 21 Mar 2014 10:31:34 +0000
> 
>> skb_zerocopy can copy elements of the frags array between skbs, but it doesn't
>> orphan them. Also, it doesn't handle errors, so this patch takes care of that
>> as well, and modify the callers accordingly. skb_tx_error() is also added to
>> the callers so they will signal the failed delivery towards the creator of the
>> skb.
>> 
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> 
> Applied, thanks Zoltan.

Actually, Zoltan, you have to fix this:

net/core/skbuff.c: In function ¡skb_zerocopy¢:
net/core/skbuff.c:2172:2: warning: passing argument 1 of ¡skb_orphan_frags¢ discards ¡const¢ qualifi
er from pointer target type [enabled by default]
In file included from include/linux/tcp.h:21:0,
                 from net/core/skbuff.c:50:
include/linux/skbuff.h:1904:19: note: expected ¡struct sk_buff *¢ but argument is of type ¡const str
uct sk_buff *¢
net/core/skbuff.c:2173:3: warning: passing argument 1 of ¡skb_tx_error¢ discards ¡const¢ qualifier f
rom pointer target type [enabled by default]
net/core/skbuff.c:642:6: note: expected ¡struct sk_buff *¢ but argument is of type ¡const struct sk_
buff *¢
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

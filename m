Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaKGGsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:48:19 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35603 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaKGGsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:48:15 -0500
From: "Bill Bonaparte" <programme110@gmail.com>
To: "'Jesper Dangaard Brouer'" <brouer@redhat.com>
Cc: <fw@strlen.de>, <linux-kernel@vger.kernel.org>,
        "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        "'Patrick McHardy'" <kaber@trash.net>, <kadlec@blackhole.kfki.hu>,
        <davem@davemloft.net>, "'Changli Gao'" <xiaosuo@gmail.com>,
        "'Andrey Vagin'" <avagin@openvz.org>,
        <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: re: netfilter: nf_conntrack: there maybe a bug in __nf_conntrack_confirm, when it race against get_next_corpse
Date: Fri, 7 Nov 2014 14:47:32 +0800
Message-ID: <01dd01cffa56$bdb10460$39130d20$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac/6UbrdX9f0ArEYTYiA3ElDpil5dA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 6 Nov 2014 21:01:00 
"Jesper" <brouter@redhat.com> wrote:
>There is several issues with your submission.  I'll take care of
resubmitting a patch in your name (so you will get credit in the git log).
>
>If you care to know, issues are:
>1. you are not sending to the appropriate mailing lists,  2. patch is as an
attachment (should be inlined),  3. the patch have style and white-space
issues.

Thanks, Jesper. This is my first time to submit a patch, not know much about
the rules.  I will get it soon.

>> if there is a race at operating ct->status, there will be in 
>> alternative
>> case:
>> 1) IPS_DYING bit which set in get_next_corpse override other bits (e.g.
>> IPS_SRC_NAT_DONE_BIT), or
>> 2) other bits (e.g. IPS_SRC_NAT_DONE_BIT) which set in 
>> nf_nat_setup_info override IPS_DYING bit.

> Notice the set_bit() is atomic, so we don't have these issues (of bits
getting overridden).

In most cases, we do the atomic operation on ct->status (with set_bit), but
in function nf_nat_setup_info, we
assume that unconfirmed ct is always holded by current cpu, and has no race
against other cpus, so we don't
use set_bit.  
the following code is extracted from the nf_nat_setup_info:
/* Non-atomic: we own this at the moment. */
  if (maniptype == NF_NAT_MANIP_SRC)
	ct->status |= IPS_SRC_NAT;
  else
	ct->status |= IPS_DST_NAT;

--
Best regards,
  Bill Bonaparte



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaHUMyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:54:37 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:33556 "EHLO cstnet.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752817AbaHUMyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:54:35 -0400
Date: Thu, 21 Aug 2014 20:53:19 +0800 (GMT+08:00)
From: "Zhouyi Zhou" <yizhouzhou@ict.ac.cn>
To: "Florian Westphal" <fw@strlen.de>
Cc: "Zhouyi Zhou" <zhouzhouyi@gmail.com>, pablo@netfilter.org, kaber@trash.net,
        kadlec@blackhole.kfki.hu, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbaron@akamai.com
Message-ID: <1498523.4b875.147f8a0e3c8.Coremail.yizhouzhou@ict.ac.cn>
In-Reply-To: <20140821121132.GA16498@breakpoint.cc>
References: <1408589568-27046-1-git-send-email-yizhouzhou@ict.ac.cn>
 <20140821121132.GA16498@breakpoint.cc>
Subject: Re: [PATCH 1/1] netfilter/jump_label: use HAVE_JUMP_LABEL?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Originating-IP: [124.207.50.250]
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT2.1.10 dev build
 20131120(24194.5778.5783) Copyright (c) 2002-2014 www.mailtech.cn cstnet
X-SendMailWithSms: false
X-CM-CTRLDATA: cQ6JYGZvb3Rlcl90eHQ9MTI0MDo2
X-CM-TRANSID: RgCowJDLH8PA6_VTqB_sAQ--.37549W
X-CM-SenderInfo: x1l2x05x2k03g6lf3hldfou0/1tbiBgIDAFNaa6+CZAAAss
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Florian for reviewing

> -----Original Messages-----
> From: "Florian Westphal" <fw@strlen.de>

> 
> Zhouyi Zhou <zhouzhouyi@gmail.com> wrote:
> > 
> > CONFIG_JUMP_LABEL doesn't ensure HAVE_JUMP_LABEL, if it
> > is not the case use maintainers's own mutex to guard
> > the modification of global values.

CONFIG_JUMP_LABEL says the user wants to use jump labels.
But we also need the toolchain to support it.

That is reflected in CC_HAVE_ASM_GOTO=y, and if both are
set then HAVE_JUMP_LABEL is set to true.

> I don't understand this patch.
> 
> What is the problem you are fixing?

There is basically no real problem here.
This patch only tries to make kernel code that using 
static_key infrastructure appears "unified"
> 
> The intent is to only use static_key infrastructure
> if user has enabled CONFIG_JUMP_LABEL.

The other parts of kernel either use #ifdef HAVE_JUMP_LABEL,
or use no "#ifdef" at all(the two exceptions are netfilter 
and powerpc modules which I send patches to both).

Jason has suggested me to make the patches:
https://lkml.org/lkml/2014/8/20/761

"Unified" is the reason, I guess :-)
so rookies like me can have unified examples to follow


 
Cheers
Zhouyi







Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaHUC7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:59:36 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:38134 "EHLO cstnet.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750809AbaHUC7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:59:35 -0400
Date: Thu, 21 Aug 2014 10:58:18 +0800 (GMT+08:00)
From: "Zhouyi Zhou" <yizhouzhou@ict.ac.cn>
To: "Jason Baron" <jbaron@akamai.com>
Cc: "Zhouyi Zhou" <zhouzhouyi@gmail.com>, drjones@redhat.com,
        konrad.wilk@oracle.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@kernel.org, davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org
Message-ID: <1f4dead.5721.147f680239b.Coremail.yizhouzhou@ict.ac.cn>
In-Reply-To: <53F50C74.7080304@akamai.com>
References: <1408526982-23196-1-git-send-email-yizhouzhou@ict.ac.cn>
 <53F50C74.7080304@akamai.com>
Subject: Re: [PATCH 1/1] jump_label: tidy jump_label_ratelimit.h
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: [159.226.43.96]
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT2.1.10 dev build
 20131120(24194.5778.5783) Copyright (c) 2002-2014 www.mailtech.cn cstnet
X-SendMailWithSms: false
X-CM-CTRLDATA: hWCZGGZvb3Rlcl90eHQ9MjE3Nzo2
X-CM-TRANSID: SQCowJD7T_RKYPVT1U7kAQ--.47313W
X-CM-SenderInfo: x1l2x05x2k03g6lf3hldfou0/1tbiBgUDAFNaa66KpgABsh
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jason for reviewing it 
> -----Original Messages-----
> From: "Jason Baron" <jbaron@akamai.com>
> Sent Time: Thursday, August 21, 2014
> To: "Zhouyi Zhou" <zhouzhouyi@gmail.com>
> Cc: drjones@redhat.com, konrad.wilk@oracle.com, raghavendra.kt@linux.vnet.ibm.com, mingo@kernel.org, davem@davemloft.net, hannes@stressinduktion.org, linux-kernel@vger.kernel.org, "Zhouyi Zhou" <yizhouzhou@ict.ac.cn>
> Subject: Re: [PATCH 1/1] jump_label: tidy jump_label_ratelimit.h
> 
> Yes, that looks good. While at it I grep'd the tree for
> 'CONFIG_JUMP_LABEL', and found some uses in the
> netfilter code which should probably be
> 'HAVE_JUMP_LABEL' as well.
I have submitted two patches according to you suggestions:
https://lkml.org/lkml/2014/8/20/885
https://lkml.org/lkml/2014/8/20/883
Hope I have made them right

Thanks 
Zhouyi
> 
> Thanks,
> 
> -Jason
> 
> On 08/20/2014 05:29 AM, Zhouyi Zhou wrote:
> > jump_label_ratelimit.h is split from jump_label.h to enable the 
> > includers who don't want linux/workqueue.h.
> > As HAVE_JUMP_LABEL is only defined in jump_label.h, will following  
> > patch makes jump_labe_ratelimit.h more tidy?
> >
> > Compiled and Tested in x86_64
> > Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> > ---
> >  include/linux/jump_label_ratelimit.h |    5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
> > index 089f70f..0d34d7e 100644
> > --- a/include/linux/jump_label_ratelimit.h
> > +++ b/include/linux/jump_label_ratelimit.h
> > @@ -4,15 +4,12 @@
> >  #include <linux/jump_label.h>
> >  #include <linux/workqueue.h>
> >  
> > -#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> > +#ifdef HAVE_JUMP_LABEL
> >  struct static_key_deferred {
> >  	struct static_key key;
> >  	unsigned long timeout;
> >  	struct delayed_work work;
> >  };
> > -#endif
> > -
> > -#ifdef HAVE_JUMP_LABEL
> >  extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
> >  extern void
> >  jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
> 





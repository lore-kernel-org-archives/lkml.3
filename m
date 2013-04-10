Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3DJJGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:06:17 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:14773
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab3DJJGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:06:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dIc89bh542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh2a8h668h839h8e2h8e3h941hd25hf0ah1269h1288h12a5h12a9h12bdh12e1h137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ahbe9i1155h)
From: Tang Yuantian-B29983 <B29983@freescale.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: RE: [PATCH] of: remove the unnecessary of_node_put for
 of_parse_phandle_with_args()
Thread-Topic: [PATCH] of: remove the unnecessary of_node_put for
 of_parse_phandle_with_args()
Thread-Index: AQHONPS3+EIQIiX6c0uj2F9M15YciZjPKp2AgAAAOYA=
Date: Wed, 10 Apr 2013 09:06:11 +0000
Message-ID: <D07C73A334FF604B95B3CBD2A545D07B0B128AE0@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1365490569-32455-1-git-send-email-Yuantian.Tang@freescale.com>
 <20130410190327.a70d4c3798509d664aef2f13@canb.auug.org.au>
In-Reply-To: <20130410190327.a70d4c3798509d664aef2f13@canb.auug.org.au>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.128]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3A96IgV010680


> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: 2013Äê4ÔÂ10ÈÕ 17:03
> To: Tang Yuantian-B29983
> Cc: grant.likely@secretlab.ca; devicetree-discuss@lists.ozlabs.org;
> linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> rob.herring@calxeda.com
> Subject: Re: [PATCH] of: remove the unnecessary of_node_put for
> of_parse_phandle_with_args()
> 
> Hi,
> 
> On Tue, 9 Apr 2013 14:56:09 +0800 <Yuantian.Tang@freescale.com> wrote:
> >
> > From: Tang Yuantian <yuantian.tang@freescale.com>
> >
> > As the function itself says it is caller's responsibility to call the
> > of_node_put().  So, remove it on success to keep the reference count
> > correct.
> >
> > Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
> > ---
> >  drivers/of/base.c | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/drivers/of/base.c b/drivers/of/base.c index
> > 321d3ef..e8b4c28 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -1168,9 +1168,6 @@ static int __of_parse_phandle_with_args(const
> struct device_node *np,
> >  					out_args->args[i] = be32_to_cpup(list++);
> >  			}
> >
> > -			/* Found it! return success */
> > -			if (node)
> > -				of_node_put(node);
> 
> Actually, if out_args is NULL, you should do the of_node_put(node), so
> probably the correct fix is to add an "else" before the above "if" (and
> move the comment).
> 

Yes, I already sent out the v2 patch.
Please see: http://patchwork.ozlabs.org/patch/235288/

Regards,
Yuantian

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab3HUBjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 21:39:40 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:14258
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408Ab3HUBjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 21:39:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zcb8kz98dI9371I936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 21 Aug 2013 09:40:33 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
CC: Fabio Estevam <festevam@gmail.com>, Liu Ying <Ying.Liu@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] ARM: imx6q: refactor some ldb related clocks
Message-ID: <20130821014031.GC30533@S2101-09.ap.freescale.net>
References: <1376987932-5540-1-git-send-email-Ying.Liu@freescale.com>
 <1376987932-5540-2-git-send-email-Ying.Liu@freescale.com>
 <CAOMZO5Afjp-zPzUaNE63L7Y2LjZbSrLupAJ_jFnf1Gg1+hx0Nw@mail.gmail.com>
 <20130820211827.4443.97943@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130820211827.4443.97943@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 02:18:27PM -0700, Mike Turquette wrote:
> Quoting Fabio Estevam (2013-08-20 08:40:52)
> > On Tue, Aug 20, 2013 at 5:38 AM, Liu Ying <Ying.Liu@freescale.com> wrote:
> > 
> > > diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.txt b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
> > > index 5a90a72..90e923e 100644
> > > --- a/Documentation/devicetree/bindings/clock/imx6q-clock.txt
> > > +++ b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
> > > @@ -89,8 +89,6 @@ clocks and IDs.
> > >         gpu3d_shader            74
> > >         ipu1_podf               75
> > >         ipu2_podf               76
> > > -       ldb_di0_podf            77
> > > -       ldb_di1_podf            78
> > >         ipu1_di0_pre            79
> > >         ipu1_di1_pre            80
> > >         ipu2_di0_pre            81
> > 
> > This causes a 'hole' in the clock numbering scheme: 74, 75, 76, 79, 80, etc
> 
> How does this fit in with the idea of having a stable binding/ABI? Seems
> like changing this would be a bad idea for devices in the field that
> have older DTBs.

We should be safe since none of existing DTBs refers to the clocks (they
are not leaf clocks in the whole clock tree but some interconnection
ones).

Shawn


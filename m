Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3GVMrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:47:07 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:47525
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844Ab3GVMrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:47:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 22 Jul 2013 20:46:49 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Robin Gong <b38343@freescale.com>
CC: <broonie@kernel.org>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <lgirdwood@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] regulator: pfuze100: add pfuze100 regulator driver
Message-ID: <20130722124647.GK20271@S2101-09.ap.freescale.net>
References: <1374398247-11384-1-git-send-email-b38343@freescale.com>
 <20130722091058.GI20271@S2101-09.ap.freescale.net>
 <20130722103935.GA14838@Robin-OptiPlex-780>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130722103935.GA14838@Robin-OptiPlex-780>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 06:39:36PM +0800, Robin Gong wrote:
> > > +static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
> > > +{
> > > +	struct device *dev = chip->dev;
> > > +	struct device_node *parent;
> > > +	int ret;
> > > +
> > > +	of_node_get(dev->parent->of_node);
> > > +	parent = of_find_node_by_name(dev->parent->of_node, "regulators");
> > > +	if (!parent) {
> > > +		dev_err(dev, "regulators node not found\n");
> > > +		return -EINVAL;
> > 
> > So you leave dev->parent->of_node unbalanced.
> > 
> Seems of_find_node_by_name will of_node_put the parent node.

Ah, yes.  I missed that.

Shawn


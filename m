Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3ITVxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 17:53:18 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:41456
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027Ab3ITVxQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:53:16 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh148cI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Fri, 20 Sep 2013 14:53:08 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Joe Perches <joe@perches.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v4] clk: si570: Add a driver for SI570 oscillators
References: <1379698757-25232-1-git-send-email-soren.brinkmann@xilinx.com>
 <20130920181529.GA31173@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130920181529.GA31173@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <65b27409-d70f-41d2-ace5-9c3fe65ec24d@CO9EHSMHS003.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 11:15:29AM -0700, Guenter Roeck wrote:
> On Fri, Sep 20, 2013 at 10:39:17AM -0700, Soren Brinkmann wrote:
[...]
> > diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
> > new file mode 100644
> > index 0000000..13c2091
> > --- /dev/null
> > +++ b/drivers/clk/clk-si570.c
[...]
> > +static int si570_probe(struct i2c_client *client,
[...]
> > +	/* Read the requested initial output frequency from device tree */
> > +	if (!of_property_read_u32(client->dev.of_node, "clock-frequency",
> > +				&initial_fout)) {
> > +		err = clk_set_rate(clk, initial_fout);
> > +		if (err) {
> > +			of_clk_del_provider(client->dev.of_node);
> > +			clk_unregister(data->hw.clk);
> 
> Is that needed ? I would have thought it isn't because you use a devm_ function
> to register it.
> 
> Not that I understand the clk code, but getting clk from the registration
> function and unregistering hw.clk (without seting it) sems a bit odd.
> Is it well defined that you have to unregister hw.clk ?
You're absolutely right. I'll remove all calls to clk_unregister().
Thanks for finding that one.

	Sören



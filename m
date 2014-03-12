Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaCLQSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:18:32 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:50001
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755224AbaCLQS2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:18:28 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Wed, 12 Mar 2014 09:18:15 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <monstr@monstr.eu>
CC: Marc Kleine-Budde <mkl@pengutronix.de>,
        Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Michal Simek <michals@xilinx.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        Soren Brinkmann <sorenb@xilinx.com>
Subject: Re: [PATCH v5] can: xilinx CAN controller support.
References: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local>
 <531DD2C4.5060109@pengutronix.de>
 <f1e2f08f-05fc-40d3-8437-4c6817d631cb@AM1EHSMHS010.ehs.local>
 <531F0636.4050608@pengutronix.de>
 <a99feda0-7463-4781-bb73-90b99e65b014@CO9EHSMHS028.ehs.local>
 <531F1E30.4040203@pengutronix.de>
 <5320348B.7030401@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5320348B.7030401@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <baa90f80-fe7b-49f1-a482-8f173793b5dd@CH1EHSMHS043.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 11:18AM +0100, Michal Simek wrote:
> Hi guys,
> 
> 
> On 03/11/2014 03:31 PM, Marc Kleine-Budde wrote:
> > On 03/11/2014 03:08 PM, Appana Durga Kedareswara Rao wrote:
> > 
> >>>>>> +   struct napi_struct napi;
> >>>>>> +   u32 (*read_reg)(const struct xcan_priv *priv, enum xcan_reg reg);
> >>>>>> +   void (*write_reg)(const struct xcan_priv *priv, enum xcan_reg reg,
> >>>>>> +                   u32 val);
> >>>>>> +   struct net_device *dev;
> >>>>>> +   void __iomem *reg_base;
> >>>>>> +   unsigned long irq_flags;
> >>>>>> +   struct clk *aperclk;
> >>>>>> +   struct clk *devclk;
> >>>>>
> >>>>> Please rename the clock variables to match the names in the DT.
> >>>>>
> >>>> The clock names are different for axi CAN and CANPS case.
> >>>> So will make them as busclk and devclk Are you ok with this?
> >>>
> >>> Why not "ref_clk" and "aper_clk" as used in the DT?
> >>>
> >> One of the comments I got from the Soren(sorenb@xilinx.com)
> >> Is the  clock-names must match the data sheet.
> >> If I Modify the clock names then it is different names for AXI CAN
> >> and CANPS case.
> > 
> > Sorry, my faul, I thought the names are already these from the
> > datasheet. As Sören pointed out please use 's_axi_aclk' and
> > 'can_clk' for the DT and for the the variable names in the private
> > struct, too.
> > 
> > The 'official' name of the ip core seems to be axi_can, should we rename
> > the driver? I suspect, that Michal wants to keep xilinx in the name for
> > marketing reasons :P
> 
> I hope that I am not moving to marketing position.  :-)
> 
> opb_can, plb_can, axi_can, amba_can are all valid options for this IP.
> 
> Maybe in future Xilinx will decide to use different bus and then will just move
> all current soft IPs to new bus and drivers will be compatible.
> This is exactly what happened when Xilinx moved from OPB to PLB and then
> from PLB to AXI.
> That's why I think in general having bus name in name doesn't fit for our case.
> 
> The same is for clock name which has bus name in it.
> For PLB it was called SPLB_Clk and I don't have OPB version but
> at least standalone driver points to OPB version where I believe
> SPLB_Clk name was not used.

Okay, then 'bus_clk' would probably be fine. That is hopefully obvious
enough to be mapped to a clock input of that IP, while being generic
enough to allow other buses as well.

	Sören



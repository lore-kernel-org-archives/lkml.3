Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaDOKD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:03:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45985 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbaDOKDW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:03:22 -0400
Date: Tue, 15 Apr 2014 18:00:58 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: berlin: add GPIO nodes for the BG2Q
Message-ID: <20140415180058.2fefca78@xhacker>
In-Reply-To: <534CFA77.9030108@gmail.com>
References: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com>
	<1397549245-3338-3-git-send-email-antoine.tenart@free-electrons.com>
	<534CFA77.9030108@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-14_01:2014-04-14,2014-04-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404150164
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Tue, 15 Apr 2014 02:23:03 -0700
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> On 04/15/2014 10:07 AM, Antoine Ténart wrote:
> > The Marvell Berlin BG2Q has 6 GPIO ports compatible with the
> > snps,dw-apb-gpio driver. This patch add the corresponding device tree
> > nodes.
> >
> > Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> > ---
> >   arch/arm/boot/dts/berlin2q.dtsi | 102
> > ++++++++++++++++++++++++++++++++++++++++ 1 file changed, 102 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/berlin2q.dtsi
> > b/arch/arm/boot/dts/berlin2q.dtsi index e6e556055dfc..b2625f896bc5 100644
> > --- a/arch/arm/boot/dts/berlin2q.dtsi
> > +++ b/arch/arm/boot/dts/berlin2q.dtsi
> > @@ -109,6 +109,78 @@
> >   			ranges = <0 0xe80000 0x10000>;
> >   			interrupt-parent = <&aic>;
> >
> > +			gpio0: gpio@0400 {
> > +				compatible = "snps,dw-apb-gpio";
> > +				reg = <0x0400 0x400>;
> > +				#address-cells = <1>;
> > +				#size-cells = <0>;
> > +
> > +				porta: gpio-controller@0 {
> 
> ePAPR recommended name is even more generic, i.e. "gpio". If
> that clashed in any way with other numbered names, I suggest
> to rename to "gpio-port" as actually the controller is the
> parent node and this represents one port (in the nomenclature
> of DW-APB-GPIO).
> 
> > +					compatible =
> > "snps,dw-apb-gpio-port";
> > +					gpio-controller;
> > +					#gpio-cells = <2>;
> > +					snps,nr-gpios = <32>;
> 
> 32 gpio pins for each of the 6 GPIO controllers? Either BG2Q is a GPIO

Yes, BG2Q support 32 pins every port

> beast or it is a mistake :P
> 
> Can you please double-check?
> 
> I am fine with using nr-gpios property now, but I guess BG2Q also
> has that CONFIG[1,2] registers to actually read out the features
> synthesized in? If I find some time, I'll prepare a patch for
> dw-apb-gpio to exploit that (optional) information instead of
> using nr-gpios.

The problem is CONFIG1/2 registers don't exist on some versions.
For example, the version used in BG2/BG2CD. So nr-gpio is necessary
if we want to support these versions.

Thanks,
Jisheng

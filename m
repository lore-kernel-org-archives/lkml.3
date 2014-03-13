Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaCMLEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:04:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25582 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753764AbaCMLEJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:04:09 -0400
Date: Thu, 13 Mar 2014 19:02:06 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: dts: berlin2q: add the Marvell Armada 1500 pro
 (BG2Q) device tree
Message-ID: <20140313190206.762108a2@xhacker>
In-Reply-To: <20140313104303.GB4418@piout.net>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
	<1394622364-6848-2-git-send-email-antoine.tenart@free-electrons.com>
	<532182EB.7090002@gmail.com>
	<20140313104303.GB4418@piout.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-13_04:2014-03-13,2014-03-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1403130035
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 13 Mar 2014 03:43:03 -0700
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> On 13/03/2014 at 10:05:31 +0000, Sebastian Hesselbarth wrote :
> > On 03/12/2014 11:06 AM, Antoine Ténart wrote:
> > >+			compatible = "arm,cortex-a9-twd-timer";
> > >+			reg = <0xad0600 0x20>;
> > >+			clocks = <&sysclk>;
> > 
> > Playing with Chromecast, I remember local-timer running at sysclk/3 or

twdclk is running at cpuclk/3. 

On chromecast, freq of cpuclk is the same as sysclk. But parent of twdclk
is cpuclk.

> > something. I know berlin2/berlin2cd is wrong here. Can you check that
> > for berlin2q local-timer also runs at sysclk/n?
> > 
> 
> Actually, what we have is sysclk = cpuclk/3 so I guess it depends on
> what you call sysclk.
> 
> > >+			interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
> > >+			status = "okay";
> > >+		};
> > >+
> > >+		apb@e80000 {
> > >+			compatible = "simple-bus";
> > >+			#address-cells = <1>;
> > >+			#size-cells = <1>;
> > >+
> > >+			ranges = <0 0xe80000 0x10000>;
> > >+			interrupt-parent = <&aic>;
> > >+
> > >+			timer0: timer@2c00 {
> > >+				compatible = "snps,dw-apb-timer";
> > >+				reg = <0x2c00 0x14>;
> > >+				interrupts = <8>;
> > >+				clock-freq = <100000000>;
> > >+				status = "okay";
> > >+			};
> > >+
> > >+			timer1: timer@2c14 {
> > >+				compatible = "snps,dw-apb-timer";
> > >+				reg = <0x2c14 0x14>;
> > >+				clock-freq = <100000000>;
> > >+				status = "disabled";
> > >+			};
> > 
> > berlin2/berlin2cd have a vast amount of 8 apb timers. Any timers missing
> > here or did Marvell remove them?

We still have 8 apb timers

> > 
> > 
> > Also for uart, can you please double-check if there is no uart2?
> > 
> 
> We don't have those informations, maybe Jisheng can help ?

uart2 is removed

Thanks,
Jisheng 


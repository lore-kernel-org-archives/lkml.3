Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbaDGTCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:02:37 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:12387 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbaDGTCc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:02:32 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh936eI1432I4015Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Mon, 7 Apr 2014 12:00:05 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Harini Katakam <harinik@xilinx.com>, Mark Rutland <mark.rutland@arm.com>,
        <gnurou@gmail.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, <linux-doc@vger.kernel.org>,
        <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <michals@xilinx.com>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] GPIO: Add driver for Zynq GPIO controller
References: <1395933906-2268-1-git-send-email-harinik@xilinx.com>
 <CAPDyKFo4R9izP=jcoU+jqd74Nbeh+-5A1T8c_=EL4cmzja_29A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAPDyKFo4R9izP=jcoU+jqd74Nbeh+-5A1T8c_=EL4cmzja_29A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <7da0486b-bbdd-445b-8a6d-b5bcb311d908@TX2EHSMHS036.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 11:23AM +0200, Ulf Hansson wrote:
> On 27 March 2014 16:25, Harini Katakam <harinik@xilinx.com> wrote:
[...]
> > +static int __maybe_unused zynq_gpio_runtime_suspend(struct device *dev)
> > +{
> > +       struct platform_device *pdev = to_platform_device(dev);
> > +       struct zynq_gpio *gpio = platform_get_drvdata(pdev);
> > +
> > +       clk_disable(gpio->clk);
> 
> You should be able can use clk_disable_unprepare() here.
> 
> > +
> > +       return 0;
> > +}
> > +
> > +static int __maybe_unused zynq_gpio_runtime_resume(struct device *dev)
> > +{
> > +       struct platform_device *pdev = to_platform_device(dev);
> > +       struct zynq_gpio *gpio = platform_get_drvdata(pdev);
> > +
> > +       return clk_enable(gpio->clk);
> 
> You should be able can use clk_prepare_enable() here.

Is there some common practice regarding this? As I understand it, we
want to ensure the clock to be gated during suspend, which should happen
with clk_disable(). Why would we also unprepare the clock? We are highly
likely to use it again once we resume.

	Thanks,
	Sören



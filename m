Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaGBMst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:48:49 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:52281 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaGBMsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:48:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Rob Herring <robherring2@gmail.com>,
        jackp@codeaurora.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Kumar Gala <galak@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [Patch v7 3/3] usb: dwc3: qcom: Add device tree binding
Date: Wed, 02 Jul 2014 14:48:17 +0200
Message-ID: <4545008.qD8N1qWmNz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404290605.3622.6.camel@iivanov-dev>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org> <CAL_JsqLjjDV50x5LCDeySvV0u4U1om-3KDkFHMd5WouC=eV8kw@mail.gmail.com> <1404290605.3622.6.camel@iivanov-dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Aenfvyb+C4lcMJ3EQWEa7fBmAfZaXDALSF47++pRqz8
 XjFN12vKv3sNBkkh/XLNy8QEcsNEyXWONS2jzxJOaNn8mopXZt
 mtF4kN5sx3IBWqBWDg0KDDtJ4RV8xWZKWgkhgW+WLUXWXnvXBo
 n3YZz3waJ808psPUhcMg+sfuBxVQwSc049C/fdGcr/UcKtIu7L
 GDX8JZZou+xsFuXfSAIi48xPCIRw+h0EpreHbkfyC10g9bk6zG
 Jddy3HwH7Zaybau63BPViUkr2QWM4JWVufeFWU8OyZP2EIowjn
 wC0nnTbne4E3a/k5nRi8qK7HNByiyffWF5aALcyQKxpUuUsC7n
 /+trzGVaLTwMIVH4vsbM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2014 11:43:25 Ivan T. Ivanov wrote:
> > > <snip>
> > >
> > >> > +
> > >> > +                       ranges;
> > >> > +
> > >> > +                       status = "disabled";
> > >> > +
> > >> > +                       dwc3@11000000 {
> > >> > +                               compatible = "snps,dwc3";
> > >>
> > >> This sub-node is just wrong. Why can't you have a single node with '
> > >> "qcom,dwc3", "snps,dwc3" ' for the compatible property? All you are
> > >> adding here is clocks. Does the Synopsys block have no clocks?
> > >>
> > >> I guess this is copied from other broken dwc3 bindings... That doesn't
> > >> mean you have to copy it.
> > >
> > > The dwc3 core does not deal with clocks.  That is why everyone has a wrapper.
> > > That, in addition to pm, has to be handled from the wrapper.  That's my take
> > > anyway.  I am sure Felipe can speak more to this.
> > 
> > That is a Linux driver issue which is irrelevant to the binding.
> 
> DWC3 IP core from Synopsys is the same across SoC's (OMAP, Exynos..),
> vendors are adding glue IP to provide necessary clocks and voltages. 
> I think that the DT bindings properly reflect this fact.

Not really. The proper way to do this is to have a single node that
lists multiple compatible strings from the most specific (per SoC variant)
to most generic (the underlying IP core) and have all properties in it.

We have seen many cases before where it later turned out that whatever
feature people thought was SoC specific actually was common to all
of them and that we later want to change the code to handle it in a
common way, and to reflect it in the common binding. The clocks that
Rob mentioned are one example of that.

If you have a binding that separates one IP block into two device nodes,
you cannot later adapt the common driver to be more generic and handle
all sorts of SoCs. See the usb-ehci.txt for an example: it started out
really simple but the generic driver has been extended multiple times
to the point where it handles a lot of SoCs by default.

	Arnd

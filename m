Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbaJaWcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:32:51 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61934 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751541AbaJaWcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:32:50 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Rob Herring <robherring2@gmail.com>
Cc: Gilad Avidov <gavidov@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/1] Compact interface for Device-Tree
Date: Fri, 31 Oct 2014 23:53:28 +0100
Message-ID: <7637604.7PK9W8ePf3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqLtkiiyisxSG_qBknmz6n2qDKUdpwM-ZY3tH3wgYSrO1w@mail.gmail.com>
References: <1414709964-27284-1-git-send-email-gavidov@codeaurora.org> <CAL_JsqLtkiiyisxSG_qBknmz6n2qDKUdpwM-ZY3tH3wgYSrO1w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 01, 2014 05:13:45 AM Rob Herring wrote:
> On Fri, Oct 31, 2014 at 6:59 AM, Gilad Avidov <gavidov@codeaurora.org> wrote:
> >
> > Device-Tree compact API
> > ------------------------
> >
> > Common code seen in driver’s probe reads device tree values and handling
> > erroneous return codes from all those of_property_read_xxx()  APIs. This
> > common code is factored out by the of_property_map module which allows
> > driver’s probe to replace that (often lengthy) code with a concise table:
> >
> > struct of_prop_map map[] = {
> >     {"i2c",            &dev->id,        OF_REQ,  OF_ID,  -1},
> >     {"qcom,clk-freq-out",    &dev->clk_freq_out,    OF_REQ,  OF_U32,  0},
> >     {"qcom,clk-freq-in",    &dev->clk_freq_in,    OF_REQ,  OF_U32,  0},
> >     {"qcom,disable-dma",    &dev->disable_dma,    OF_OPT,  OF_BOOL, 0},
> >     {"qcom,master-id",    &dev->mstr_id,        OF_SGST, OF_U32,  0},
> >     {NULL,            NULL,            0,       0,       0},
> > };
> >
> > Then call populate to read the values into the device’s variables:
> >
> > ret = of_prop_populate(dev, dev->of_node, map);
> 
> Interesting idea. The main concern I have with this is there has been
> on-going discussions about how to generalize property handling across
> DT and ACPI to make drivers more agnostic, so I'm copying a few folks
> involved in that. That may be a bit orthogonal to what this is doing,
> but we may want some coordination here.

Agreed.

We actually have a patchset adding a unified device property API in linux-next (http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=device-properties)
and I'd prefer to see the "compactization" to happen at that level, if possible,
rather that for of_ only.

Rafael


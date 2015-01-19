Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbbASPU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:20:26 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:57152 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbASPUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:20:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Minghuan Lian <Minghuan.Lian@freescale.com>,
        Magnus Damm <damm@opensource.se>, Will Deacon <will.deacon@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Sachin Kamat <sachin.kamat@samsung.com>, Andrew Lunn <andrew@lunn.ch>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Srikanth Thokala <sthokal@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>, linux-pci@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/5] PCI: designware: Add setup bus-related to pcie_host_ops
Date: Mon, 19 Jan 2015 14:54:26 +0100
Message-ID: <6696411.b9yjvPTFJo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAG374jBZCn+V2zjcAwdKEb0COzBT2VES5uiw0gc40mFvoraERA@mail.gmail.com>
References: <1418812486-12394-1-git-send-email-gabriel.fernandez@linaro.org> <000e01d01a7f$47592e20$d60b8a60$%han@samsung.com> <CAG374jBZCn+V2zjcAwdKEb0COzBT2VES5uiw0gc40mFvoraERA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:BQPsijKpCDzymso+/XWy8RA6Jh1nO1O8utEmE91Bud7qj0f8WKm
 3PrjN69w85GVSQttMvPKWwGK2mJCN/qOq7JMZ9eUUx5keki3ieYuiarLzS2kY1Y6OduhnCx
 WKkQaE2TY0AkQRoJmnZxNSqbg+MHjQCQCZjvJCAWFI+jrprQnIq1bm1CYQoH7p+RaAzrG2a
 yBPyITMnvA2a9QF2cx//w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2015 13:38:53 Gabriel Fernandez wrote:
> 
> On 18 December 2014 at 05:58, Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > On Thursday, December 18, 2014 7:16 AM, Arnd Bergmann wrote:
> > > On Wednesday 17 December 2014 11:34:45 Gabriel FERNANDEZ wrote:
> > > > ST sti SoCs PCIe IPs are built around DesignWare IP Core.
> > > > But in these SoCs PCIe IP doesn't support IO.
> > I cannot understand how ST sti SoCs PCIe IP does not support I/O.
> > As far as I know, it cannot be selected by the 'parameter'.
> > Then, H/W engineers dropped out the I/O control logic?
> >
> > > >
> > > > To support this, add setup_bus() to pcie_host_ops.
> >
> >
> > > >
> > > > Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
> > > > Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> > >
> > > The dw-pcie driver should be able to tell whether the device has
> > > an I/O space or not, and do the right thing based on that. Don't
> > > add an implementation specific callback for that.
> >
> > I agree with Arnd's opinion.
> >
> > In addition, I have one more question.
> > Then, if a device that requires I/O region is connected to
> > PCIe slot of ST sti SoCs PCIe, what will happen?
> > It just prints error messages?
> >
> >
> Arnd i
> n other post mention to add an empty I/O space to workaround lack of I/O
> port access.
> Is it the right thing to do ?
> ​
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/299623.html
> 

Good question. Given the latest development, I'd feel tempted to
try moving the entire pcie-designware driver to use the generic probing
that bypassses pci_common_init_dev(). Rob Herring posted a patch
for the versatile PCI driver, you could try doing the same thing
here, see http://permalink.gmane.org/gmane.linux.kernel.pci/30346.

I think that would completely avoid this problem, and also help everyone
that wants to use this driver on arm64.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaCOI7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 04:59:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:54388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaCOI7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 04:59:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Subject: Re: [PATCH v4 2/4] arm64: dts: APM X-Gene PCIe device tree nodes
Date: Sat, 15 Mar 2014 09:58:52 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches <patches@apm.com>,
        Jon Masters <jcm@redhat.com>
References: <1394085963-27553-1-git-send-email-tinamdar@apm.com> <201403141307.23286.arnd@arndb.de> <CACoXjc=t1SuyE5jzHjGk7eNUjVCNW9_iqOTru8PQ191h=pP1sw@mail.gmail.com>
In-Reply-To: <CACoXjc=t1SuyE5jzHjGk7eNUjVCNW9_iqOTru8PQ191h=pP1sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201403150958.52419.arnd@arndb.de>
X-Provags-ID: V02:K0:2coOHjteDzIHjXFXFI7UKAqVEon+CTVn+whhEtSKpR6
 PnB/Fak/2fmZIFRsp2U0063FgIQX5t7Kmnpd3AufS2tT0rkywI
 c1VnwEZfoHDD/HNxwbQyAYWKXZT2634yg5izKMHAIv3QP/rwjt
 qPGxttvRC17QYRYmyDyS9j+bzRdOsteV/LJ69JhF3LAmWwZ7We
 /ttU4C5j9Q4xmHT1azBcDf1c+TJSfwvfsgbrvdKpkh6/Wsarud
 x6+0ZTRs3SFJ05T5HTYF0d4PiLse7sxD10sTK95wTacME7480v
 gsOqPpus12KNc+G0oVPpwugzJt5c7CnfQSA1rrYjPbfhvZ+qsB
 IkkO1bWTR0RX3vwqTKSJuMJYJLytA3FYgPrEJLrZk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2014, Tanmay Inamdar wrote:
> On Fri, Mar 14, 2014 at 5:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 06 March 2014, Tanmay Inamdar wrote:
> >> +             pcie0: pcie@1f2b0000 {
> >> +                     status = "disabled";
> >> +                     device_type = "pci";
> >> +                     compatible = "apm,xgene-storm-pcie", "apm,xgene-pcie";
> >> +                     #interrupt-cells = <1>;
> >> +                     #size-cells = <2>;
> >> +                     #address-cells = <3>;
> >> +                     reg = < 0x00 0x1f2b0000 0x0 0x00010000   /* Controller registers */
> >> +                             0xe0 0xd0000000 0x0 0x00200000>; /* PCI config space */
> >> +                     reg-names = "csr", "cfg";
> >> +                     ranges = <0x01000000 0x00 0x00000000 0xe0 0x00000000 0x00 0x00010000   /* io */
> >> +                               0x02000000 0x00 0x10000000 0xe0 0x10000000 0x00 0x80000000>; /* mem */
> >> +                     dma-ranges = <0x42000000 0x40 0x00000000 0x40 0x00000000 0x40 0x00000000>;
> >> +                     interrupt-map-mask = <0x0 0x0 0x0 0x7>;
> >> +                     interrupt-map = <0x0 0x0 0x0 0x1 &gic 0x0 0xc2 0x1
> >> +                                      0x0 0x0 0x0 0x2 &gic 0x0 0xc3 0x1
> >> +                                      0x0 0x0 0x0 0x3 &gic 0x0 0xc4 0x1
> >> +                                      0x0 0x0 0x0 0x4 &gic 0x0 0xc5 0x1>;
> >> +                     clocks = <&pcie0clk 0>;
> >> +             };
> >
> > Is 0x40.0x00000000 the start of your RAM? I had expected RAM to start at 0.0,
> > and in that case the dma-ranges property would be wrong.
> 
> RAM starting address is 0x40_00000000.

Ok, it's good then. Thanks for the clarification, I keep losing track of how each of
the ~40 SoCs I'm dealing with handles these things.

	Arnd

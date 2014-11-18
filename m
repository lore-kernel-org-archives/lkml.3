Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaKRNMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:12:02 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:57902 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbaKRNMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:12:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ankit Jindal <ankit.jindal@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anup Patel <anup@brainfault.org>, Guenter Roeck <linux@roeck-us.net>,
        "patches@apm.com" <patches@apm.com>, Rob Herring <robh+dt@kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Subject: Re: [PATCH v5 5/6] Documentation: dt-bindings: Add binding info for X-Gene QMTM UIO driver
Date: Tue, 18 Nov 2014 14:10:35 +0100
Message-ID: <1503477.DVdkExccIe@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPTm99WYNyxtY-NCVN8pB0HwNPn+EFx-7w7yEevaEK1z7-Zqxg@mail.gmail.com>
References: <1416220572-13381-1-git-send-email-ankit.jindal@linaro.org> <2279061.naADrHDgyn@wuerfel> <CAPTm99WYNyxtY-NCVN8pB0HwNPn+EFx-7w7yEevaEK1z7-Zqxg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yT40mKDhuQkmtA4kFpwB05kThnrWaLc7xlaObydnmRA
 TrKPD1Hgz5LXQIF80lhFBd0pshxAHLd64XRz3/8jUgBU1o3YA3
 Bw1EorFWcqaKSGdg7pPcjjVT27Yr1sMYgbXcd3CFsEkHEhCCa5
 dl1K8A+YWR9oS7phPrGMucVtiyNOWwH7vcBzTcGHOBDsoqIBlK
 AreZZOsZ0wLvYZYHFJIDwXAGIdBpnZ2hrgMBc02kPGzhynxR4f
 NhB4vP5F75lNm0t9rhGjttvwM0BNWyamOGuB202GdGwlx0qndK
 OXVs8n5kEnCV3niDEffNUBzsuDXDtrRv6efN9xBuW6oeA6Iz0x
 FReT+nvmOF9tvGyNzixU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2014 14:59:54 Ankit Jindal wrote:
> On 17 November 2014 16:47, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 17 November 2014 16:06:11 Ankit Jindal wrote:
> >> +
> >> +       qmtm1_uio: qmtm_uio@1f200000 {
> >> +               compatible = "apm,xgene-qmtm";
> >> +               status = "disabled";
> >> +               reg = <0x0 0x1f200000 0x0 0x10000>,
> >> +                     <0x0 0x1b000000 0x0 0x400000>;
> >> +               reg-names = "csr", "fabric";
> >> +               qpool-memory = <&qmtm1_uio_qpool>;
> >> +               clocks = <&qmtm1clk 0>;
> >> +               num-queues = <0x400>;
> >> +               devid = <1>;
> >> +       };
> >> +
> >
> > To make my previous review comments clearer:
> >
> > NAK
> >
> > Do not create device nodes that are meant for a specific use case in
> > software and that are not usable for the common case. I don't think
> > it makes any sense to keep on submitting a UIO driver for this until
> > we have a proper network driver that uses this so we can make sure we
> > have a working binding.
> 
> The dataplane frameworks like OpenDataPlane etc, need to have access
> to complete subsystem from the user space. Hence, we would like to
> have this driver and some other UIO drivers to be the part of kernel
> to have data plane frameworks working on our platform.

Please work with the people that do the in-kernel QMTM driver to come
up with a common binding then.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaJFSo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:44:56 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:52520 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaJFSox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:44:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        mark.rutland@arm.com, graeme.gregory@linaro.org, marc.zyngier@arm.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org, astone@redhat.com,
        grant.likely@linaro.org, hanjun.guo@linaro.org, Sudeep.Holla@arm.com,
        olof@lixom.net, jason@lakedaemon.net, "Duran, Leo" <leo.duran@amd.com>,
        Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH 1/4] ata: ahci_platform: Add ACPI support for AMD Seattle SATA controller
Date: Mon, 06 Oct 2014 20:44:35 +0200
Message-ID: <2046349.jdtgG25KJR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141006182153.GA31521@srcf.ucam.org>
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com> <2026795.jAP8HDLAZo@wuerfel> <20141006182153.GA31521@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OV1F199sOsDxV8SMGrOQTQg+jNbSAT0ZAKWUkAohkDL
 IPIufzEeaYBuAM8GF8H7VgXCMjWeaqQ46jQ6K7ObXBB1+S5A4D
 ydxeWnFUIRbzp+vFd5Edd3pGWTPaXNPdtq5YTcAelS7cSLtVN7
 FxuSihs4cNGgKog7YplcSeNk+psJwr8tivSLI1+o3O2OuICzRS
 tyEgF8HwEtwsbU4Mm/5JHzMcVHtj8nTVqucJrLHJiJudSi26Jg
 YdUhXnBk32ycrNA15OyQPltcOGEPCkON6GQtGbOAAJa65niXYJ
 vMsB617fPuHEjM2pU/DC8xfLMAFnHIdhhhdxMkCnEkfrKkKnHk
 Xb1Wbq2+CJl5He2XIANQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 October 2014 19:21:53 Matthew Garrett wrote:
> On Mon, Oct 06, 2014 at 08:19:37PM +0200, Arnd Bergmann wrote:
> 
> > Interesting. Does this also define a way to get access to registers
> > that are normally in PCI config space, provided they are accessible at
> > all?
> 
> Unfortunately not. I'd assume that PM registers are expected to be 
> accessed via the _PS* methods instead. Does MSI make sense outside the 
> context of PCI interrupts?

Yes, the ARM GIC has a weird sense of what MSI is used for, and
apparently some SoC vendors have started using MSI by default for
all on-chip peripherals.

A patch series to extend MSI to platform devices is currently
under review.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965666AbaKNOyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:54:21 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:49815 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965012AbaKNOyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:54:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-acpi@lists.linaro.org
Cc: Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        linux-arm-kernel@lists.infradead.org, rjw@rjwysocki.net,
        linux-pci@vger.kernel.org, catalin.marinas@arm.com, x86@kernel.org,
        Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com,
        linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de
Subject: Re: [Linaro-acpi] [RFC PATCH 4/4] arm64, acpi, pci: Provide arch-specific calls for PCI host bridge dirver (PNP0A03).
Date: Fri, 14 Nov 2014 15:53:35 +0100
Message-ID: <2009440.GJsvyI3SUN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54660D44.9020406@linaro.org>
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org> <4474363.kMvYSLl2Ev@wuerfel> <54660D44.9020406@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LYf4ELaU6Ot/o4YFnAQjrJMX5j/AwtrHGI84dn33RLH
 suMWRV/RiDAcTGvlOlrmU51EpQnczz9e378cM47UXnQ52NWEI+
 qk7m0CtAdFJC5jpaDfsbJKO//SNjaqAbtkLX87M8DnNWoXOIQ2
 lRHkRS6r9V/BgyE2T6uRg0PaqEG1+KXs/BE2Ppc0Uv9avtYR9u
 9YppRim5TkaqcTJRhWep3+gMrVsdWQlJg+Y8RW4H/TVUCNMQpR
 kNM/X8f3JGEO4n+QHpYKScgCyjJvzJPH/hFrjR0+84pw8dePFE
 bXiLKrVuOJED1mxM2BVB0MtWJ1kiL5iMxicoaggt/0ys3gK3VS
 9YCzLKdBBryv3WI3U2kI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014 15:10:12 Tomasz Nowicki wrote:
> On 07.11.2014 15:24, Arnd Bergmann wrote:
> > On Friday 07 November 2014 14:27:56 Tomasz Nowicki wrote:
> >>
> >>   #ifdef CONFIG_PCI
> >> +struct pci_controller {
> >> +	struct acpi_device *companion;
> >> +	int segment;
> >> +	int node;		/* nearest node with memory or NUMA_NO_NODE for global allocation */
> >> +};
> >> +
> >> +#define PCI_CONTROLLER(busdev) ((struct pci_controller *) busdev->sysdata)
> >> +
> >
> > Don't use busdev->sysdata in architecture specific code, it belongs to the
> > host bridge driver with the new model. For ACPI you don't have a host bridge
> > driver, but it's better to keep these separate.
> >
> > The segment is always the same as the domain number, so just use that.
> > The node and companion members here can get added to struct pci_host_bridge.
> 
> The reason why I put segment field to struct pci_controller is to 
> initialize domain_nr of struct pci_bus being in pci_create_root_bus(), 
> domain_nr can be used later on though. Correct me I am wrong.
> 
> Honestly I do not see the way to create root bus without e.g. 
> sysdata.segment here.

See the patches that Liviu and Lorenzo have been posting recently. This
should be straightforward in 3.19.

	Arnd

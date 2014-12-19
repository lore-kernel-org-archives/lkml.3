Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaLSCFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:05:49 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50058 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751614AbaLSCFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:05:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kevin Hilman <khilman@kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Heiko Stuebner <heiko@sntech.de>,
        Joerg Roedel <joro@8bytes.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [RFC PATCH 2/2] iommu: rockchip: Handle system-wide and runtime PM
Date: Fri, 19 Dec 2014 03:27:35 +0100
Message-ID: <8712967.RZO6JKCTcJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1649547.QECLmuJenN@avalon>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org> <7hppbg7j9r.fsf@deeprootsystems.com> <1649547.QECLmuJenN@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 18, 2014 11:28:58 PM Laurent Pinchart wrote:
> Hi Kevin,
> 

[cut]

> > >> 
> > >> It would be better to be able to reference count the DMA engine from the
> > >> bus master IMO and arguably you can use the runtime PM framework for
> > >> that. Namely, give bus masters someting like
> > >> 
> > >> 	pm_runtime_get_my_DMA_engine(bus_master_device)
> > >> 	pm_runtime_put_my_DMA_engine(bus_master_device)
> > >> 
> > >> and let them call these as they see fit.
> > > 
> > > Please note that we're not talking about DMA engines here, but about
> > > IOMMUs. DMA is involved through the DMA mapping API which hides the IOMMU
> > > completely from the bus master drivers, not the DMA engine API.
> > > 
> > > Exposing the IOMMU is something we want to avoid, but DMA mapping
> > > start/stop operations could certainly be implemented.
> > 
> > The problem with that is it only solves the IOMMU problem.  We have a
> > more generic PM dependency problem of which this IOMMU example is only a
> > subset, so I think we need a more generic solution.
> 
> I agree that a more generic solution is needed at least to support ACPI _DEP, 
> but that might not be optimal in the IOMMU use case as explained above.

Well, since we need it anyway, why don't we implement it and then figure out
if anything more specific needs to be done for the IOMMU case?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

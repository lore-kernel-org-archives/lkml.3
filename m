Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbaGKPIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:08:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36363 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaGKPIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:08:30 -0400
Date: Fri, 11 Jul 2014 16:08:23 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 6/9] pci: Introduce a domain number for
 pci_host_bridge.
Message-ID: <20140711150823.GU6501@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-7-git-send-email-Liviu.Dudau@arm.com>
 <20140708005954.GC22939@google.com>
 <20140708104655.GC6501@e106497-lin.cambridge.arm.com>
 <CAErSpo75ovmGoeSHKJN0nckGDy-0gpn8kLPfHQ79CtcXxhPydw@mail.gmail.com>
 <20140708224847.GC4980@e106497-lin.cambridge.arm.com>
 <CAErSpo5rBt0iF2HGeDD-UH6_sPCoC647VCw0Q1v_0Rdpvcir-w@mail.gmail.com>
 <20140710094758.GA6501@e106497-lin.cambridge.arm.com>
 <CAErSpo5ZNCY31NztT0cLFbRVsBZqMsZ0LbTFNOTQCZUU3F7qJA@mail.gmail.com>
 <20140711141115.GB16321@arm.com>
MIME-Version: 1.0
In-Reply-To: <20140711141115.GB16321@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 11 Jul 2014 15:08:24.0252 (UTC) FILETIME=[F5E9D7C0:01CF9D19]
X-MC-Unique: 114071116082703601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 03:11:16PM +0100, Catalin Marinas wrote:
> On Thu, Jul 10, 2014 at 11:36:10PM +0100, Bjorn Helgaas wrote:
> > Most of the rest of the v7 discussion was about "Introduce a domain
> > number for pci_host_bridge."  I think we should add arm64 using the
> > existing pci_scan_root_bus() and keep the domain number in the arm64
> > sysdata structure like every other arch does.  Isn't that feasible?
> > We can worry about domain unification later.
> 
> I think that's what we were trying to avoid, adding an arm64-specific
> pci_sys_data structure (and arm64-specific API). IIUC, avoiding this
> would allow the host controller drivers to use the sysdata pointer for
> their own private data structures.
> 
> Also since you can specify the domain number via DT (and in Liviu's
> v8 patches read by of_create_pci_host_bridge), I think it would make
> sense to have it stored in some generic data structures (e.g.
> pci_host_bridge) rather than in an arm64 private sysdata.
> 
> (Liviu is thinking of an alternative API but maybe he could briefly
> describe it here before posting a new series)
> 
> -- 
> Catalin


My plan is to keep the domain number in the pci_host_bridge and split
the creation of the pci_host_bridge out of the pci_create_root_bus().
The new function (tentatively called pci_create_new_root_bus()) will
no longer call pci_alloc_host_bridge() but will accept it as a
parameter, allowing one to be able to set the domain_nr ahead of the
root bus creation.

Best regards,
Liviu

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯


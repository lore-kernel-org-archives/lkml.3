Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbaDPVVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:21:22 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:60955 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbaDPVVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:21:20 -0400
Date: Wed, 16 Apr 2014 15:21:04 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Rob Herring <robherring2@gmail.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>
Subject: Re: [PATCH v5 2/4] arm64: dts: APM X-Gene PCIe device tree nodes
Message-ID: <20140416212104.GA3469@obsidianresearch.com>
References: <1395270762-6055-1-git-send-email-tinamdar@apm.com>
 <1395270762-6055-3-git-send-email-tinamdar@apm.com>
 <CAL_Jsq+XxAtUeNKFi0hH=ehb_fhFvkM0U1Zm_j1LdtQZbvSzfA@mail.gmail.com>
 <20140416170545.GD4858@bart>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416170545.GD4858@bart>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 06:05:45PM +0100, Liviu Dudau wrote:

> I have found out that we cannot pasd the config ranges from the DT into the
> pci_host_bridge structure as the PCI framework doesn't have a resource type
> for config resources. Leaving the translation between range flags and
> resource type as is (filtered through the IORESOURCE_TYPE_BITS) will lead
> to a resource type of value zero, which is not recognised by any resource
> handling API so bridge configuration and bus scanning will barf.
> 
> I'm looking for suggestions here, as Jason Gunthorpe suggested that we
> should be able to parse config ranges if they conform to the ECAM part
> of the PCI standard.

The thinking here is the ranges should be well defined and general, it
isn't a dumping ground for driver specific stuff.

No spec says you can put config space into the ranges at all, nobody
should be doing that today, obviously some cases were missed during
review..

The comment about ECAM was intended as a general guidance on what
config space in ranges could/should be used for.

Right now config space shouldn't propagate out side any driver, so you
can probably just filter it in your generic code, and make it very hard
and obviously wrong for a driver to parse ranges for config space, so
we don't get more usages.

Jason

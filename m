Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbaCEA1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:27:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53117 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbaCEA1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:27:05 -0500
Date: Wed, 5 Mar 2014 00:26:59 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware
 (testers needed)
Message-ID: <20140305002659.GA25643@srcf.ucam.org>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
 <20131202162938.GA11241@srcf.ucam.org>
 <20140304000904.GA6623@srcf.ucam.org>
 <CAMxnaaVEg5ohZwopnDdMfoDseQy4Xoqbm-J3BzOcxDS=HVQN2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMxnaaVEg5ohZwopnDdMfoDseQy4Xoqbm-J3BzOcxDS=HVQN2w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 12:59:54AM +0100, Andreas Noever wrote:

> 
> I belive that the patch has the same effect as passing
>     acpi_osi=! acpi_osi=Darwin
> to the kernel. The problem with that approach is that it changes the
> firmware behaviour quite a lot. In particular it prevents Linux from
> taking over pci hotplug control:

There's not really any way around this. The method to power up the chip 
will refuse to run unless the system claims Darwin and nothing else.

> I would prefer to find a solution that boots without acpi_osi=Darwin
> as seems to trigger quite a lot of ACPI code. My current approach is
> to inject a custom OSDW method somewhere into the NHI namespace and to
> replace _PTS and _WAK from my driver. I can then wake the controller
> with the XRPE method. The last problem is that the PCI code does not
> allocate enough (or any) bus numbers below the hotplug ports. I'm
> trying to add some quirks to it but the code is not really made for
> that...

I don't think that's a workable approach - any change in the firmware 
implementation could break it. If we're going to insert quirks then I 
think it makes more sense to do it in the PCI layer rather than 
injecting things into ACPI.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

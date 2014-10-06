Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaJFQcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:32:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52123 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaJFQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:32:04 -0400
Date: Mon, 6 Oct 2014 17:31:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        mark.rutland@arm.com, graeme.gregory@linaro.org, marc.zyngier@arm.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org, astone@redhat.com,
        grant.likely@linaro.org, hanjun.guo@linaro.org, Sudeep.Holla@arm.com,
        olof@lixom.net, jason@lakedaemon.net, "Duran, Leo" <leo.duran@amd.com>,
        Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH 1/4] ata: ahci_platform: Add ACPI support for AMD Seattle
 SATA controller
Message-ID: <20141006163147.GA22482@srcf.ucam.org>
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20140917012614.GA31214@srcf.ucam.org>
 <542C6FE9.10903@amd.com>
 <4872185.h11DQxW6kP@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4872185.h11DQxW6kP@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 10:39:18AM +0200, Arnd Bergmann wrote:

> I think part of the problem is that there is no specification for what
> an AHCI device should look like when it's not connected to a PCI
> bus, the AHCI document published by Intel just states:

One thing that has come out of further discussion on this - ACPI defines 
a _CLS object, which allows ACPI devices to declare compatibility with a 
PCI class device. We don't have support for it at the moment, but it 
would be easy enough to add this to the kernel and then just expose the 
AHCI PCI class via _CLS. That would avoid us having problems with people 
doing similar things with USB hosts.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

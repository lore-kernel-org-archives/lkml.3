Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaBMLxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:53:38 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34917 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753199AbaBMLxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:53:36 -0500
Date: Thu, 13 Feb 2014 11:53:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org, devicetree@vger.kernel.org,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge
	from device tree
Message-ID: <20140213115327.GV26684@n2100.arm.linux.org.uk>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com> <CACoXjc=epN8=tFQKw6kZ27hTA=a+c56q1pikX_SSMKK1rsScCw@mail.gmail.com> <000001cf2899$a6eb75b0$f4c26110$%han@samsung.com> <3204351.WykFFcX4zJ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3204351.WykFFcX4zJ@wuerfel>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 12:27:05PM +0100, Arnd Bergmann wrote:
> I would rather get rid of struct hw_pci for architecture independent
> drivers and add a different registration method on arm32 that is
> compatible with what we come up with on arm64. The main purpose of
> hw_pci is to allow multiple PCI controllers to be initialized at
> once, but we don't actually need that for any of the "modern" platforms
> where we already have a probe function that gets called once for
> each controller.

No.  The main purpose of hw_pci is as a container to support multiple
different platform specific PCI implementations in one kernel.  It's
exactly what you need for single zImage.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".

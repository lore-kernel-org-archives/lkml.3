Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3C1OvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:51:15 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:45644 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3C1OvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:51:14 -0400
Date: Thu, 28 Mar 2013 10:51:11 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
In-Reply-To: <alpine.DEB.2.02.1303281225050.4430@kaball.uk.xensource.com>
Message-ID: <alpine.LFD.2.03.1303281048060.1372@syhkavp.arg>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com> <20130327172306.GB20990@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1303281225050.4430@kaball.uk.xensource.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013, Stefano Stabellini wrote:

> - the interface to bring up secondary cpus is different and based on
> PSCI, in fact Xen is going to add a PSCI node to the device tree so that
> Dom0 can use it.
> 
> Oh wait, Dom0 is not going to use the PSCI interface even if the node is
> present on device tree because it's going to prefer the platform smp_ops
> instead.

Waitaminute...  I must have missed this part.

Who said platform specific methods must be used in preference to PSCI?

If DT does provide PSCI description, then PSCI should be used.  Doing 
otherwise is senseless.  If PSCI is not to be used, then it should not 
be present in DT.


Nicolas

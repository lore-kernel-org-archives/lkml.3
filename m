Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162004Ab3DEQWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:22:10 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:46417 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161938Ab3DEQWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:22:09 -0400
Date: Fri, 5 Apr 2013 12:22:05 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com,
        arnd@arndb.de, rob.herring@calxeda.com
Subject: Re: [PATCH v6 4/4] xen/arm: introduce xen_early_init, use PSCI on
 xen
In-Reply-To: <1365167495-18508-4-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.LFD.2.03.1304051217560.1171@syhkavp.arg>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-4-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Apr 2013, Stefano Stabellini wrote:

> Split xen_guest_init in two functions, one of them (xen_early_init) is
> going to be called very early from setup_arch.
> 
> Change machine_desc->smp_init to xen_smp_init if Xen is present on the
> platform. xen_smp_init just sets smp_ops to psci_smp_ops.

I still think the above is redundant, especially since psci_smp_ops has 
priority over default mdesc->smp_ops.  And doing so does break MCPM. But 
we're apparently going in circle over this issue.


Nicolas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaAPTgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:36:11 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43801 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbaAPTgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:36:09 -0500
Date: Thu, 16 Jan 2014 19:31:23 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gang.chen@asianux.com" <gang.chen@asianux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaccon.bastiaansen@gmail.com" <jaccon.bastiaansen@gmail.com>
Subject: Re: [PATCH v3] arm: remove !CPU_V6 and !GENERIC_ATOMIC64 build
 dependencies for XEN
Message-ID: <20140116193123.GB22105@mudshark.cambridge.arm.com>
References: <1389204023-26912-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <20140109103004.GB11089@mudshark.cambridge.arm.com>
 <201401091204.17932.arnd@arndb.de>
 <alpine.DEB.2.02.1401091247000.21510@kaball.uk.xensource.com>
 <20140109184251.GL17838@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1401161622570.21510@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401161622570.21510@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On Thu, Jan 16, 2014 at 04:27:55PM +0000, Stefano Stabellini wrote:
> On Thu, 9 Jan 2014, Will Deacon wrote:
> > Ok, thanks for the explanation. Looking at the patch, I wonder whether it's
> > not cleaner just to implement xchg code separately for Xen? The Linux code
> > isn't always sufficient (due to the GENERIC_ATOMIC64 stuff) and most of the
> > churn coming out of this patch is an attempt to provide some small code
> > reuse at the cost of code readability.
> > 
> > What do others think?
> 
> I am OK with that, in fact my first version of the patch did just that:
> 
> http://marc.info/?l=linux-arm-kernel&m=138436406724990&w=2
> 
> Is that what you had in mind?

For the xchg part, yes, that looks a lot better. I don't like the #undef
CONFIG_CPU_V6 though, can that be rewritten to use __LINUX_ARM_ARCH__?

Will

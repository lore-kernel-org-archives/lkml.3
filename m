Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaAIKek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 05:34:40 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42293 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbaAIKed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 05:34:33 -0500
Date: Thu, 9 Jan 2014 10:30:05 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gang.chen@asianux.com" <gang.chen@asianux.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "jaccon.bastiaansen@gmail.com" <jaccon.bastiaansen@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arm: remove !CPU_V6 and !GENERIC_ATOMIC64 build
 dependencies for XEN
Message-ID: <20140109103004.GB11089@mudshark.cambridge.arm.com>
References: <1389204023-26912-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389204023-26912-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On Wed, Jan 08, 2014 at 06:00:23PM +0000, Stefano Stabellini wrote:
> Remove !GENERIC_ATOMIC64 build dependency:
> - rename atomic64_xchg to armv7_atomic64_xchg and define it even ifdef
>   GENERIC_ATOMIC64;
> - call armv7_atomic64_xchg directly from xen/events.h.
> 
> Remove !CPU_V6 build dependency:
> - introduce __cmpxchg8 and __cmpxchg16, compiled even ifdef
>   CONFIG_CPU_V6;
> - implement sync_cmpxchg using __cmpxchg8 and __cmpxchg16.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> CC: arnd@arndb.de
> CC: linux@arm.linux.org.uk
> CC: will.deacon@arm.com
> CC: gang.chen@asianux.com
> CC: catalin.marinas@arm.com
> CC: jaccon.bastiaansen@gmail.com
> CC: linux-arm-kernel@lists.infradead.org
> CC: linux-kernel@vger.kernel.org
> 

I'm confused here. It looks like you want to call armv7 code in a v6 kernel.
What am I missing?

Will

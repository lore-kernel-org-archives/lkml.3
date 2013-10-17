Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3JQIkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 04:40:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50088 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab3JQIka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:40:30 -0400
Date: Thu, 17 Oct 2013 10:40:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Chen Gong <gong.chen@linux.intel.com>, tony.luck@intel.com,
        naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com,
        arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
Message-ID: <20131017084014.GD5036@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
 <1381978749.22110.76.camel@joe-AO722>
 <20131017063059.GB14946@gchen.bj.intel.com>
 <1381993136.22110.95.camel@joe-AO722>
 <20131017073824.GC14946@gchen.bj.intel.com>
 <1381998750.22110.101.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381998750.22110.101.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 01:32:30AM -0700, Joe Perches wrote:
> On Thu, 2013-10-17 at 03:38 -0400, Chen Gong wrote:
> > the point is we can use GENMASK like GENMASK(end_bit, start_bit) but
> > we don't know the value of end_bit/start_bit at compile-time.
> 
> True.
> 
> The BUILD_BUG_ON idea is just to avoid people using
> 	GENMASK(1, 2)

They'll notice the 0 pretty quickly when they test their code.

Let's add those checks only when it is really necessary and people have
actually made that mistake repeatedly.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

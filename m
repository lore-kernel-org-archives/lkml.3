Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab3GXFDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 01:03:00 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:55616 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3GXFC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 01:02:58 -0400
Date: Wed, 24 Jul 2013 07:02:52 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: mfd: mfd-core: disable irq_domain related code
 when 'HAVE_GENERIC_HARDIRQS' disabled.
Message-ID: <20130724050252.GA4091@osiris>
References: <51EE3E20.1090101@asianux.com>
 <20130723104703.GB26775@osiris>
 <51EF1763.3020904@asianux.com>
 <51EF4AF0.1000509@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EF4AF0.1000509@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072404-0342-0000-0000-000005A9C069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:33:04AM +0800, Chen Gang wrote:
> 'irq_domain' depends on hard irqs, so for the architectures which have
> no hard irqs, but still need mfd (e.g. s390), need disable the related
> code, or can not pass compiling.
> 
> The related commit:
> 
>   "c94bb23 mfd: Make MFD core code Device Tree and IRQ domain aware"
> 
> The related error: (with allmodconfig under s390)
> 
>   ERROR: "irq_create_mapping" [drivers/mfd/mfd-core.ko] undefined!
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

s390 will have GENERIC_HARDIRQS soon (very likely next merge window),
so lets not add more GENERIC_HARDIRQS ifdefs in the code.


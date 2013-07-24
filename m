Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab3GXFcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 01:32:17 -0400
Received: from intranet.asianux.com ([58.214.24.6]:63540 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3GXFcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 01:32:16 -0400
X-Spam-Score: -100.8
Message-ID: <51EF66A4.6060704@asianux.com>
Date: Wed, 24 Jul 2013 13:31:16 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: sameo@linux.intel.com, lee.jones@linaro.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: mfd: mfd-core: disable irq_domain related code
 when 'HAVE_GENERIC_HARDIRQS' disabled.
References: <51EE3E20.1090101@asianux.com> <20130723104703.GB26775@osiris> <51EF1763.3020904@asianux.com> <51EF4AF0.1000509@asianux.com> <20130724050252.GA4091@osiris>
In-Reply-To: <20130724050252.GA4091@osiris>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 01:02 PM, Heiko Carstens wrote:
> On Wed, Jul 24, 2013 at 11:33:04AM +0800, Chen Gang wrote:
>> > 'irq_domain' depends on hard irqs, so for the architectures which have
>> > no hard irqs, but still need mfd (e.g. s390), need disable the related
>> > code, or can not pass compiling.
>> > 
>> > The related commit:
>> > 
>> >   "c94bb23 mfd: Make MFD core code Device Tree and IRQ domain aware"
>> > 
>> > The related error: (with allmodconfig under s390)
>> > 
>> >   ERROR: "irq_create_mapping" [drivers/mfd/mfd-core.ko] undefined!
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> s390 will have GENERIC_HARDIRQS soon (very likely next merge window),
> so lets not add more GENERIC_HARDIRQS ifdefs in the code.
> 

OK, thanks.

-- 
Chen Gang

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaDWXnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:43:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25527 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaDWXnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:43:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/zCu8XeDQi+gZdoQg1Lm2n
Date: Wed, 23 Apr 2014 16:43:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        thierry.reding@gmail.com, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 0/2] DT irq deferred probe support
Message-ID: <20140423234326.GF6053@atomide.com>
References: <1398293861-7682-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398293861-7682-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rob Herring <robherring2@gmail.com> [140423 15:58]:
> From: Rob Herring <robh@kernel.org>
> 
> This is atleast the 4th attempt to fix a long standing issue with DT 
> irq resolution needing to support deferred probe when irq parent is not 
> yet initialized. This version implements Russell King's suggestion to do 
> irq resolution when platform_get_irq is called. 
> 
> Tony, I squashed your warning fix (dropping the other part) and stole 
> much of your commit message. Let me know if you have any issues with 
> that.

Nope, looks good, just gave it a try and it fixes the problem for me.

Regards,

Tony
 
> Rob Herring (2):
>   of: selftest: add deferred probe interrupt test
>   of/irq: do irq resolution in platform_get_irq
> 
>  drivers/base/platform.c                        |  7 +++++-
>  drivers/of/irq.c                               | 26 +++++++++++++++++++++
>  drivers/of/platform.c                          |  4 +++-
>  drivers/of/selftest.c                          | 32 ++++++++++++++++++++++++++
>  drivers/of/testcase-data/tests-interrupts.dtsi | 12 ++++++++++
>  include/linux/of_irq.h                         |  7 +++++-
>  6 files changed, 85 insertions(+), 3 deletions(-)
> 
> -- 
> 1.9.1
> 

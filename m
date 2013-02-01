Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab3BAWFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:05:23 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47472 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757791Ab3BAWFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:05:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/vkDcglPAQeAT4/4F3wtwL
Date: Fri, 1 Feb 2013 14:05:10 -0800
From: Tony Lindgren <tony@atomide.com>
To: Philip Avinash <avinashphilip@ti.com>
Cc: khilman@ti.com, linux@arm.linux.org.uk, dwmw2@infradead.org, afzal@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH 1/4] arch: arm: gpmc: gpmc migration support
Message-ID: <20130201220510.GY22517@atomide.com>
References: <1358933176-12409-1-git-send-email-avinashphilip@ti.com>
 <1358933176-12409-2-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358933176-12409-2-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Philip Avinash <avinashphilip@ti.com> [130123 01:28]:
> With recent GPMC driver conversion, usage of gpmc_save/restore_context
> can done from gpmc driver itself. Hence removes the usage from pm34xx.c.
> Also removes the conditional compilation primitives ARCH_OMAP3 for
> gpmc_save/restore_context.

Hmm I think this will break GPMC for deeper idle modes. Note that we
need to save and restore the context every time hitting off-idle, not
just for suspend and resume. Or am I missing something here?

Regards,

Tony

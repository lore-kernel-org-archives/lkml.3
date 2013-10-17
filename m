Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab3JQRal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:30:41 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18747 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab3JQRaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:30:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+g/9Gs3ByIUhrTtC3oJxVI
Date: Thu, 17 Oct 2013 10:30:37 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/9] of: refactor IRQ parsing and add interrupts-extended
 implementation
Message-ID: <20131017173037.GB15154@atomide.com>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@linaro.org> [131015 13:43]:
> Hi everyone.
> 
> This series is mostly a set of cleanup to the interrupt parsing code.
> Some of it merely clarification, like the renames of of_irq_map_*, some
> to tighten up the API by using of_phandle_args, and some to prepare for
> the last patch in the series.
> 
> Of all these patches, the last one is probably the only one likely to be
> controversial. It adds a new way of specifying interrupts. If a device
> gets wired up to multiple interrupt controllers, the interrupts-extended
> property allows the device to specify multiple connections without
> redirecting through an interrupt-map node which can be rather difficult
> to understand. In a lot of cases, an interrupts-extended property is a
> whole lot easier to use.

Oh that's too diplomatic :) How about something like this instead:

"Device tree is currently badly broken where in order to support
 interrupts from multiple interrupt controllers the device needs
 to do the opposite of describing hardware, and lie about itself
 being an interrupt controller to use the interrupt-map property."

Anyways, gave this series a try, and the interrupts-extended binding
works for me for the multiple interrupt controllers issue :)

Tony


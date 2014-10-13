Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaJMPnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 11:43:39 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35167 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753855AbaJMPnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 11:43:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 162.217.72.251
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19TAdbb3+9XM9jjYEpGGHXW
Date: Mon, 13 Oct 2014 08:42:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: He YunLei <heyunlei@huawei.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        wangbintian@huawei.com, liguozhu@hisilicon.com,
        kong.kongxinwei@hisilicon.com, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCH] pinctrl: pinctrl-single.c:  init pinctrl single at
 arch_initcall time
Message-ID: <20141013154218.GA5192@atomide.com>
References: <542934F4.10303@huawei.com>
 <20140929175427.GE3122@atomide.com>
 <54349671.6090008@huawei.com>
 <20141008181027.GE10014@atomide.com>
 <5438F1F6.4080300@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5438F1F6.4080300@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* He YunLei <heyunlei@huawei.com> [141011 02:03]:
> On 2014/10/9 2:10, Tony Lindgren wrote:
> >* He YunLei <heyunlei@huawei.com> [141007 18:43]:
> >>
> >>Thanks for your review and I am really appreciated it, but in our arm
> >>platform, we haven't custom initcall levels for other drivers. Although
> >>deferred probe helps other drivers to register well, we are also confused
> >>for the issues of lots of pin request errors debug output while booting the
> >>kernel. Besides, if the number is bigger than the limited number, whether
> >>deferred probe can solve this problem.
> >
> >OK. Care to provide some examples where this happens on your
> >platform?
> >
> >Note that we already have pinctrl very early in drivers/Makefile.
> >What are the early users for pinctrl-single in your setup?
> >
> >Regards,
> >
> >Tony
> >
> >.
> >
> In our platform we use subsys_initcall in I2C, and fs_initcall in PMIC, Both
> of them are early than pinctrl-single. Although they register well
> with the aid of deferred probe, it's really confused us that pins request
> deferred. Why can't we setup pinctrl-single earlier to reduce these
> messages.

How about make the I2C controller just regular module_init?

We're planning to do that for omaps as soon as we have made omap3
DT only as we still have some board-*.c files.

Presumably your PMIC is also on I2C and you need the PMIC for
regulators?

In that case you can just make the PMICinit normal module_init too.

Regards,

Tony

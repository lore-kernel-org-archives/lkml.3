Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277Ab3IDR7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:59:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:29684 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503Ab3IDR7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:59:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18X4QLOwXxaGsopqwMyQUGG
Date: Wed, 4 Sep 2013 10:59:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Tero Kristo <t-kristo@ti.com>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 5/5] clk: dt: binding for basic gate clock
Message-ID: <20130904175909.GB31541@atomide.com>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
 <1377150793-27864-6-git-send-email-mturquette@linaro.org>
 <CAD6h2NRBq8hD8J5+P4NBZJZsPo4QAebgGaxmAn5TL0c2Cc5ULQ@mail.gmail.com>
 <5220FB48.7080607@wwwdotorg.org>
 <CAD6h2NSr0cM_SWqniC30pYm0mCeziBOzVg-46-814qPMxUwDCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD6h2NSr0cM_SWqniC30pYm0mCeziBOzVg-46-814qPMxUwDCQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Haojian Zhuang <haojian.zhuang@linaro.org> [130903 20:11]:
> 
> We can see that it'll try to find static mapping. What's the static mapping?
> If we define iotable in machine driver, we have the static mapping, just like
> debug_ll. If we parse everything from DTS file, it'll always get a new virtual
> address from vm area. So it always create a new page mapping even for one
> register.

I may not follow you here.. But it seems that you've missing something with
the static mapping: It's found based on the physical address. So if you
create static mappings for your SoC with iotable_init(), those mappings
will be available everywhere including drivers when you do ioremap().

Regards,

Tony

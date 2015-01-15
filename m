Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbbAORCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:02:40 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55606 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753028AbbAORCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:02:39 -0500
Date: Thu, 15 Jan 2015 18:02:37 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 7/8] clocksource: atmel-st: use syscon/regmap
Message-ID: <20150115170237.GV3843@piout.net>
References: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421077023-30954-8-git-send-email-alexandre.belloni@free-electrons.com>
 <54B7ED85.2090700@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B7ED85.2090700@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/2015 at 17:40:37 +0100, Daniel Lezcano wrote :
> >  /*
> >@@ -234,13 +201,21 @@ err:
> >   */
> >  static void __init atmel_st_timer_init(struct device_node *node)
> >  {
> >-	/* For device tree enabled device: initialize here */
> >-	of_at91rm9200_st_init();
> >+	unsigned int val;
> >+
> >+	regmap_st = syscon_node_to_regmap(node);
> >+	if (IS_ERR(regmap_st))
> >+		panic(pr_fmt("Unable to get regmap\n"));
> 
> Is it possible to get ride of those panics ? IIRC, we discussed to not panic
> when a timer was not initialized in case there is a definition for another
> one.
> 

Ok, I'll remove those.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

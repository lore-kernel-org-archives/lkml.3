Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbbALOIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:08:40 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54252 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753126AbbALOIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:08:38 -0500
Date: Mon, 12 Jan 2015 15:08:36 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2 3/8] watchdog: at91rm9200: use the regmap from mfd
Message-ID: <20150112140836.GL2447@piout.net>
References: <1420797094-9444-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1420797094-9444-4-git-send-email-alexandre.belloni@free-electrons.com>
 <54B074B9.2090704@roeck-us.net>
 <20150110184146.GH2447@piout.net>
 <54B1CE58.4040407@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B1CE58.4040407@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2015 at 17:14:00 -0800, Guenter Roeck wrote :
> Not sure I understand what my comment has to do with 'parent'.
> 
> The fact that the code checks if it has already been instantiated
> suggests that the original author of the driver was concerned about
> that case. Since you did not remove that check I have to assume that
> this can still happen. If so, the second instantiation attempt will
> overwrite regmap_st, since that variable is written prior to checking
> for the dual instantiation.
> 

I'll move the regmap_st assignment after the check. But I really believe
it will never be probed more than once.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

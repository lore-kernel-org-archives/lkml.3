Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3I0MMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:12:22 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:36604 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab3I0MMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:12:19 -0400
MIME-Version: 1.0
In-Reply-To: <1379058442-3321-1-git-send-email-b.brezillon@overkiz.com>
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
	<1379058442-3321-1-git-send-email-b.brezillon@overkiz.com>
Date: Fri, 27 Sep 2013 14:12:19 +0200
Message-ID: <CACRpkdbbpe8RbZ3AZX9YjsqT_GOo3aaD3YAcJT7toNx6E6VPgA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] pinctrl: at91: fix sam9x5 debounce/deglitch functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 9:47 AM, Boris BREZILLON
<b.brezillon@overkiz.com> wrote:

> Replace at91_mux_get_deglitch with at91_mux_pio3_get_deglitch when using
> sam9x5 (pio3) IP.
> at91_mux_get_deglitch only test the activation of the "Input Filter" which
> may be overloaded by the activation of the "Input Filter Slow Clock" to use
> the input filter as a debounce filter instead of a deglitch filter.
>
> Fix at91_mux_pio3_get_debounce to test the activation of the Input Filter
> before testing the activation of the debounce filter (Input Filter Slow
> Clock depends on Input Filter).
>
> Fix at91_mux_pio3_set_debounce function to avoid disabling the deglitch
> filter ("Input Filter") when debounce filter is disabled.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Patch applied with Jean-Christophe's ACK.

Yours,
Linus Walleij

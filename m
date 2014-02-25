Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaBYBDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:03:54 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49469 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaBYBDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:03:53 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "Tomasz Figa" <tomasz.figa@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <530B8627.4020705@free-electrons.com>
Cc: "Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>,
        "Andrew Lunn" <andrew@lunn.ch>, "Jason Cooper" <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org,
        "Ezequiel Garcia" <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>
References: <1392054179-28830-1-git-send-email-gregory.clement@free-electrons.com>
 <530A420B.5050207@gmail.com> <530B8627.4020705@free-electrons.com>
Message-ID: <20140225010347.22529.41519@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2] clk: respect the clock dependencies in of_clk_init
Date: Mon, 24 Feb 2014 17:03:47 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gregory CLEMENT (2014-02-24 09:49:27)
> On 23/02/2014 19:46, Tomasz Figa wrote:
> > On 10.02.2014 18:42, Gregory CLEMENT wrote:
> >> +
> >> +    for (i = 0; i < num_parents; i++) {
> >> +            if (of_parse_phandle_with_args(np, "clocks", "#clock-cells", i,
> >> +                                           &clkspec))
> >> +                    return 1;
> >> +
> >> +            /* Check if we have such a provider in our array */
> >> +            found = false;
> >> +            list_for_each_entry(provider, &of_clk_providers, link) {
> >> +                    if (provider->node == clkspec.np) {
> >> +                            found = true;
> >> +                            break;
> >> +                    }
> >> +            }
> >> +
> >> +            if (!found)
> >> +                    return 0;
> >> +    }
> > 
> > ...or even better, __of_clk_get_from_provider() could modified to return
> > -EPROBE_DEFER if requested provider is not registered and you could 
> 
> There is already a patch sent for this "clk: return probe defer when DT clock
> not yet ready": http://article.gmane.org/gmane.linux.kernel/1643466
> 
> Mike will you take it?
> 
> Then I can use it to implement the suggestion made by Tomasz.

I have just merged it to clk-next. I'll push out an updated clk-next
branch later tonight.

Regards,
Mike

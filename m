Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085Ab3IEJfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:35:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825Ab3IEJfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:35:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH RFC v2 01/16] ARM: call clk_of_init from time_init
Date: Thu, 5 Sep 2013 11:34:40 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Michal Simek <michal.simek@xilinx.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <52279D79.9070408@gmail.com> <cfedb014-695a-49cd-8e41-afabd585496a@DB8EHSMHS006.ehs.local>
In-Reply-To: <cfedb014-695a-49cd-8e41-afabd585496a@DB8EHSMHS006.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201309051134.40421.arnd@arndb.de>
X-Provags-ID: V02:K0:4r3ab7AeR3VFbYu5KDUwQPgOUNlX1g8wJFF7Ur/V/hZ
 hpIFkcnpmm97SCAJj/TvsnalV3t90zjp7aW+QdS5+NRiuTQUrU
 mGKfGCi50pDNXmKLuy6KufyAAdhMLRZX6YLHcDas7dtqRUWc1s
 K4nBzqwlepD24hDAaAil3XJMpA16D7d8WgMP+4uiCRFqUbw/V7
 cVGiBkcTMnUHVTBLnxxrbCnm7pTJ5UVeYOKxr14e90F1Thn+GH
 8wYbSO1U0wOI9i/BOStZxrwsj4bGazK7W9eZtqNx/xU71t7SwG
 cxahxN9z8h8A8OMF3BEipoBdte9qg+6DIQhzbA6G3uSYifYoG9
 Td5r8XyL/9ZTOBRF0Xu0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 September 2013, Sören Brinkmann wrote:
> On Wed, Sep 04, 2013 at 10:52:09PM +0200, Sebastian Hesselbarth wrote:
> > On 09/04/2013 10:41 PM, Sören Brinkmann wrote:
> > Anyways, having a custom .init_time gives you full control over
> > of_clk_init and clocksource_of_init back again thanks to your
> > suggestion.
> > 
> > I'll stop converting zynq and let you decide on your own ;)
> 
> As I said, currently it's rather messy and neither solution is perfect.
> Steffen seemed to already have looked towards syscon and regmap, which
> are probably the right ways of making the SLCR regs available to other users.

Yes, this seems fine. I suspect we will first have to find a way to have
"early" syscon mappings, which seem to be required for a few other use
cases as well, but are not trivial to implement in a nice way.

> Sure, passing down the pointer is not perfect, but having two drivers
> map the same memory region seems slightly worse to me. And it would even
> fail for one driver if you properly used request_mem_region() and friends.

I think the two approaches are equally hacky, no need to change it now
or rush to a better solution -- let's fix the other of_clk_init() users
first.

One suggestion though: it might be better to not use CLK_OF_DECLARE
with of_clk_init(NULL) in cases like this but have an explicit table
in the clk driver that does not get intermixed with the default table.

	Arnd

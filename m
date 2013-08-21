Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3HUSwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:52:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58322 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3HUSwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:52:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC 02/17] ARM: call clk_of_init from time_init
Date: Wed, 21 Aug 2013 20:51:46 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <201308202244.56782.arnd@arndb.de> <5213D853.7070102@wwwdotorg.org>
In-Reply-To: <5213D853.7070102@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308212051.46453.arnd@arndb.de>
X-Provags-ID: V02:K0:fH+JgzeK6lIQy/m2jb2Z6a9u5FFInuDhbFu9GC2BYjF
 9bLi84tyCtC+OBX/ZEd8R/g9Ai3UBA3cqom/W4TSJ7rXMjs4T9
 NG1bKfhoOjvp+IUF/ySEYmVn6myaaEjqxd2WPVlMcIEIKKrguq
 tTf10rcDviFIdnAFJfv1Y8Zg0ELEX2ZcGNOb8Fw2meyranIIBH
 wNagUbRhM+nSTHaf817iv5N4Kgm85hbeU+eaAO6E2sIZ6TiAne
 MQ1eE21E6+m0c/Wm45L+H+lEDsgLuZCTT39Sk06RASM+L+XsE0
 OTKI4kf1yCRikf5P2DHZMGmvSjzSlkzAR3fWswO0ZSQzKGcHRn
 zCN15FK985SCjsbkj2bM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 August 2013, Stephen Warren wrote:
> On 08/20/2013 02:44 PM, Arnd Bergmann wrote:
> > On Tuesday 20 August 2013, Stephen Warren wrote:

> Hmm. This probably isn't too hard. I /think/ the only reason the clocks
> are initialized early is:
> 
> * The PMC HW block is involved in the path of some interrupts (i.e. it
> inverts, or not, the IRQ input pin dedicated to the PMIC).
> 
> * So, that part of the PMC must be initialized early so that the IRQ
> polarity is correct.
> 
> * The PMC initialization is currently monolithic, and the PMC has some
> clock inputs, so the init routine ends up calling of_clk_get_by_name(),
> and hence clocks must be set up early too.
> 
> Perhaps if we just separate tegra_pmc_init() into two functions which
> initialize different parts of the PMC, we can get rid of the
> tegra_dt_init_irq() -> tegra_pmc_init() -> of_clk_get_by_name() call
> path, and hence move Tegra's call to of_clk_init() to the typical place.

That sounds good to me, thanks for looking into it.

	Arnd

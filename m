Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaDNN7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:59:45 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:43152 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbaDNN7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:59:44 -0400
Date: Mon, 14 Apr 2014 08:59:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Johannes Hirte <johannes.hirte@datenkhaos.de>
cc: Josh Cartwright <joshc@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
Subject: Re: [PATCH -next] slub: Replace __this_cpu_inc usage w/ SLUB_STATS
In-Reply-To: <20140414153424.0eca4c7d@datenkhaos.de>
Message-ID: <alpine.DEB.2.10.1404140858100.17469@nuc>
References: <20140306194821.3715d0b6212cc10415374a68@canb.auug.org.au> <20140306155316.GG18529@joshc.qualcomm.com> <20140306182941.GH18529@joshc.qualcomm.com> <20140414153424.0eca4c7d@datenkhaos.de>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014, Johannes Hirte wrote:

> kernel/watchdog.c:
>
> void touch_softlockup_watchdog(void)
> {
>         __this_cpu_write(watchdog_touch_ts, 0);
> }
> EXPORT_SYMBOL(touch_softlockup_watchdog);
>
> Don't know if the change to this_cpu_write() is the right way here too.

Well yes lets change that to this_cpu_write(). I doubt there are
significant performance issues here.


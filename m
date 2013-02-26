Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab3BZBaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:30:06 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:48786 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3BZBaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:30:04 -0500
Date: Mon, 25 Feb 2013 17:30:00 -0800
From: "'Tejun Heo'" <tj@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Greg KH'" <greg@kroah.com>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH V2] rtc: add devm_rtc_device_{register,unregister}()
Message-ID: <20130226013000.GG2679@htj.dyndns.org>
References: <008c01ce13bf$8d2cd550$a7867ff0$%han@samsung.com>
 <20130226012317.GF2679@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226012317.GF2679@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 05:23:17PM -0800, 'Tejun Heo' wrote:
> again, why do we need the WARN_ON() at all given that other
> devm_*_match() don't do that and the only way to get NULL there would
> be bug in devm_rtc*() code itself rather than its users?

Ughh... I see that you probably copied the chunk from clk / regulator
implementation.  Let's please not copy those.  Input validation via
WARN_ON()s is nice when the interface is taking input from outside or
the code in question is complex / fragile.  Here, the code involved is
like 20 lines and self-contained.

Thanks.

-- 
tejun

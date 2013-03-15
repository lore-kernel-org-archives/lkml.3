Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3CORMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:12:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36329 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3CORMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:12:21 -0400
Date: Fri, 15 Mar 2013 17:12:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Bill Huang <bilhuang@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 1/1] clk: Add notifier support in
	clk_prepare_enable/clk_disable_unprepare
Message-ID: <20130315171200.GN4977@n2100.arm.linux.org.uk>
References: <1363151317.3311.9.camel@bilhuang-vm1> <51400D9D.9060305@wwwdotorg.org> <1363153204.3311.14.camel@bilhuang-vm1> <5140C12A.4060900@wwwdotorg.org> <1363227311.3311.30.camel@bilhuang-vm1> <20130314092132.GE18519@tbergstrom-lnx.Nvidia.com> <1363253287.3311.32.camel@bilhuang-vm1> <51420EBB.7080503@wwwdotorg.org> <1363310454.3311.44.camel@bilhuang-vm1> <5142B027.4040403@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5142B027.4040403@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:22:47PM -0600, Stephen Warren wrote:
> Is clk_set_rate() only legal to call in non-atomic contexts then? The
> header file doesn't say, although I guess since many other functions
> explicitly say they can't, then by omission it can...

I think when all this was discussed alongside the clk_prepare/clk_unprepare
stuff, that yes, it was decided that clk_set_rate() was non-atomic only.

And yes, that is most definitely the case, because the first thing 
clk_set_rate() does is take a mutex - which will trigger a might_sleep()
complaint if ever called from an atomic context.

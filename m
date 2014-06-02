Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaFBPjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:39:53 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:46840 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753871AbaFBPju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:39:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/XDYCrcz1OwGzscZCG7v5i
Date: Mon, 2 Jun 2014 08:39:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: FanWu <fwu@marvell.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [PATCH v2] pinctrl: add params in disable_setting for different
 usage
Message-ID: <20140602153941.GA11004@atomide.com>
References: <1400728210-17863-1-git-send-email-fwu@marvell.com>
 <537E848C.5010204@wwwdotorg.org>
 <537EAA46.8010409@marvell.com>
 <537F7407.5080404@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537F7407.5080404@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [140523 09:16]:
> On 05/22/2014 07:54 PM, FanWu wrote:
> > the pinctrl-single driver is still using ops->disable, if I remove the
> > "disable" in ops, there will be build error in the vendor's code base
> > who is using pinctrl-single driver.
> 
> I thought Tony said it was fine to simply remove pinctrl-single's
> ops->disable code completeley.

AFAIK nobody is using it. At least we don't have any references to
pinctrl-single,function-off property in the .dts files.

So removing pcs_disable seems safe to do, the property we probably
want to parse and produce a warning in case somebody is using it
out of tree.

Regards,

Tony

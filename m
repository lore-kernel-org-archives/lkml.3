Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbbABRdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:33:12 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44386 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbABRdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:33:11 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+9PwSbxwuJPR7avnecMkJq
Date: Fri, 2 Jan 2015 09:29:35 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>, Paul Walmsley <paul@pwsan.com>,
        t-kristo@ti.com, nm@ti.com, nsekhar@ti.com, bcousson@baylibre.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: hwmod: Fix _wait_target_ready() for hwmods
 without sysc
Message-ID: <20150102172935.GD3298@atomide.com>
References: <1418917790-1791-1-git-send-email-rogerq@ti.com>
 <5492F84E.7020706@ti.com>
 <5493B5CE.7010000@ti.com>
 <5493EA88.1080609@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5493EA88.1080609@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [141219 01:08]:
> Lokesh,
> 
> On 19/12/14 07:21, Lokesh Vutla wrote:
> > Hi Roger,
> > On Thursday 18 December 2014 09:22 PM, Roger Quadros wrote:
> >> Fixing up Paul's email id.
> >>
> >> cheers,
> >> -roger
> >>
> >> On 18/12/14 17:49, Roger Quadros wrote:
> >>> There are quite a few hwmods that don't have sysconfig register and so
> >>> _find_mpu_rt_port(oh) will return NULL thus preventing ready state check
> >>> on those modules after the module is enabled.
> >>>
> >>> This can potentially cause a bus access error if the module is accessed
> >>> before the module is ready.
> >>>
> >>> Get rid of the redundant _find_mpu_rt_port() check from the _wait_target_ready()
> >>> funcion for all the SoCs. The following PRCM register access that checks the
> >>> module ready state has nothing to do with module's SYSCONFIG or mpu_rt_port.
> > Yes, makes sense. This patch looks good to me.
> > Tested this on AM437x-gp-evm.

Roger, if the modules don't have sysconfig registers, care to check
if we actually really need hwmod for those modules then?

I know hwmod is managing runtime PM gate clocks for devices with
clkctrl_offs. But if that's all we need hwmod for in the non-sysc
cases, then it might make sense to manage the gate clocks in the
clock framework directly instead for those devices.

Of course that's more of a long term project, but at least we should
be aware of the dependencies here :)

> > May be good idea to warn every time if enabling of module is failed?
> > Unrelated to this patch though.
> 
> Yes, failing to be ready is serious enough for a warning. Care to send a separate patch for that?

Yeah that sounds like a separate patch.

Regards,

Tony

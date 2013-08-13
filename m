Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab3HMUtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:49:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56942 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938Ab3HMUtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:49:45 -0400
Date: Tue, 13 Aug 2013 13:49:43 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / QoS: Fix workqueue deadlock when using
 pm_qos_update_request_timeout()
Message-ID: <20130813204943.GH14845@codeaurora.org>
References: <1375992837-1673-1-git-send-email-sboyd@codeaurora.org>
 <520A62E2.6000309@codeaurora.org>
 <20130813170146.GC32719@htj.dyndns.org>
 <4423040.Ds5TZlivfo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4423040.Ds5TZlivfo@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Rafael J. Wysocki wrote:
> On Tuesday, August 13, 2013 01:01:46 PM Tejun Heo wrote:
> > Hello,
> > 
> > On Tue, Aug 13, 2013 at 09:46:26AM -0700, Stephen Boyd wrote:
> > > >> +	if (PM_QOS_DEFAULT_VALUE != req->node.prio)
> > > >> +		pm_qos_update_target(
> > > >> +				pm_qos_array[req->pm_qos_class]->constraints,
> > > >> +				&req->node, PM_QOS_UPDATE_REQ,
> > > >> +				PM_QOS_DEFAULT_VALUE);
> > > > Maybe it'd be cleaner to add a param or internal variant of
> > > > pm_qos_update_request()?
> > > 
> > > Maybe, but I was trying to make a minimal fix here.
> > 
> > Hmmm.... it just looks like things can easily get out of sync with the
> > complex function call.
> 
> Yes, that's just duplicated code.
> 
> > I don't think it'll be too invasive if you introduce an internal variant
> > which doesn't do the canceling.  Rafael, what do you think?
> 
> I'd move the part of pm_qos_update_request() below the
> cancel_delayed_work_sync() to a separate static function that'd be
> called from two places.
> 

Ok I will throw this all into one patch and resend.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

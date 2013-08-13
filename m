Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab3HMRBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:01:51 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57746 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab3HMRBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:01:50 -0400
Date: Tue, 13 Aug 2013 13:01:46 -0400
From: Tejun Heo <tj@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / QoS: Fix workqueue deadlock when using
 pm_qos_update_request_timeout()
Message-ID: <20130813170146.GC32719@htj.dyndns.org>
References: <1375992837-1673-1-git-send-email-sboyd@codeaurora.org>
 <20130813164315.GB32719@htj.dyndns.org>
 <520A62E2.6000309@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A62E2.6000309@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 13, 2013 at 09:46:26AM -0700, Stephen Boyd wrote:
> >> +	if (PM_QOS_DEFAULT_VALUE != req->node.prio)
> >> +		pm_qos_update_target(
> >> +				pm_qos_array[req->pm_qos_class]->constraints,
> >> +				&req->node, PM_QOS_UPDATE_REQ,
> >> +				PM_QOS_DEFAULT_VALUE);
> > Maybe it'd be cleaner to add a param or internal variant of
> > pm_qos_update_request()?
> 
> Maybe, but I was trying to make a minimal fix here.

Hmmm.... it just looks like things can easily get out of sync with the
complex function call.  I don't think it'll be too invasive if you
introduce an internal variant which doesn't do the canceling.  Rafael,
what do you think?

Thanks.

-- 
tejun

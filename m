Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273Ab3HMUip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:38:45 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41515 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759255Ab3HMUio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:38:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / QoS: Fix workqueue deadlock when using pm_qos_update_request_timeout()
Date: Tue, 13 Aug 2013 22:49:09 +0200
Message-ID: <4423040.Ds5TZlivfo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130813170146.GC32719@htj.dyndns.org>
References: <1375992837-1673-1-git-send-email-sboyd@codeaurora.org> <520A62E2.6000309@codeaurora.org> <20130813170146.GC32719@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 13, 2013 01:01:46 PM Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 13, 2013 at 09:46:26AM -0700, Stephen Boyd wrote:
> > >> +	if (PM_QOS_DEFAULT_VALUE != req->node.prio)
> > >> +		pm_qos_update_target(
> > >> +				pm_qos_array[req->pm_qos_class]->constraints,
> > >> +				&req->node, PM_QOS_UPDATE_REQ,
> > >> +				PM_QOS_DEFAULT_VALUE);
> > > Maybe it'd be cleaner to add a param or internal variant of
> > > pm_qos_update_request()?
> > 
> > Maybe, but I was trying to make a minimal fix here.
> 
> Hmmm.... it just looks like things can easily get out of sync with the
> complex function call.

Yes, that's just duplicated code.

> I don't think it'll be too invasive if you introduce an internal variant
> which doesn't do the canceling.  Rafael, what do you think?

I'd move the part of pm_qos_update_request() below the
cancel_delayed_work_sync() to a separate static function that'd be
called from two places.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

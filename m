Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab3HMWnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:43:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:41615 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461Ab3HMWny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:43:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / QoS: Fix workqueue deadlock when using pm_qos_update_request_timeout()
Date: Wed, 14 Aug 2013 00:54:18 +0200
Message-ID: <9317874.UKPmemvZzk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130813221325.GD28996@mtj.dyndns.org>
References: <4423040.Ds5TZlivfo@vostro.rjw.lan> <1376428360-12560-1-git-send-email-sboyd@codeaurora.org> <20130813221325.GD28996@mtj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 13, 2013 06:13:25 PM Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 13, 2013 at 02:12:40PM -0700, Stephen Boyd wrote:
> > @@ -308,7 +319,7 @@ static void pm_qos_work_fn(struct work_struct *work)
> >  						  struct pm_qos_request,
> >  						  work);
> >  
> > -	pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
> > +	__pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
> 
> Maybe a short comment explaining why this is different would be nice?
> Other than that,
> 
>  Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks guys, I'm going to push that as a fix for 3.11-rc6 and stable.

Rafael


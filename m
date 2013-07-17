Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3GQJqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:46:52 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:8098 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3GQJqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:46:51 -0400
Date: Wed, 17 Jul 2013 11:46:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: Guenter Roeck <linux@roeck-us.net>, thierry.reding@gmail.com,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 2/4] hwmon: (lm90) use macro defines for the status 
 bit
Message-ID: <20130717114639.3a348931@endymion.delvare>
In-Reply-To: <51E663FC.5050209@nvidia.com>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
	<1373615287-18502-3-git-send-email-wni@nvidia.com>
	<20130715185727.4ebde8c4@endymion.delvare>
	<51E641C7.4000107@nvidia.com>
	<20130717102803.6ee36313@endymion.delvare>
	<51E663FC.5050209@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Wed, 17 Jul 2013 17:29:32 +0800, Wei Ni wrote:
> On 07/17/2013 04:28 PM, Jean Delvare wrote:
> > I do maintain the lm90 driver, so the decision is up to me. Guenter did
> > a preliminary review of your patches and I am grateful for that, but I
> > do not intend to wait for his return to continue with your patches.
> > Otherwise he will have to do the same when he returns and I am gone,
> > and this may end up delaying your patches by one kernel version.
> 
> I will send out patches soon :)

You may want to wait until I'm done reviewing the whole v3 patch set. I
hope to have the time to do that today.

> >> (...)
> >> Oh, yes, this is a problem, I didn't noticed it.
> >> How about to use this:
> >> bool lm90_alarms_tripped(*client, *status);
> >> bool lm90_alarms2_tripped(*client, *status2);
> >> So we can read the status only once and pass it.
> > 
> > This is a good idea but you only need status, not status2, so it can be
> > made simpler:
> > bool lm90_is_tripped(*client, *status);
> > (handling both status and status 2 as you already do.)
> 
> Yes this is simpler, but I think in the future we may need to handle the
> status2, how to handle it ? Or we can define the status as
> bit[0~7]->status and bit[8~15]->status2 .

I hope we will never have to. We need it to work around a hardware
implementation bug, and I hope that newer chips implementing status2
will not have this bug.

That being said, yes, returning status and status2 combined in a 16-bit
value would make sense. We end up comparing with data->alert_alarms
which has exactly this format anyway (and so does data->alarms too.)

-- 
Jean Delvare

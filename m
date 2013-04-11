Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526Ab3DKXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:25:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:57918 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765536Ab3DKXZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:25:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,458,1363158000"; 
   d="scan'208";a="293743608"
Message-ID: <1365722723.2183.6.camel@rzhang1-mobl4>
Subject: Re: [PATCH] thermal: step_wise: set throttle target within thermal
 instance limits
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Andrew Bresticker <abrestic@chromium.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 07:25:23 +0800
In-Reply-To: <5165CA11.3090709@ti.com>
References: <1365544787-22940-1-git-send-email-abrestic@chromium.org>
	 <1365577575.2183.70.camel@rzhang1-mobl4> <5165CA11.3090709@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 16:22 -0400, Eduardo Valentin wrote:
> On 10-04-2013 03:06, Zhang Rui wrote:
> > On Tue, 2013-04-09 at 14:59 -0700, Andrew Bresticker wrote:
> >> When selecting a target cooling state in get_target_state(), make sure
> >> that the state is at least as high as the minimum when the temperature
> >> is rising and at least as low as the maximum when the temperature is
> >> falling.  This is necessary because, in the THREAML_TREND_RAISING and
> >> THERMAL_TREND_DROPPING cases, the current state may only be incremented
> >> or decremented by one even if it is outside the bounds of the thermal
> >> instance.  This might occur, for example, if the CPU is heating up
> >> and hits a thermal trip point for the first time when it's frequency
> >> is much higher than the range specified by the thermal instance
> >> corresponding to the trip point.
> >>
> >> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> >
> > applied.
> 
> Rui,
> 
> Can you please add my:
> 
> Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
> 
sure. Thanks for reviewing.

thanks,
rui
> 
> Thanks,
> >
> > thanks,
> > rui
> >> ---
> >>   drivers/thermal/step_wise.c | 10 ++++++++--
> >>   1 file changed, 8 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
> >> index 407cde3..ca4f79f 100644
> >> --- a/drivers/thermal/step_wise.c
> >> +++ b/drivers/thermal/step_wise.c
> >> @@ -59,9 +59,12 @@ static unsigned long get_target_state(struct thermal_instance *instance,
> >>
> >>   	switch (trend) {
> >>   	case THERMAL_TREND_RAISING:
> >> -		if (throttle)
> >> +		if (throttle) {
> >>   			cur_state = cur_state < instance->upper ?
> >>   				    (cur_state + 1) : instance->upper;
> >> +			if (cur_state < instance->lower)
> >> +				cur_state = instance->lower;
> >> +		}
> >>   		break;
> >>   	case THERMAL_TREND_RAISE_FULL:
> >>   		if (throttle)
> >> @@ -71,8 +74,11 @@ static unsigned long get_target_state(struct thermal_instance *instance,
> >>   		if (cur_state == instance->lower) {
> >>   			if (!throttle)
> >>   				cur_state = -1;
> >> -		} else
> >> +		} else {
> >>   			cur_state -= 1;
> >> +			if (cur_state > instance->upper)
> >> +				cur_state = instance->upper;
> >> +		}
> >>   		break;
> >>   	case THERMAL_TREND_DROP_FULL:
> >>   		if (cur_state == instance->lower) {
> >
> >
> >
> >
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3G2QdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:33:07 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:32515 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3G2QdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:33:03 -0400
Date: Mon, 29 Jul 2013 17:48:31 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: linux@roeck-us.net, thierry.reding@gmail.com, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 4/4] hwmon: (lm90) use enums for the indexes of temp8
  and temp11
Message-ID: <20130729174831.207ed356@endymion.delvare>
In-Reply-To: <51F64EC0.800@nvidia.com>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
 <1373615287-18502-5-git-send-email-wni@nvidia.com>
 <20130727173830.14cb5b21@endymion.delvare>
 <51F64EC0.800@nvidia.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Mon, 29 Jul 2013 19:15:12 +0800, Wei Ni wrote:
> On 07/27/2013 11:38 PM, Jean Delvare wrote:
> > On Fri, 12 Jul 2013 15:48:07 +0800, Wei Ni wrote:
> >> +/*
> >> + * TEMP11 register index
> >> + */
> >> +enum lm90_temp11_reg_index {
> >> +     TEMP11_REMOTE_TEMP = 0, /* 0: remote input */
> >> +     TEMP11_REMOTE_LOW,      /* 1: remote low limit */
> >> +     TEMP11_REMOTE_HIGH,     /* 2: remote high limit */
> >> +     TEMP11_REMOTE_OFFSET,   /* 3: remote offset
> >> +                              * (except max6646, max6657/58/59,
> >> +                              *  and max6695/96)
> >> +                              */
> >> +     TEMP11_LOCAL_TEMP,      /* 4: local input */
> >> +     TEMP11_REMOTE2_TEMP,    /* 5: remote 2 input (max6695/96 only) */
> >> +     TEMP11_REMOTE2_LOW,     /* 6: remote 2 low limit (max6695/96 only) */
> >> +     TEMP11_REMOTE2_HIGH,    /* 7: remote 2 high limit (max6695/96 only) */
> >> +     TEMP11_REG_NUM
> >> +};
> > (...)
> > Also, the comments are mostly useless now, they were there to document
> > what each number was referring to, but now this is exactly what the new
> > constants are doing.
>
> Yes, we can remove these comments, but I think it's better to remain
> those exception and only things.

Yes, I agree.

> >> +
> >> +/*
> >> + * TEMP11 register NR
> >> + */
> >> +enum lm90_temp11_reg_nr {
> >> +     NR_CHAN_0_REMOTE_LOW = 0,       /* 0: channel 0, remote low limit */
> >> +     NR_CHAN_0_REMOTE_HIGH,          /* 1: channel 0, remote high limit */
> >> +     NR_CHAN_0_REMOTE_OFFSET,        /* 2: channel 0, remote offset */
> >> +     NR_CHAN_1_REMOTE_LOW,           /* 3: channel 1, remote low limit */
> >> +     NR_CHAN_1_REMOTE_HIGH,          /* 4: channel 1, remote high limit */
> > 
> > The conventions used in the descriptions diverge from the ones used
> > above. "channel 0 remote" here is just "remove" above, and "channel 1
> > remote" is "remote 2" above. This is quite confusing.
> > 
> >> +     NR_NUM                          /* number of the NRs for temp11 */
> > 
> > The fact that you were unable to come up with a proper name for this
> > number is a clear indication that this enum should not exist in the
> > first place.
> > 
> > These numbers are used only once, to pass specific information to
> > set_temp11. This was easy enough when these were just numbers and I
> > really had no reason not to do that.
> 
> Ok, so how about to remove these changes, and keep the original codes to
> use numbers.

Fine with me. We can always change the code later to use the TEMP11
index values instead if anyone cares, this can be done separately.

-- 
Jean Delvare

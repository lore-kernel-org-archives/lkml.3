Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242AbaBKJri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:47:38 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:61171 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaBKJrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:47:32 -0500
Date: Tue, 11 Feb 2014 09:47:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (max6650) Rename the device ids to
 contain the hwmon suffix
Message-ID: <20140211094726.GH32042@lee--X1>
References: <1392045953-26596-1-git-send-email-lpapp@kde.org>
 <20140210160842.GB26997@lee--X1>
 <20140210173811.04ba5964@endymion.delvare>
 <CAOMwXhPTkrUUaUL-H_0fvZBO9_kt4jqKXs5BJYthDfu0_1c3xg@mail.gmail.com>
 <20140211085014.4ef32b56@endymion.delvare>
 <CAOMwXhMhKdp420+SPTih+C3fAgTmrpJgPnGBxsfPO3pEhESGTA@mail.gmail.com>
 <20140211085053.GD32042@lee--X1>
 <CAOMwXhPfmXDKcov_+HHDTCaieGDiMEi+6CV_OnYDM3c8+S+bfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhPfmXDKcov_+HHDTCaieGDiMEi+6CV_OnYDM3c8+S+bfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >> On Mon, Feb 10, 2014 at 4:38 PM, Jean Delvare <jdelvare@suse.de> wrote:
> >> >> > Additionally, dashes are explicitly forbidden in hwmon
> >> >> > device names.
> >> >>
> >> >> Also, where is that documented?
> >> >
> >> > In Documentation/hwmon/sysfs-interface:
> >> >
> >> > *********************
> >> > * Global attributes *
> >> > *********************
> >> >
> >> > name            The chip name.
> >> >                 This should be a short, lowercase string, not containing
> >> >                 spaces nor dashes, representing the chip name. This is
> >> >                 the only mandatory attribute.
> >> >                 I2C devices get this attribute created automatically.
> >> >                 RO
> >>
> >> Time to revisit this decision....
> >>
> >> So, based on the fact that children device names usually contain
> >> dashes, I do not understand why hwmon would be any special in this
> >> regard. It is possible that the hwmon developers have not faced much
> >> MFD situation before, and so, this was not considered to be handled
> >> like in other subsystems.
> >>
> >> I am proposing to change this "rule"...  Any objection?
> >
> > Prior to proposing such an invasive change which is highly likely to
> > come up against heavy opposition,
> 
> It is possible that someone does not understand why you think it may
> be invasive, right? Could you please explain the reason for that?

The reason is a good one. In the kernel we make every attempt not to
break userspace. By that I mean _any_ userspace application. Userspace
applications which interface with the kernel can do so via a variety of
methods. One of those is Sysfs, where this name you are attempting to
change appears. The userspace applications already mentioned parse for
these devices, regex:ing for '-' separators. If you add an additional
'-' separator there is a chance that these applications will get
confused and break without warning. 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

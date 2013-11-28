Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab3K1EIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:08:20 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48225 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab3K1EIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:08:18 -0500
Date: Wed, 27 Nov 2013 20:08:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-input@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: ads7846: Convert to
 hwmon_device_register_with_groups
Message-ID: <20131128040815.GE15452@core.coreip.homeip.net>
References: <1385440744-6607-1-git-send-email-linux@roeck-us.net>
 <20131126185846.GB22242@core.coreip.homeip.net>
 <529548CD.7060906@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529548CD.7060906@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 05:20:13PM -0800, Guenter Roeck wrote:
> On 11/26/2013 10:58 AM, Dmitry Torokhov wrote:
> >Hi Guenter,
> >
> >On Mon, Nov 25, 2013 at 08:39:04PM -0800, Guenter Roeck wrote:
> >>Simplify the code and create mandatory 'name' attribute by using
> >>new hwmon API.
> >
> >So this moves hwmon attributes from the parent i2c device to the hwmon
> >device, right? Would not that break userspace which expects to find the
> >attributes where they were?
> >
> 
> In addition to Jean's earlier comments ... s/i2c/spi/, I assume. spi devices
> don't create the mandatory name attribute automatically, which means
> that the created hwmon device was not recognized by standard user space
> applications (eg the sensors command or anything else using libsensors)
> in the first place. Which in turn means that only applications which don't
> support the standard hwmon ABI - if there are any - would be affected.
> What we are more concerned about is to make sure that applications
> which _do_ follow the hwmon ABI are working.

OK, fair enough, I'll apply this then.

-- 
Dmitry

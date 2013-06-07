Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3FGI7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:59:20 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35584 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3FGI7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:59:16 -0400
Date: Fri, 7 Jun 2013 16:59:05 +0800
From: Adam Lee <adam.lee@canonical.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH 1/3] thinkpad_acpi: return -NODEV while operating
 uninitialized LEDs
Message-ID: <20130607085905.GA7325@adam-laptop>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	ibm-acpi-devel@lists.sourceforge.net,
	Matthew Garrett <matthew.garrett@nebula.com>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	Alex Hung <alex.hung@canonical.com>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
 <1370593209-21358-2-git-send-email-adam.lee@canonical.com>
 <87vc5qxpwh.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87vc5qxpwh.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 10:53:50AM +0200, Bjørn Mork wrote:
> Adam Lee <adam.lee@canonical.com> writes:
> 
> > --- a/drivers/platform/x86/thinkpad_acpi.c
> > +++ b/drivers/platform/x86/thinkpad_acpi.c
> > @@ -5401,9 +5401,12 @@ static int led_write(char *buf)
> >  		return -ENODEV;
> >  
> >  	while ((cmd = next_cmd(&buf))) {
> > -		if (sscanf(cmd, "%d", &led) != 1 || led < 0 || led > 15)
> > +		if (sscanf(cmd, "%d", &led) != 1)
> >  			return -EINVAL;
> >  
> > +		if (!tpacpi_leds[led].led)
> > +			return -ENODEV;
> 
> This looks risky.  Why did you remove the index sanity check?  What will
> happen now if the input is e.g "-1" or "42"?
> 
> BTW, the magic number 15 should probably be (TPACPI_LED_NUMLEDS - 1)
> instead.

Oh, good point! I was thinking led_init() already checked the index.

Will submit patch v2, thanks.

-- 
Regards,
Adam Lee
Hardware Enablement

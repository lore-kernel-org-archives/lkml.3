Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab3J3Pdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:33:38 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:3026 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3J3Pdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:33:37 -0400
Date: Wed, 30 Oct 2013 16:33:26 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wei Ni <wni@nvidia.com>, thierry.reding@gmail.com,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 2/4] hwmon: (lm90) use macro defines for the status
 bit
Message-ID: <20131030163326.4e7e0cfc@endymion.delvare>
In-Reply-To: <20130715173322.GA20484@roeck-us.net>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
	<1373615287-18502-3-git-send-email-wni@nvidia.com>
	<20130715185727.4ebde8c4@endymion.delvare>
	<20130715173322.GA20484@roeck-us.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Mon, 15 Jul 2013 10:33:22 -0700, Guenter Roeck wrote:
> On Mon, Jul 15, 2013 at 06:57:27PM +0200, Jean Delvare wrote:
> > Unrelated to this patch, but Guenter, I am worried about the MAX6696
> > handling here. I realize that I am the one who accepted your code, but
> > now it looks wrong. Specifically:
> > * We check for (status2 & 0xfe) i.e. 7 alarm bits, but the code below
> >   only reports 2 alarms bits. So if any of the 5 other alarm bits in
> >   STATUS2 are, we may return true (chip is tripped) but not print the
> >   cause.
> > * At least bits 1 and 2 of STATUS 2 fit totally fine in the driver as
> >   it currently exists, so I can't think of any reason for not handling
> >   them. Why are we not? Ideally we should print a message for every
> >   alarm bit so that we never return "true" without printing a message.
> >   Even though OT2 limits aren't handled by the driver...
> > * If you think this piece of code shouldn't deal with OT/THERM limits
> >   because they do not trigger an SMBus alarm, this can be discussed,
> >   but all chips should be handled the same in this respect then.
> > * Why in the first place is max6696's data->alert_alarms set to 0x187c
> >   and not 0x1c7c? Including 1OPEN but not 2OPEN makes no sense.
> 
> I am about to leave for vacation, so this will have to wait for a couple of
> weeks. I'll look at it after I am back.

Are you back now? ;-)

-- 
Jean Delvare

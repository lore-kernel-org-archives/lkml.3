Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3FKOYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 10:24:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:9190 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab3FKOYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 10:24:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,845,1363158000"; 
   d="scan'208";a="315349111"
Date: Tue, 11 Jun 2013 16:23:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: am335x: TSC & ADC reworking including DT pieces, take 4
Message-ID: <20130611142358.GG29135@zurbaran>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Tue, Jun 11, 2013 at 01:30:46PM +0200, Sebastian Andrzej Siewior wrote:
> I believe the whole thing should go via the MFD tree. It touches also
> input & iio subsystem. I collected ACKs where I got some in the meantime.
Please fix your commit logs, and your subject lines. It should be e.g.
mfd: input: ti_am335x_adc: Blablabla

if it's mostly an mfd patch that also touches an input driver.

Then, this is a pretty big patchset, with iio, input and mfd all mixed
together and it is likely to create merge conflicts.
>From what I can see from it, and please correct me if I'm
wrong, the iio and input changes depend on the mfd ones, and not the
other way around. If that's so, I'm going to ask you to reshuffle your
patch set and separate the MFD changes from the iio and input ones. I'll
take the MFD ones and will create an immutable branch for Jonathan and
Dmitry to pull from and apply the iio and input changes on top of it.
Merge conflicts should be mostly avoided that way.
AFAICT, only patch #2 should be kept with input and iio bits mixed
together with MFD as otherwise this would introduce functional breakage.
Otherwise, all MFD bits from the other patches could be either separated
or merged together (e.g. MFD bits from patches #6 and #8, and #16 and
#17).

Does that sound doable to you ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

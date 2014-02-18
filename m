Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaBRS6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:58:54 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39437 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaBRS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:58:50 -0500
Date: Tue, 18 Feb 2014 12:56:23 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 1/6] spmi: Linux driver framework for SPMI
Message-ID: <20140218185623.GF31116@joshc.qualcomm.com>
References: <1391468739-20987-1-git-send-email-joshc@codeaurora.org>
 <1391468739-20987-2-git-send-email-joshc@codeaurora.org>
 <20140215234748.GA26494@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140215234748.GA26494@saruman.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 05:47:48PM -0600, Felipe Balbi wrote:
> On Mon, Feb 03, 2014 at 05:05:33PM -0600, Josh Cartwright wrote:
> > +#ifdef CONFIG_PM_RUNTIME
> > +static int spmi_runtime_suspend(struct device *dev)
> > +{
> > +	struct spmi_device *sdev = to_spmi_device(dev);
> > +	int err;
> > +
> > +	err = pm_generic_runtime_suspend(dev);
> > +	if (err)
> > +		return err;
> > +
> > +	return spmi_command_sleep(sdev);
> 
> shouldn't this too calls be swapped ? I mean, some pm_runtime
> implementations could be gating clocks at the driver's
> ->runtime_suspend() callback.

Perhaps.  I had added the explicit SLEEP/WAKEUP commands to
suspend()/resume(), but now I'm thinking issuing these commands should
not be the responsibility of the core, since the semantics of the
SLEEP/ACTIVE state aren't well defined in general (each
implementation/slave defines what, if anything, these states mean).

Fortunately, there are no users yet, so this is a painless change. :)

Thanks for taking a look.

  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

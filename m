Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3ANCwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:52:19 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55209 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3ANCwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:52:18 -0500
Date: Mon, 14 Jan 2013 02:51:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: erase pointer to drvdata on removal
Message-ID: <20130114025145.GC4928@sirena.org.uk>
References: <1351793136-14126-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351793136-14126-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Cookie: Smile!  You're on Candid Camera.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 02:05:36PM -0400, Vivien Didelot wrote:
> As for i2c-core, let the SPI core handle the removal of the device's
> drvdata, after a remove() or a probe() failure.

Any driver that notices this change is buggy, the driver shouldn't
use a drvdata value that it didn't set.  I had thought this stuff had
all been removed from I2C and either dropped or factored out into the
driver core...

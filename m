Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaAZUts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 15:49:48 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:10922 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaAZUtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 15:49:47 -0500
Date: Sun, 26 Jan 2014 21:49:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LM Sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>
Subject: Re: lm90 driver no longer working on PCs in 3.13
Message-ID: <20140126214936.7736f530@endymion.delvare>
In-Reply-To: <52E573B6.9040903@roeck-us.net>
References: <52E561D0.4040308@roeck-us.net>
	<20140126211357.6fa68909@endymion.delvare>
	<52E573B6.9040903@roeck-us.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jan 2014 12:44:38 -0800, Guenter Roeck wrote:
> On 01/26/2014 12:13 PM, Jean Delvare wrote:
> The regulator code changed with 3.13; the dummy regulator no longer exists,
> and the functionality it provided is supposed to be handled automatically.
> But that only really works on devicetree based systems and otherwise returns
> -EPROBE_DEFER as mentioned above.
> 
> Maybe there is some configuration option, or maybe something needs to be
> configured from user space. I found neither.

Neither would be acceptable to my eyes anyway. Things worked out of the
box before, they should keep working out of the box.

> In the first case, we should create
> a dependency for the LM90 driver; in the latter case, we would have to make sure
> that it is well documented (I'd grumble on that, though - it would result in
> never ending trouble for us, having to repeatedly explain how this is now
> supposed to work).
> 
> Another possible fix would be to have the regulator core return -ENODEV
> instead of -EPROBE_DEFER on non-dt systems. No idea if this would be acceptable
> or even feasible.

Well, either the regulator subsystem gets fixed (or provides a suitable
API for drivers like lm90 and we update the lm90 driver to use it), or
I'll just revert the problematic commit for now. This is a severe
regression, we just can't leave things that way.

-- 
Jean Delvare

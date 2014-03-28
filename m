Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaC1S4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:56:44 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46789 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaC1S4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 14:56:42 -0400
Date: Fri, 28 Mar 2014 11:56:53 -0700
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        rob.herring@linaro.org
Subject: Re: [RFC 0/5] of: Automatic console registration cleanups
Message-ID: <20140328185653.GB26433@quad.lixom.net>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 09:08:00AM -0700, Grant Likely wrote:
> Hi all,
> 
> This is a series that I've been playing with over the last few days to
> clean up the selection of default console devices when using the device
> tree. The device tree defines a way of specifying the console by using a
> "stdout-path" property in the /chosen node, but very few drivers
> actually attempt to use that data, and so for most platforms there needs
> to be a "console=" line in the command line if a serial port is intended
> to be used as the console.
> 
> With this series, if there is a /chosen/stdout-path property, and if
> that property points to a serial port node, then when the serial driver
> registers the port, the core uart_add_one_port() function will notice
> and if no console= argument was provided then add it as a preferred
> console.
> 
> I've not tested this very extensively yet, but I want to get some
> feedback before I go further.
> 
> The one downside with this approach is that it doesn't do anything for
> early console setup. That still needs to be added on a per-driver basis,
> but at least it shouldn't conflict with this approach.

Looks sane to me (as discussed in person). I gave it a run on PWRficient with
and without console= line (8250-based uart), and it behaved as expected.

A couple of nits on the series, replied to two of the patches.

I'll give it a run through the board farm here too, but I'll keep console=
bootargs there for those boots at this time, too much to change to take it out
everywhere. :-)


-Olof

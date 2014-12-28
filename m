Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaL1OUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 09:20:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42179 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaL1OUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 09:20:16 -0500
Date: Sun, 28 Dec 2014 15:20:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: NeilBrown <neilb@suse.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
Message-ID: <20141228142010.GA3922@amd>
References: <20141211214801.4127.93914.stgit@notabene.brown>
 <20141211215943.4127.24792.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211215943.4127.24792.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> index 8c4fd0332028..b59501ee2f21 100644
> --- a/Documentation/devicetree/bindings/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
> @@ -39,6 +39,10 @@ Optional properties:
>    driver is allowed to detect support for the capability even without this
>    property.
>  
> +Optional child node:
> +- a platform device listed as a child node will be probed and
> +  powered-on whenever the tty is in use (open).
> +
>  Example:
>  
>  	uart@80230000 {

Hmm. Other devices may want it the other way around: probe the device
behind the uart, make it control power and open/close of the uart, and
hide the /dev/ttyXX from userspace...
								Pavel
								
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaKKSu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:50:26 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57671 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaKKSuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:50:23 -0500
Date: Tue, 11 Nov 2014 19:50:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, LeeJon@roeck-us.net
Subject: Re: [PATCH v6 00/48] kernel: Add support for power-off handler call
 chain
Message-ID: <20141111185019.GA29452@amd>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
 <20141110083347.GA29543@amd>
 <20141111182023.GA21970@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111182023.GA21970@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-11 10:20:23, Guenter Roeck wrote:
> On Mon, Nov 10, 2014 at 09:33:48AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > Introduce a system power-off handler call chain to solve the described
> > > problems.  This call chain is expected to be executed from the architecture
> > > specific machine_power_off() function.  Drivers providing system power-off
> > > functionality are expected to register with this call chain.  By using the
> > > priority field in the notifier block, callers can control power-off
> > > handler
> > 
> > Linus rather disliked the idea of notifier chains for this... And I
> > don't see how it got addressed.
> > 
> Hi all,
> 
> After more thought, I concluded that it is technically impossible to support
> multiple power-off handlers without some kind of list or call chain, no matter
> how it is called. Given the opposition from Linus and the power maintainers
> to the series, I decided to shelf it.

Well, you can still do preparations -- current code directly setting
pm_power_off is ugly -- so that if you want to switch to call chain
later, it will be easy.

And if that does not happen, we still get the cleanup :-).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

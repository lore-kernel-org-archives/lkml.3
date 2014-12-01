Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaLANEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:04:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50140 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaLANEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:04:39 -0500
Date: Mon, 1 Dec 2014 14:04:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sakari.ailus@iki.fi, s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
Message-ID: <20141201130437.GB24737@amd>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-3-git-send-email-j.anaszewski@samsung.com>
 <20141129125832.GA315@amd>
 <547C539A.4010500@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C539A.4010500@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >How are faults cleared? Should it be list of strings, instead of
> >bitmask? We may want to add new fault modes in future...
> 
> Faults are cleared by reading the attribute. I will add this note.
> There can be more than one fault at a time. I think that the bitmask
> is a flexible solution. I don't see any troubles related to adding
> new fault modes in the future, do you?

I do not think that "read attribute to clear" is good idea. Normally,
you'd want the error attribute world-readable, but you don't want
non-root users to clear the errors.

I am not sure if bitmask is good solution. I'd return space-separated
strings like "overtemp". That way, there's good chance that other LED
drivers would be able to use similar interface...

Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaEIHie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:38:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41636 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaEIHid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:38:33 -0400
Date: Fri, 9 May 2014 09:38:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Battery: Accelerate battery resume callback
Message-ID: <20140509073827.GA4965@xo-6d-61-c0.localdomain>
References: <1399183626-13152-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399183626-13152-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Most time of battery resume callback is spent on executing AML code
> _BTP, _BIF and _BIF to get battery info, status and set alarm. These
> AML methods may access EC operation regions several times and consumes
> time.
> 
> These operations are not necessary during devices resume and can run
> during POST_SUSPEND/HIBERNATION event when all processes are thawed.

Does it mean that userspace will see pre-hibernation battery level for a while 
after resume?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

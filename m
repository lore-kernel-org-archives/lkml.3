Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935650Ab3FUMoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:44:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37745 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab3FUMoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:44:34 -0400
Date: Fri, 21 Jun 2013 14:44:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH char-misc-next] UIO: Fix concurrency issue
Message-ID: <20130621124431.GA11224@amd.pavel.ucw.cz>
References: <201306201636.00535.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306201636.00535.vitas@nppfactor.kiev.ua>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-06-20 16:36:00, Vitalii Demianets wrote:
> In a SMP case there was a race condition issue between 
> uio_pdrv_genirq_irqcontrol() running on one CPU and irq handler on another 
> CPU. Fix it by spin_locking shared resources access inside irq handler.
> Also:
>   - Change disable_irq to disable_irq_nosync to avoid deadlock, because 
> disable_irq waits for the completion of the irq handler;
>   - Change atomic bit-manipulation routines to their non-atomic counterparts 
> as we already are guarding the code by spinlock.
> 
> Signed-off-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>

Sounds good.

Reviewed-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

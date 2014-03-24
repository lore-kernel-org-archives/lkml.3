Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaCXGWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:22:14 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:51842 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaCXGWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:22:13 -0400
Date: Mon, 24 Mar 2014 07:22:07 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        s390 <linux-s390@vger.kernel.org>
Subject: Re: [patch 01/16] s390: tape: Use del_timer_sync()
Message-ID: <20140324062207.GB4487@osiris>
References: <20140323150557.288925975@linutronix.de>
 <20140323150752.607059123@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323150752.607059123@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032406-4966-0000-0000-000008D34596
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 03:09:24PM -0000, Thomas Gleixner wrote:
> del_timer() does not wait for a possible running callback to
> complete. So the call side might free request and the associated
> objects while on another cpu the timer handler runs.

[...]

>  
> -	del_timer(&timeout);
> +	del_timer_sync(&timeout);

Applied, thanks.


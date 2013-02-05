Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3BEPe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:34:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774Ab3BEPeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:34:25 -0500
From: Oliver Neukum <oneukum@suse.de>
To: promwad_imap <michail.kurachkin@promwad.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>
Subject: Re: TDM bus support in Linux Kernel [PATCH]
Date: Tue, 05 Feb 2013 16:34:28 +0100
Message-ID: <5007545.bVNiTjB1se@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <6757302.20130204160858@promwad.com>
References: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp> <1445550.3M3gD8CvZe@linux-5eaq.site> <6757302.20130204160858@promwad.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2013 16:08:58 Michail Kurachkin wrote:
> Hi Oliver,
> 
> Thank you for the code review. I am working on the sources and soon
> will send you the update.
> 
> By the way, I did not find suitable implementation of software circular buffer management. src/include/linux/circ_buf.h seems to be very limited solution. 
> What do you think about adding the following functions/macros to the global namespace?

Additions to the global namespace needs to be done very carefully.

> int cb_init(struct circ_buf *cb, int item_size, int count);
> void cb_free(struct circ_buf *cb);
> int cb_push(struct circ_buf *cb, void *item);
> int cb_pop(struct circ_buf *cb, void *item);

void pointers here may be suboptimal

> int cb_is_full(struct circ_buf *cb);
> int cb_is_empty(struct circ_buf *cb);

I suggest you implement them in private and if they serve you well,
we can discuss making them global. The important point is that you
don't duplicate code.

	Regards
		Oliver


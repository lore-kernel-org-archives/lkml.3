Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab3AQJoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:44:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758245Ab3AQJoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:44:21 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, Alan Stern <stern@rowland.harvard.edu>,
        Minchan Kim <minchan@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v7 0/6] solve deadlock caused by memory allocation with I/O
Date: Thu, 17 Jan 2013 10:44:17 +0100
Message-ID: <2496969.ClbQ8gLATp@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CACVXFVOipr0VMyPQaZTLckxTaPan7ZneERUqZ1S_mYo11A5AeA@mail.gmail.com>
References: <1357352744-8138-1-git-send-email-ming.lei@canonical.com> <20130116153744.70210fa3.akpm@linux-foundation.org> <CACVXFVOipr0VMyPQaZTLckxTaPan7ZneERUqZ1S_mYo11A5AeA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2013 09:28:14 Ming Lei wrote:
>      - we still need some synchronization to avoid accessing the storage
>        between sys_sync and device suspend, just like system sleep case,
>        pm_restrict_gfp_mask is needed even sys_sync has been done
>        inside enter_state().
> 
> So looks the approach in the patch is simpler and more efficient, 

Even worse. The memory may be needed to resume and the reason
we need to resume may be that we need to write out memory. And
there is no way to make sure we don't dirty memory unless user space
is frozen, so it is either this approach, or GFP_NOIO in the whole resume
code path.

	Regards
		Oliver


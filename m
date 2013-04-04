Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763708Ab3DDHvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:51:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762603Ab3DDHvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:51:18 -0400
Date: Thu, 4 Apr 2013 09:51:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3.7+] HID: magicmouse: fix race between input_register()
 and probe()
In-Reply-To: <1364893912-29578-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1304040951020.30938@pobox.suse.cz>
References: <1364893912-29578-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Benjamin Tissoires wrote:

> Since kernel 3.7, it appears that the input registration occured before
> the end of magicmouse_setup_input(). This is shown by receiving a lot of
> "EV_SYN SYN_REPORT 1" instead of normal "EV_SYN SYN_REPORT 0".
> This value means that the output buffer is full, and the user space
> is loosing events.
> 
> Using .input_configured guarantees that the race is not occuring, and that
> the call of "input_set_events_per_packet(input, 60)" is taken into account
> by input_register().
> 
> Fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=908604
> 
> Reported-and-Tested-By: Clarke Wixon <cwixon@usa.net>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi Jiri,
> 
> this one can goes to stable (so 3.8) as well.

Applied, and will push for 3.9 still.

Thanks.

-- 
Jiri Kosina
SUSE Labs

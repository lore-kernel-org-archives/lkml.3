Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab3KDQPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:15:55 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46232 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554Ab3KDQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:15:53 -0500
Date: Mon, 4 Nov 2013 17:15:48 +0100
From: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, jic23@kernel.org,
        lars@metafoo.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] debugobject: add support for kref
Message-ID: <20131104161548.GA26097@breakpoint.cc>
References: <1382609345-29370-1-git-send-email-bigeasy@linutronix.de>
 <alpine.DEB.2.02.1310241615280.14242@ionos.tec.linutronix.de>
 <20131103193308.GA20998@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131103193308.GA20998@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.11.13, Sebastian Andrzej Siewior wrote:
> v1…v2:
> - not an RFC anymore
> - addressed tglx review:
>   - use debug_obj_descr with state active
>   - use debug_object_active_state() to check for active object instead the
>     other hack I had.
>   - added debug_object_free() in a way that does not interfere with the
>     NSA sniffer API so it does not get removed from the patch by accident.

now I just run into output like
|ODEBUG: free active (active state 0) object type: kref hint: gserial_alloc_line+0x90/0x194 [u_serial]

and yes I added a hint for that which points to where the kref got it
kref_init() call from. Now I am not sure if this a false positive
(we did kref_init() never used it so the whole struct was removed) or if
it really found something.
And while I hit this, I noticed that I really need a fixup function or
else debugobject will loop forever in __debug_check_no_obj_freed().

Sebastian

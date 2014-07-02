Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbaGBNa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:30:59 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:49085 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbaGBNa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:30:57 -0400
Date: Wed, 2 Jul 2014 09:30:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
Message-ID: <20140702133053.GB20071@mtj.dyndns.org>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
 <53B3F556.7050002@suse.cz>
 <20140702123002.GA20071@mtj.dyndns.org>
 <20140702134721.00163886@alan.etchedpixels.co.uk>
 <alpine.LNX.2.00.1407021459330.1655@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1407021459330.1655@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 02, 2014 at 03:01:16PM +0200, Jiri Kosina wrote:
>  static inline bool try_to_freeze(void)
>  {
> +       kgr_task_safe(current);
> +
>         if (!(current->flags & PF_NOFREEZE))
>                 debug_check_no_locks_held();
>         return try_to_freeze_unsafe();

Heh, I'm totally confused now.  Why is this correct?  What guarantees
that context is not carried across try_to_freeze()?

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab3BSKOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:14:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39935 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262Ab3BSKOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:14:45 -0500
Date: Tue, 19 Feb 2013 11:14:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Andy Ross <andy.ross@windriver.com>
Subject: Re: [PATCH] vt: add init_hide parameter to suppress boot output
Message-ID: <20130219101437.GA3396@xo-6d-61-c0.localdomain>
References: <1361266690-19382-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361266690-19382-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -165,6 +165,9 @@ module_param(global_cursor_default, int, S_IRUGO | S_IWUSR);
>  static int cur_default = CUR_DEFAULT;
>  module_param(cur_default, int, S_IRUGO | S_IWUSR);
>  
> +static int init_hide;
> +module_param(init_hide, int, S_IRUGO);
> +
>  /*
>   * ignore_poke: don't unblank the screen when things are typed.  This is
>   * mainly for the privacy of braille terminal users.
> @@ -734,6 +737,7 @@ static void visual_init(struct vc_data *vc, int num, int init)
>  	__module_get(vc->vc_sw->owner);
>  	vc->vc_num = num;
>  	vc->vc_display_fg = &master_display_fg;
> +	vc->vc_hidden = init_hide;
>  	vc->vc_uni_pagedir_loc = &vc->vc_uni_pagedir;
>  	vc->vc_uni_pagedir = 0;
>  	vc->vc_hi_font_mask = 0;
> @@ -2336,6 +2340,9 @@ static void console_callback(struct work_struct *ignored)
>  	if (want_console >= 0) {
>  		if (want_console != fg_console &&
>  		    vc_cons_allocated(want_console)) {
> +			if(want_console != SUSPEND_CONSOLE &&

"if (", please.

Otherwise looks ok.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

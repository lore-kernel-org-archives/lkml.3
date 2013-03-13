Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab3CMNvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:51:49 -0400
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:42362 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3CMNvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:51:48 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Mar 2013 09:51:48 EDT
Subject: Re: [PATCH 07/16] TTY: quatech2, remove unneeded is_open
To: jslaby@suse.cz (Jiri Slaby)
Date: Wed, 13 Mar 2013 09:46:01 -0400
Cc: gregkh@linuxfoundation.org, peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1362658360-26629-7-git-send-email-jslaby@suse.cz>
X-Mailer: ELM [version 2.5.8.59.gd925]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130313134601.ED7598028B@viridian.itc.virginia.edu>
From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby writes:
> 
> tty->ops->break_ctl cannot be called outside the gap between open and
> close. So there is no need to check whether the port is open in
> break_ctl in quatech2. Remove the check and also that member
> completely.
> 

We can't get rid of is_open.  The devices use 1 read urb for all ports
and will send various things about ports that haven't actually been
opened.  So the driver needs to know if a port has actually been
opened or not.  In fact, I was about to send a patch that fixes a
warning caused by commit 2e124b4a390ca85325fae75764bef92f0547fa25
causing the driver to try to write to ttys that weren't actually
opened.

The guard in qt2_break_ctl() can still be removed.


-- 
Bill

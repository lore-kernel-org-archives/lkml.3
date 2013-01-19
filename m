Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3ASDbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 22:31:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47135 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3ASDbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 22:31:05 -0500
Date: Sat, 19 Jan 2013 03:31:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 13/76] ARC: Low level IRQ/Trap/Exception Handling
Message-ID: <20130119033104.GD23552@ZenIV.linux.org.uk>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
 <1358511930-7424-14-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358511930-7424-14-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 05:54:27PM +0530, Vineet Gupta wrote:

> +	; --- (Slow Path #3) notify_resume ---
> +.Lchk_notify_resume:
> +	btst   r9, TIF_NOTIFY_RESUME
> +	blnz   @do_notify_resume
> +	b      resume_user_mode_begin	; unconditionally back to U mode ret chks
> +					; for single exit point from this block

Umm...  Can we even get there without NOTIFY_RESUME?  Again, there's
future-proofing and there's laying minefields - think what will happen
if we *do* get there with some bit in _TIF_WORK_MASK that isn't recognized
by any of these cases.  Looping forever?

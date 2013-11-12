Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3KLHbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:31:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3KLHb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:31:27 -0500
Date: Mon, 11 Nov 2013 16:15:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Conrad Gomes <conrad.s.j.gomes@gmail.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com, joe@perches.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: fix coding style issues in unioxx5.c
Message-ID: <20131112001540.GA26611@kroah.com>
References: <1383309116-8042-1-git-send-email-conrad.s.j.gomes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383309116-8042-1-git-send-email-conrad.s.j.gomes@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 06:01:56PM +0530, Conrad Gomes wrote:
> This is a patch which fixes  coding style issues in unioxx5.c found
> by checkpatch.pl
> 
> 1) Replaced printk with pr_info and pr_err

Drivers should never call printk() as they all have access to a struct
device somewhere.  So please call dev_info() or dev_err() instead.

> 2) Reinitialized n_subd before for loop to fix over 80 character
>    warning
> 3) Reworded comment to fix 80 character warning
>

Patches should do one thing, not 3 things.  Care to break this up into
"one logical change per patch"?  Yes, it's a small thing, but if you had
done this already, I could have taken the other 2 patches and you would
have just had to redo one patch in this series...

thanks,

greg k-h

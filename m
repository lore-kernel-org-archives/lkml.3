Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab3IHGh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 02:37:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3IHGhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 02:37:25 -0400
Date: Sat, 7 Sep 2013 23:40:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Message-ID: <20130908064027.GA3587@kroah.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 07:50:15PM -0400, Matthew Garrett wrote:
> kexec permits the loading and execution of arbitrary code in ring 0, which
> is something that module signing enforcement is meant to prevent. It makes
> sense to disable kexec in this situation.

I see no match between kexec and signed kernel modules.

In fact, I personally _want_ signed kernel modules, and still the option
to run kexec.  kexec is to run a whole new kernel/OS, not a tiny kernel
module.

If you apply this, you break everyone who is currently relying on kexec
(i.e. kdump, bootloaders, etc.), from using signed kernel modules, which
personally, seems like a very bad idea.

Please just rely on the existing permission checks for kexec, to add on
another layer of restrictions seems unneeded, and will force some users
to have to patch this out.

thanks,

greg k-h

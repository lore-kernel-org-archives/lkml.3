Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934685AbaGXU4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:56:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934543AbaGXU4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:56:21 -0400
Date: Thu, 24 Jul 2014 13:56:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Sasha Levin <sashal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb-core: Revert "usb-core: Remove Fix mes in file hcd.c"
Message-ID: <20140724205620.GB31160@kroah.com>
References: <1406120170-22983-1-git-send-email-sasha.levin@oracle.com>
 <20140723164910.GA8319@kroah.com>
 <53D106C9.8070803@oracle.com>
 <20140724160447.GC14956@kroah.com>
 <53D13255.4030004@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D13255.4030004@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 12:20:37PM -0400, Sasha Levin wrote:
> On 07/24/2014 12:04 PM, Greg KH wrote:
> >> If you add a revert and leave the original broken commit in, wouldn't it cause issues
> >> > for anyone trying to bisect a build breakage?
> > Yes it does.
> > 
> > I can not rebase my public trees, nor should any other kernel
> > maintainer.  This has been true for _many_ years.
> 
> This isn't the case with -mm, for example, where the tree does get edited
> quite often.

-mm is a set of quilt patches, not a git tree.

> What stops you from editing it even if people are working on it? 'git pull --rebase'
> will dtrt for both the ff and the non-ff case, where the non-ff case would have happen
> either way if those people kept tracking your -next tree.

No, subsystem maintainers are not allowed to break their trees like
this, unless something really major happens that requires it.

Again, it's been this way for years, and is one of the requirements of
subsystem maintainers.  If you want a "testing" branch, use a "testing"
branch, but don't cause problems on your "real" branch or problems will
happen.

thanks,

greg k-h

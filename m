Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219AbaJ3Q6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 12:58:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760688AbaJ3Q6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 12:58:00 -0400
Date: Thu, 30 Oct 2014 09:56:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jeff Epler <jepler@unpythonic.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: fix name of 'enable' sysfs file
Message-ID: <20141030165648.GA7402@kroah.com>
References: <20141030163028.GA22250@kroah.com>
 <alpine.LRH.2.00.1410301749560.11562@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1410301749560.11562@twin.jikos.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 05:50:41PM +0100, Jiri Kosina wrote:
> On Thu, 30 Oct 2014, Greg Kroah-Hartman wrote:
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Back in commit 5136b2da770d ("PCI: convert bus code to use dev_groups"),
> > I misstyped the 'enable' sysfs file as 'enabled', which broke the
> > userspace api.  This patch fixes that issue by renaming the file back.
> 
> But this is in turn 3.13 -> 3.18 userspace interface breakage ... I don't 
> think there is other graceful way out of this than creating a symlink so 
> that both variants work, right?

Given that no one noticed that this was broken until now, I really doubt
that anyone wrote code for the new file name.  I recommend just fixing
it back, and getting it into all stable kernel trees and moving on.

A symlink for such a foolish mistake seems like a bigger mistake :)

thanks,

greg k-h

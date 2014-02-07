Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaBGQjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:39:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaBGQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:39:04 -0500
Date: Fri, 7 Feb 2014 08:40:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seth Forshee <seth.forshee@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tty: Allow stealing of controlling ttys within user
 namespaces
Message-ID: <20140207164013.GA17653@kroah.com>
References: <1390402431-6371-1-git-send-email-seth.forshee@canonical.com>
 <8738kdq7ng.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738kdq7ng.fsf@xmission.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 03:31:15PM -0800, Eric W. Biederman wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
> 
> > root is allowed to steal ttys from other sessions, but it
> > requires system-wide CAP_SYS_ADMIN and therefore is not possible
> > for root within a user namespace. This should be allowed so long
> > as the process doing the stealing is privileged towards the
> > session which currently owns the tty.
> >
> > Update this code to only require CAP_SYS_ADMIN in the user
> > namespaces of the target session's tasks, allowing the tty to be
> > stolen from sessions whose tasks are in the same or lesser
> > privileged user namespaces.
> 
> This code looks essentially correct.  I would like to look at it a bit
> more before we merge it, just to ensure something silly hasn't been
> missed, but the only thing that concerns me at this point is are we
> checking the proper per task bits.
> 
> The case I am currently worrying about is a task that does something
> privileged drops perms sets dumpable and then calls setns() on the
> userns.
> 
> So I think we may have to solve the dumpable problem at the same time as
> we solve this issue.
> 
> Now I don't know if it makes sense to take this through the tty tree or
> my userns tree.  I am inclined to take it through the userns tree simply
> because I am reviewing it and I have seen the several failed attempts at
> this but if Greg wants it in the tty tree I won't object.

No objection from me.

thanks,

greg k-h

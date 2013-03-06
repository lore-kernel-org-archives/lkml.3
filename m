Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3CFB6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:58:44 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50702 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3CFB6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:58:41 -0500
Date: Tue, 05 Mar 2013 19:58:37 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: For review: pid_namespaces(7) man page
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <87k3pnhx2k.fsf@xmission.com> (from ebiederm@xmission.com on
	Mon Mar  4 11:52:19 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1362535117.7276.6@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2013 11:52:19 AM, Eric W. Biederman wrote:
> > How about this:
> >
> >        The  point  here is that unshare(2) and setns(2) change the  
> PID
> >        namespace for processes subsequently created by the caller,  
> but
> >        not  for the calling process, while clone(2) CLONE_VM  
> specifies
> >        the creation of a new thread in the same process.
> 
> Hmm.  How about this.
> 
>          The point here is that unshare(2) and setns(2) change the PID
>          namespace that will be used by in all subsequent calls to  
> clone
>          and fork by the caller, but not for the calling process, and
>          that all threads in a process must share the same PID
>          namespace.  Which makes a subsequent clone(2) CLONE_VM
>          specify the creation of a new thread in the a different PID
>          namespace but in the same process which is impossible.

CLONE_VM and CLONE_NEWPID are incompatible because all threads of the  
same process must be in the same PID namespace. Since unshare(2) and  
setns(2) change the PID namespace for subsequent calls to clone(2),  
those subsequent calls cannot create new threads (unless you setns(2)  
back to the original namespace first).

That last bit's a guess. :)

Rob
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965272Ab3DRDCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 23:02:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62189 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065Ab3DRDCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 23:02:43 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 17 Apr 2013 20:03:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Don Zickus <dzickus@redhat.com>, linux-watchdog@vger.kernel.org,
        kexec@lists.infradead.org, wim@iguana.be,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        dyoung@redhat.com
Subject: Re: [PATCH v3] watchdog: Add hook for kicking in kdump path
Message-ID: <20130418030303.GA7294@roeck-us.net>
References: <1366233596-34681-1-git-send-email-dzickus@redhat.com>
 <87li8gaku0.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li8gaku0.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 02:49:59PM -0700, Eric W. Biederman wrote:
> Don Zickus <dzickus@redhat.com> writes:
> 
> > A common problem with kdump is that during the boot up of the
> > second kernel, the hardware watchdog times out and reboots the
> > machine before a vmcore can be captured.
> >
> > Instead of tellling customers to disable their hardware watchdog
> > timers, I hacked up a hook to put in the kdump path that provides
> > one last kick before jumping into the second kernel.
> >
> > The assumption is the watchdog timeout is at least 10-30 seconds
> > long, enough to get the second kernel to userspace to kick the watchdog
> > again, if needed.
> 
> Why not double the watchdog timeout? and/or pet the watchdog a little
> more frequently.
> 
> This is the least icky hook I have seen proposed to be put on the kexec
> on panic path, but I still suspect this may reduce the ability to take a
> crash dump.  What happens if it was the watchdog timer that panic'd for
> example.
> 
That should be addressed by the use of mutex_trylock(), which should fail in
that case.

Guenter

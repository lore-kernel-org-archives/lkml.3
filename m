Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaLDOXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:23:13 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36436 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaLDOXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:23:11 -0500
Date: Thu, 4 Dec 2014 15:23:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 3.18 nohz + audit regression (Re: [PATCH] context_tracking:
 Restore previous state in schedule_user)
Message-ID: <20141204142301.GA3269@lerouge>
References: <CALCETrULjLf=WHn9TfRyFH+hac7FYKUWmfDm4_aZ3mP4jEpU3w@mail.gmail.com>
 <CA+55aFxKr+b3t-gcSg3zsLt5Rp_cR-XLwfXstAVur=gYD8UMVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxKr+b3t-gcSg3zsLt5Rp_cR-XLwfXstAVur=gYD8UMVA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 08:58:46PM -0800, Linus Torvalds wrote:
> On Wed, Dec 3, 2014 at 5:29 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > So, to summarize the choices for 3.18:
> >
> > 4. This patch.
> 
> I've applied it. The alternatives look worse, and the patch doesn't
> look bad. In many ways it looks better than the old user_exit/enter
> pair, although obviously the "schedule_user()" name is kind of odd
> now. Whatever.

That doesn't look like the safest approach to me. Somehow I felt more
comfortable with exception_enter/exit on the audit function.

A few other archs use schedule_user() as well, it's likely fine but I'm
not sure how subtle their path is.

Besides, is it possible that the audit function gets called after
syscall_trace_leave() or do_notify_resume()? If so, the patch won't fix
the issue entirely.

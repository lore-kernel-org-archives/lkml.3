Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab3BTSYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:24:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216Ab3BTSYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:24:43 -0500
Date: Wed, 20 Feb 2013 13:24:32 -0500
From: Dave Jones <davej@redhat.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: general protection fault in do_msgrcv  [3.8]
Message-ID: <20130220182432.GA32377@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stanislav Kinsbursky <skinsbursky@parallels.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20130219180441.GA27141@redhat.com>
 <512487FA.9090102@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512487FA.9090102@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 12:23:22PM +0400, Stanislav Kinsbursky wrote:

 > > Pid: 887, comm: trinity-child2 Not tainted 3.8.0+ #57 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
 > > RIP: 0010:[<ffffffff812aebba>]  [<ffffffff812aebba>] do_msgrcv+0x22a/0x670
 > > ...
 > > Looks like Stanislav recently changed this code, so problem was likely introduced
 > > in those changes.
 > >
 > 
 > Is it easy to reproduce? Do you use KVM?

Only hit it once so far, no KVM

 > There is a NULL selinux handler bug fix by Stephen Smalley here:
 > https://lkml.org/lkml/2013/2/6/663
 > 
 > But anyway, this bug fix affects only the case, when MSG_COPY flag is set.
 > 
 > And this is not your case, I suppose?

>From my reading of the traces, I'd say not. It looks like I'm oopsing before
we even get to the SELinux hooks.

	Dave


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaLCXbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:31:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbaLCXbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:31:39 -0500
Date: Wed, 3 Dec 2014 18:31:23 -0500
From: Dave Jones <davej@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] context_tracking: Restore previous state in schedule_user
Message-ID: <20141203233123.GA14771@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <20141203220836.GC31369@lerouge>
 <c6a6c2246188d25b9997848bbf39d5363c7a3da9.1417648389.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c6a6c2246188d25b9997848bbf39d5363c7a3da9.1417648389.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 03:18:41PM -0800, Andy Lutomirski wrote:
 > It appears that some SCHEDULE_USER (asm for schedule_user) callers
 > in arch/x86/kernel/entry_64.S are called from RCU kernel context,
 > and schedule_user will return in RCU user context.  This causes RCU
 > warnings and possible failures.
 > 
 > This is intended to be a minimal fix suitable for 3.18.
 > 
 > Reported-by: Dave Jones <davej@redhat.com>
 > Cc: Oleg Nesterov <oleg@redhat.com>
 > Cc: Frédéric Weisbecker <fweisbec@gmail.com>
 > Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
 > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
 > ---
 > 
 > Hi all-
 > 
 > This is intended to be a suitable last-minute fix for the RCU issue that
 > Dave saw.
 > 
 > Dave, can you confirm that this fixes it?

ACK, feel free to add my Tested-by:

	Dave

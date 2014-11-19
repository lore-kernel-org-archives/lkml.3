Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbaKSKxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:53:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51850 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbaKSKxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:53:15 -0500
Date: Wed, 19 Nov 2014 11:53:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC][PATCH 3/3] x86/nmi: Perform a safe NMI stack trace on all
 CPUs
Message-ID: <20141119105311.GB5617@pd.tnic>
References: <20141119043917.578498291@goodmis.org>
 <20141119045556.084787418@goodmis.org>
 <20141119104114.GA5684@pd.tnic>
 <alpine.LNX.2.00.1411191143520.4454@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411191143520.4454@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:44:56AM +0100, Jiri Kosina wrote:
> If we are going down this path, do_nmi() should be early enough to do
> it, no need to pollute NMI assembly code with this.

do_nmi() doesn't cover all, like do_machine_check(), do_double_fault(),
and the rest of the handlers. I'm suggesting to do it before any handler
gets run so that you can use printk in the handler itself.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

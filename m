Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab3CLUNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:13:55 -0400
Received: from two.firstfloor.org ([193.170.194.197]:36236 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3CLUNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:13:54 -0400
Date: Tue, 12 Mar 2013 21:13:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, david@gibson.dropbear.id.au,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Feng Hong <hongfeng@marvell.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: Regression with orderly_poweroff()
Message-ID: <20130312201351.GF11268@two.firstfloor.org>
References: <1363058712.4534.12.camel@pasglop>
 <CA+55aFzMKjk+bGbBrb5Qw-XDXaAXLMyrrpqMWH7o0duHq2wxzw@mail.gmail.com>
 <CAKi4VALkUhOtP_8BOi3Mi8fTz8TUPwmwQq7WW27BEDue2wFNRw@mail.gmail.com>
 <20130312182210.GA15862@redhat.com>
 <CA+55aFz9M1RWOwyRuatxnyQ+_ON0+A032QcW9=oBOks1JPt13w@mail.gmail.com>
 <20130312191118.GA17439@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312191118.GA17439@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Btw. There is another "strange" user, arch/x86/kernel/cpu/mcheck/mce.c.
> It uses mce_trigger_work to call call_usermodehelper(UMH_NO_WAIT).
> Why? UMH_NO_WAIT is already atomic. And the !work_pending() check is
> confusing, schedule_work(schedule_work) checks it is not pending.

I think you're right, the additional step shouldn't be needed.

The MCE Handler uses the trick to do this in MCE context if the
interrupts were enabled earlier. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

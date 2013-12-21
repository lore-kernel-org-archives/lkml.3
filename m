Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab3LUXNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 18:13:49 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:56743 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab3LUXNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 18:13:47 -0500
X-Greylist: delayed 681 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Dec 2013 18:13:47 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21174.7221.399380.512977@quad.stoffel.home>
Date: Sat, 21 Dec 2013 17:54:45 -0500
From: "John Stoffel" <john@stoffel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] speeding up the stat() family of system calls...
In-Reply-To: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>
References: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>
X-Mailer: VM 8.2.0b under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus> Here's both x86 people and filesystem people involved, because this
Linus> hacky RFC patch touches both.

Linus> NOTE NOTE NOTE! I've modified "cp_new_stat()" in place, in a way that
Linus> is x86-64 specific. So the attached patch *only* works on x86-64, and
Linus> will very actively break on anything else. That's intentional, because
Linus> that way it's more obvious how the code changes, but a real patch
Linus> would create a *new* cp_new_stat() for x86-64, and conditionalize the
Linus> existing generic "cp_new_stat()" on not already having an
Linus> architecture-optimized one.

As a SysAdmin, I'm always interested in any speedups to filesystem
ops, since I tend to do lots of trawling through filesystems with find
looking for data on filesystem usage, largest files, etc.  So this is
good news.  Any numbers of how much better this is?  I'm travelling
tomorrow, so I won't have time to spin up a VM and play, though it's
tempting to do so.

Thanks,
John

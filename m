Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3CRU5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:57:50 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:36941 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab3CRU5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:57:49 -0400
From: Timo Juhani Lindfors <timo.lindfors@iki.fi>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Kosina <jkosina@suse.cz>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        yrl.pp-manager.tt@hitachi.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Move hash_64() into .text.kprobe section
References: <20130311142233.19885.10567.stgit@mhiramat-M0-7522>
	<CA+55aFz28CvntOMF-Te0x=gn=XQcU8Zzi6E0iAhZb9mG5J-Ppg@mail.gmail.com>
	<514023AA.4070004@hitachi.com> <847glb8m4i.fsf@sauna.l.org>
	<51408349.8080800@hitachi.com>
Date: Mon, 18 Mar 2013 22:57:35 +0200
In-Reply-To: <51408349.8080800@hitachi.com> (Masami Hiramatsu's message of
	"Wed, 13 Mar 2013 22:46:49 +0900")
Message-ID: <84li9ke88w.fsf@sauna.l.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
> Thank you for reporting!!

Thanks for fixing these! I spent some time trying to automate the
process of finding sensitive functions and eventually resorted into
booting a kvm instance with a minimal initrd to test every single
function in a clean and reproducible environment.

I found 7 more cases where calling register_kprobe() leads to an instant
kernel panic:

__flush_tlb_single
native_flush_tlb
native_safe_halt
native_set_pgd
native_set_pmd
native_set_pud
native_write_cr0

You can see full kernel console output for each function at
http://lindi.iki.fi/lindi/linux/kprobes/panics_2013-03-18/

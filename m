Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3GJVtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:49:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35885 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab3GJVtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:49:05 -0400
Date: Wed, 10 Jul 2013 23:48:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
Message-ID: <20130710214848.GB14879@pd.tnic>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
 <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>
 <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>
 <51DDD3E9.6090601@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51DDD3E9.6090601@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 02:36:41PM -0700, H. Peter Anvin wrote:
> I'm wondering if it would be easier/more general to just return to the
> instruction. The "more general" bit would allow this to be used for
> other things, like alternatives, and perhaps eventually dynamic call
> patching.

Well, the aspect of not using stop_machine in alternatives is a don't
care because there we do text_poke_early on the BSP anyway. However,
there we toggle interrupts so it would probably be interesting to see
whether a non-interrupt-disabling variant would be faster.

> Returning to the instruction will, in effect, be a busy-wait for
> the faulted CPU until the patch is complete; more or less what
> stop_machine would do, but only for a CPU which actually strays into
> the affected region.

Oh, something like we patch in a two-byte jump first:

1:
	jmp 1b

until we finish patching the rest? Ha, interesting :).

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

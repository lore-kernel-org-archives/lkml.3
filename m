Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683Ab3LERtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:49:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55367 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933665Ab3LERt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:49:26 -0500
Date: Thu, 5 Dec 2013 18:49:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
 page directly
Message-ID: <20131205174923.GE14407@pd.tnic>
References: <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com>
 <20131203205400.GA25735@redhat.com>
 <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com>
 <20131204111125.GA26552@redhat.com>
 <529F51D9.7010001@zytor.com>
 <20131204164817.GA5271@redhat.com>
 <529F5E47.3040108@zytor.com>
 <CA+55aFyMx74jiKgS-o0axuuTBw7295UEMSf_vYDQCAghk3Vr=w@mail.gmail.com>
 <20131204174328.GA8082@redhat.com>
 <20131205172355.GA25780@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131205172355.GA25780@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 06:23:55PM +0100, Oleg Nesterov wrote:
> This is almost off-topic, but I am wondering if (in the long term) we
> can avoid this "insert the bp into every mm" altogether.
>
> Instead, uprobe_write_opcode() should only unmap this page and set

Ok, sorry if I'm completely off base here but have you guys tried
unmapping the page from all other VMs, patching it and causing all
the VMs to refault it thereby getting the updated content? During the
patching you'd probably need to cause the #PF handler to "loop" until
patching is complete though.

I don't know whether that is even doable/makes sense - just a dumb
idea...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaBIMjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 07:39:12 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:39655 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBIMjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 07:39:11 -0500
Date: Sun, 9 Feb 2014 13:39:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org
Subject: Re: [PROBLEM] x86: result of verify_local_APIC() is ignored
Message-ID: <20140209123907.GA21208@gmail.com>
References: <20140207004534.GI3232@feynman.vault24.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207004534.GI3232@feynman.vault24.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jon <nuxi@vault24.org> wrote:

> In arch/x86/kernel/apic/apic.c there is a function called
> verify_local_APIC() that does some APIC checks. The part where it writes
> to the APIC ID register can cause CPU #15 to not come online under
> VMware ESXi on 32-bit kernels if the virtual hardware version is 8.
> 
> I noticed that Ingo actually removed this exact chunk of code from
> arch/i386/kernel/apic.c in 2.6.4, but since it was left in the x86_64
> copy it came back when the two were merged.
> http://permalink.gmane.org/gmane.linux.kernel.commits.head/27538
> 
> The Intel architecture manuals seem to agree and notes that the recent
> Intel CPUs do not allow writing to the register which means that
> machines are actually failing this check... which doesn't matter becuase
> none of the callers are checking the return value of this function
> anyway.

I guess we could remove that from the 64-bit code too. Would you like 
to send a tested patch?

Thanks,

	Ingo

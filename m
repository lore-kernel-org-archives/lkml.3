Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaBGAwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 19:52:42 -0500
Received: from pinero.vault24.org ([69.164.212.126]:38899 "EHLO
	pinero.vault24.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaBGAwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 19:52:39 -0500
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Feb 2014 19:52:39 EST
Date: Thu, 6 Feb 2014 19:45:34 -0500
From: Jon <nuxi@vault24.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PROBLEM] x86: result of verify_local_APIC() is ignored
Message-ID: <20140207004534.GI3232@feynman.vault24.org>
Mail-Followup-To: linux-kernel@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/x86/kernel/apic/apic.c there is a function called
verify_local_APIC() that does some APIC checks. The part where it writes
to the APIC ID register can cause CPU #15 to not come online under
VMware ESXi on 32-bit kernels if the virtual hardware version is 8.

I noticed that Ingo actually removed this exact chunk of code from
arch/i386/kernel/apic.c in 2.6.4, but since it was left in the x86_64
copy it came back when the two were merged.
http://permalink.gmane.org/gmane.linux.kernel.commits.head/27538

The Intel architecture manuals seem to agree and notes that the recent
Intel CPUs do not allow writing to the register which means that
machines are actually failing this check... which doesn't matter becuase
none of the callers are checking the return value of this function
anyway.

-- 
Jon
X(7): A program for managing terminal windows. See also screen(1).

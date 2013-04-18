Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967576Ab3DRXpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 19:45:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44042 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967396Ab3DRXpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:45:09 -0400
Message-ID: <51708571.8080805@zytor.com>
Date: Thu, 18 Apr 2013 16:44:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>,
        Matt Fleming <matt@console-pimps.org>, matthew.garrett@nebula.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Darren Hart <darren.hart@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <516EAC4A.6040202@console-pimps.org> <516F1B90.9040508@nexus-software.ie> <516FD24A.3070502@console-pimps.org> <51706E8A.7030909@nexus-software.ie> <20130418230120.GA7078@jtriplet-mobl1>
In-Reply-To: <20130418230120.GA7078@jtriplet-mobl1>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 04:01 PM, Josh Triplett wrote:
> 
> I'd much rather see the code do the right thing automatically, rather
> than requiring an "unbreak me" command-line parameter.
> 
> But in any case, since BGRT is a "make my system look prettier" feature
> rather than core functionality, giving up on it on 32-bit EFI seems
> fairly reasonable, especially since it may still work if stored
> sufficiently low in memory.
> 

No, it really isn't.  Quite frankly, I don't understand why HIGHMEM
makes it any harder... in a lot of ways HIGHMEM memory is easier to deal
with because it is touched much later in the process.  Sure, it has to
be mapped before you can copy it out, but that usually isn't a big deal.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


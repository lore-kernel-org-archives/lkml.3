Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaDDNjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:39:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:56989 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbaDDNjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:39:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,795,1389772800"; 
   d="scan'208";a="514857748"
Message-ID: <533EB5F1.8060002@linux.intel.com>
Date: Fri, 04 Apr 2014 21:38:57 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mjg59@srcf.ucam.org, rostedt@goodmis.org, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org, Adam Williamson <awilliam@redhat.com>
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
References: <20140404064120.GB11877@gmail.com> <tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org> <20140404080006.GB6944@gmail.com>
In-Reply-To: <20140404080006.GB6944@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<cc to adam>

On 2014/4/4 16:00, Ingo Molnar wrote:
> 
>>
>> [PATCH] x86: Try the BIOS reboot method before the PCI reboot method
> 
> So, JFYI, I have put this into x86/reboot to get it tested, but it's 
> not queued up for upstream yet until there's concensus.
> 
> (Steve testing it wouldn't hurt either.)
> 
> Thanks,
> 
> 	Ingo

The change is originated from the following bug:
https://bugzilla.kernel.org/show_bug.cgi?id=70931

The system will hang after BIOS or TRIPLE if it doesn't work, that's why
I added CF9 before BIOS and TRIPLE.

Adam may want to try this change to see if reboot works on his DELL
Venue 8 Pro.

I don't think there is enough justification to revert the patch. We
introduce EFI into the default list, we didn't see any reason to remove
it out so far.

Thanks,
-Aubrey




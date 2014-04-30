Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132AbaD3Wqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:46:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:45841 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965000AbaD3Wqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:46:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,960,1389772800"; 
   d="scan'208";a="532739458"
Message-ID: <53617D54.2060709@linux.intel.com>
Date: Wed, 30 Apr 2014 15:46:44 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz> <535FA920.9080503@linux.intel.com> <alpine.LNX.2.00.1405010008420.10908@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1405010008420.10908@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 03:10 PM, Jiri Kosina wrote:
> On Tue, 29 Apr 2014, H. Peter Anvin wrote:
> 
>>> [2] 	"A special case can occur if an SMI handler nests inside an NMI 
>>> 	 handler and then another NMI occurs. During NMI interrupt 
>>> 	 handling, NMI interrupts are disabled, so normally NMI interrupts 
>>>  	 are serviced and completed with an IRET instruction one at a 
>>> 	 time. When the processor enters SMM while executing an NMI 
>>> 	 handler, the processor saves the SMRAM state save map but does 
>>> 	 not save the attribute to keep NMI interrupts disabled. 
>>> 	 Potentially, an NMI could be latched (while in SMM or upon exit) 
>>> 	 and serviced upon exit of SMM even though the previous NMI  
>>> 	 handler has still not completed."
>>
>> I believe [2] only applies if there is an IRET executing inside the SMM
>> handler, which should not normally be the case.  It might also have been
>> addressed since that was written, but I don't know.
> 
> Is there any chance that Intel would reveal what's behind this paragraph 
> and how likely it is to expect such BIOSes in the wild?
> 

I can ask internally and try to find out.  It  might very well be stale,
I don't know.

	-hpa



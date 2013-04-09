Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937197Ab3DIJqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:46:14 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55338 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935338Ab3DIJqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:46:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        kernel-hardening@lists.openwall.com,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Eric Northup <digitaleric@google.com>
References: <20130408224328.GA17641@www.outflux.net>
	<51634935.9010905@zytor.com>
Date: Tue, 09 Apr 2013 02:45:46 -0700
In-Reply-To: <51634935.9010905@zytor.com> (H. Peter Anvin's message of "Mon,
	08 Apr 2013 15:48:21 -0700")
Message-ID: <877gkc596d.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX197gmfRTVaIewM34i88nfGlKmoa149NlW4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.7 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] x86: make IDT read-only
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 04/08/2013 03:43 PM, Kees Cook wrote:
>> This makes the IDT unconditionally read-only. This primarily removes
>> the IDT from being a target for arbitrary memory write attacks. It has
>> an added benefit of also not leaking (via the "sidt" instruction) the
>> kernel base offset, if it has been relocated.
>> 
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: Eric Northup <digitaleric@google.com>
>
> Also, tglx: does this interfere with your per-cpu IDT efforts?

Given that we don't change any IDT entries why would anyone want a
per-cpu IDT?  The cache lines should easily be shared accross all
processors.

Or are there some giant NUMA machines that trigger cache misses when
accessing the IDT and the penalty for pulling the cache line across
the NUMA fabric is prohibitive?

Eric

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaB1UP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:15:58 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:48709 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaB1UP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:15:57 -0500
MIME-Version: 1.0
In-Reply-To: <1393572804.1019.14.camel@wall-e.seibold.net>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
 <cover.1393545985.git.luto@amacapital.net> <1393572804.1019.14.camel@wall-e.seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 28 Feb 2014 12:15:36 -0800
Message-ID: <CALCETrW5Z07cn+-r2qnyUDaC_XMujYtcT4zV2ztCOwo4qbfj9w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] vDSO fixes, on top of tip/x86/vdso
To: Stefani Seibold <stefani@seibold.net>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:33 PM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Donnerstag, den 27.02.2014, 16:18 -0800 schrieb Andy Lutomirski:
>> I'd still like someone else to confirm that the 32-bit vDSO is working
>> on all common configurations before I'm happy with it, but this should
>> be a considerable improvement.
>>
>> Someone who maintains the clock code should review the changes in:
>>
>>     commit 0fc8a237cbe98a06962f5ea37d24fc2369e23c74
>>     Author: Stefani Seibold <stefani@seibold.net>
>>     Date:   Wed Feb 19 10:09:10 2014 +0100
>>
>>         x86, vdso: Add 32-bit VDSO time support for the 64-bit kernel
>>
>> very carefully.
>>
>> There's still something extremely questionable about VDSO_PAGES in the
>> 32-bit vDSO code.  It appears to be terminally screwed up, and AFAICS it
>> only works at all because none of the 32-bit vDSO images ever exceed
>> 4096 bytes.
>>
>
> The 4096 bytes limit was not introduced by the patch set. It is still
> there for compatibility reason.

Compatibility with what?  And it doesn't look like there's a sane 4k
"limit".  It looks like the code with confuse itself and crash if the
image exceeds 4k.

But yes, this issue predates your code.

--Andy

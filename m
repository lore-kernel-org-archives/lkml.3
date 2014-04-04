Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaDDS0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:26:41 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:62051 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbaDDS0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:26:40 -0400
MIME-Version: 1.0
In-Reply-To: <533EDE6A.1050804@zytor.com>
References: <20140403113921.23dceb75@gandalf.local.home>
	<533D8516.1040803@zytor.com>
	<20140403121314.246b03a7@gandalf.local.home>
	<533DED74.6050202@linux.intel.com>
	<20140403194018.7c67aec7@gandalf.local.home>
	<533DF455.4040908@linux.intel.com>
	<533DF8D2.9060508@zytor.com>
	<533E0A94.5040007@linux.intel.com>
	<20140404151203.GA12370@srcf.ucam.org>
	<CA+55aFx+6ODkyueA2iHLhO8-eo95QYCBybhR63owxUMbhXh8wQ@mail.gmail.com>
	<20140404154520.GA14980@srcf.ucam.org>
	<533EDE6A.1050804@zytor.com>
Date: Fri, 4 Apr 2014 11:26:39 -0700
X-Google-Sender-Auth: s9O8CxcFmLW1da2xBzA5DIt6EHs
Message-ID: <CA+55aFxgg3UP-F3tAaeQKSMGO9Y9NZYG2DPip9PCzjPsksMKSw@mail.gmail.com>
Subject: Re: [BUG] x86: reboot doesn't reboot
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 9:31 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/04/2014 08:45 AM, Matthew Garrett wrote:
>>
>> Windows hits the keyboard controller and then tries the ACPI vector. It
>> then sleeps for a short period, then tries the keyboard controller again
>> and the ACPI vector again.
>>
>
> So do you think we should move the KBC upward in our priority list?
> That would seem to be the obvious thing to do...

Not likely to help. And certainly not Steve's problem. For him, moving
the *BIOS* reboot up would help.

I do think that to fix Steve's issue, we should probably remove the
PCI from the list of defaults again. So I agree with Matthew in that
sense, I'm just arguing that real production hardware still (sadly)
very much does need it.

             Linus

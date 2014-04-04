Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaDDQDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:03:50 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:44663 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaDDQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:03:47 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Apr 2014 12:03:46 EDT
Message-ID: <533ED5C4.7010609@mni.thm.de>
Date: Fri, 04 Apr 2014 17:54:44 +0200
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0a1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "Li, Aubrey" <aubrey.li@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
References: <20140403113921.23dceb75@gandalf.local.home> <533D8516.1040803@zytor.com> <20140403121314.246b03a7@gandalf.local.home> <533DED74.6050202@linux.intel.com> <20140403194018.7c67aec7@gandalf.local.home> <533DF455.4040908@linux.intel.com> <533DF8D2.9060508@zytor.com> <533E0A94.5040007@linux.intel.com> <20140404151203.GA12370@srcf.ucam.org> <CA+55aFx+6ODkyueA2iHLhO8-eo95QYCBybhR63owxUMbhXh8wQ@mail.gmail.com> <20140404154520.GA14980@srcf.ucam.org>
In-Reply-To: <20140404154520.GA14980@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04.04.2014 17:45, Matthew Garrett wrote:
> On Fri, Apr 04, 2014 at 08:38:42AM -0700, Linus Torvalds wrote:
>> On Fri, Apr 4, 2014 at 8:12 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>> Production hardware should never require CF9.
>> That's total BS.
>>
>> The fact is, we may be doing something wrong, but ACPI fails on a
>> *lot* of systems. A huge swath of Dell machines in particular for some
>> reason (laptops, desktops, _and_ now there's tablet reports).
> Which is almost certainly because the other reboot methods are trapping
> into SMI and hitting some hardware that we've left in a different state
> to Windows. CF9 may work around that, but the actual fix is to figure
> out why the firmware is wedging and fix it. Otherwise we're going to
> spend the rest of our lives maintaining a giant DMI list that's still
> going to be missing entries and users are going to be sad.
>
>> The keyboard controller is sadly unreliable too, although I really
>> don't understand why. Even when a legacy keyboard controller exists
>> (which isn't as universal as you'd think, even though the *hardware*
>> is pretty much guaranteed to be there in the chipset, it can be
>> disabled) there seem to be machines where the reset line isn't hooked
>> up. Don't ask me why. Same goes for the triple fault failure case.
> See: SMI. Or in the triple fault case, because there's some early init
> code that has the same issue. As far as I can tell Windows never triple
> faults, so again I think this is our fault at some level.
>
>> It would be interesting if somebody can figure out *exactly* what
>> Windows does, because the fact that a lot of Dell machines need quirks
>> almost certainly means that it's _us_ doing something wrong. Dell
>> doesn't generally do lots of fancy odd things. I pretty much guarantee
>> it's because we've done something odd that Windows doesn't do.
> Windows hits the keyboard controller and then tries the ACPI vector. It
> then sleeps for a short period, then tries the keyboard controller again
> and the ACPI vector again. This means that systems which put cf9 in the
> ACPI vector tend to work because of the second write, which is obviously
> not what the spec envisaged but here we are. The only time it hits CF9
> is when the ACPI tables tell it to.
>

Hi,
sorry to  get into the discussion at this random point, not at the 
starting point, but with the latest Linus Tree my system needs several 
minutes to reboot instead of some seconds, so this may be related. If I 
can help in any way, let me konw!

Thanks,
Tobias Klausmann

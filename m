Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaKOS2L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 13:28:11 -0500
Received: from one.firstfloor.org ([193.170.194.197]:45251 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaKOS2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 13:28:10 -0500
Date: Sat, 15 Nov 2014 19:28:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Request for help: what did I do wrong with idtentry?
Message-ID: <20141115182806.GZ12538@two.firstfloor.org>
References: <CALCETrXdaEYjjfsTYySDXZvBHON10-EQRftV-OSCWTKMsUfOtg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293D455@ORSMSX114.amr.corp.intel.com>
 <CALCETrVLwzhQVMbu2c=NCzAfEBWa8=SOpfu5gPoxpuTBcNngRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVLwzhQVMbu2c=NCzAfEBWa8=SOpfu5gPoxpuTBcNngRA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not
> completely thrilled with what it does to double_fault, though.  If we
> somehow get a double fault caused by an interrupt hitting userspace
> with a bad kernel_stack, then we'll end up page faulting in the
> double_fault prologue.  I'm not convinced that this is worth worrying
> about.  It would be easy enough to fix, though, even if it would
> further uglify the code.

If you're "cleaning up" good and working code the functionality should
be the same as before. The old code handled this situation fine. 
So your new code should handle this too.

In general yes handling all the corner cases makes code ugly.
That is how the existing code got how it became.

-Andi


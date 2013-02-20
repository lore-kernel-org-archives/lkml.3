Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964820Ab3BTEMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:12:00 -0500
Received: from li44-10.members.linode.com ([72.14.181.10]:38287 "EHLO
	plausible.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934191Ab3BTEL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:11:58 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2013 23:11:58 EST
Message-ID: <51244B35.8090006@windriver.com>
Date: Tue, 19 Feb 2013 20:04:05 -0800
From: Andy Ross <andy.ross@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] vt: add init_hide parameter to suppress boot output
References: <1361289224-10678-1-git-send-email-kirill.shutemov@linux.intel.com> <20130220014512.GC31018@kroah.com>
In-Reply-To: <20130220014512.GC31018@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 05:45 PM, Greg Kroah-Hartman wrote:
>> When vt.init_hide is set, suppress output on newly created consoles
>> until an affirmative switched to that console.  This prevents boot
>> output from displaying (and clobbering splash screens, etc...)
>> without disabling the console entirely.
>
> What's wrong with the 'quiet' option we have?  And you forgot to
> document this.

You're right about docs, obviously.  I'll write something up and send
it tomorrow morning.

But setting "quiet" controls logging.  It won't prevent the console
from doing a buffer clear or mode switch, nor will it prevent
userspace from writing to it, nor will the buffer rewrites due to the
console switches that happen on suspend and resume (which I didn't
know existed) be suppressed.

There's a (sort of) similar commonly-used option, vga=current, which
prevents a mode switch for the special case of VGA/vesa.  But that
doesn't work with the framebuffer console.

The idea here (and I'm clearly no domain expert) was to leave the
console enabled and active, but invisible by default.  So nothing
displays, the splash screen stays put, and nothing fights with other
users of the framebuffer.  And it stays that way until something
affirmatively switches to a different VT using chvt or Alt-Fn or
whatever.

To be fair, a lot of this could be managed in userspace with the VT_*
ioctl interface.  But the specific application here (Android's
surfaceflinger) isn't set up for that, and it's a non-trivial API (and
even doing it "right" involves racing against other users at startup).
This seemed like a much simpler metaphor that still meets the
requirements.

Andy



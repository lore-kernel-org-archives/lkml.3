Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab3BTQyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 11:54:52 -0500
Received: from li44-10.members.linode.com ([72.14.181.10]:59143 "EHLO
	plausible.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758726Ab3BTQyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 11:54:50 -0500
Message-ID: <5124FFD7.8070708@windriver.com>
Date: Wed, 20 Feb 2013 08:54:47 -0800
From: Andy Ross <andy.ross@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] vt: add init_hide parameter to suppress boot output
References: <1361289224-10678-1-git-send-email-kirill.shutemov@linux.intel.com> <20130220014512.GC31018@kroah.com> <51244B35.8090006@windriver.com> <20130220044506.GA2728@kroah.com>
In-Reply-To: <20130220044506.GA2728@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 08:45 PM, Greg Kroah-Hartman wrote:
 > On Tue, Feb 19, 2013 at 08:04:05PM -0800, Andy Ross wrote:
 > > There's a (sort of) similar commonly-used option, vga=current, which
 > > prevents a mode switch for the special case of VGA/vesa.  But that
 > > doesn't work with the framebuffer console.
 >
 > Why not?  Can't you fix that?

I'd argue that's what this is.  If you were going to design a "shut up
the console" feature from scratch, would you choose to do it in one
particular display driver or would you do it in the device-independent
console code by forcing the already-existing "visible" flag to false?

 > > But the specific application here (Android's surfaceflinger) isn't set
 > > up for that, and it's a non-trivial API (and even doing it "right"
 > > involves racing against other users at startup).
 >
 > How could there be any other users at startup, you "own" the system
 > here, there should not be anyone to race with.

Tell that to the display hardware. :)

Seriously, every Linux box with a display (to first approximation,
obviously I didn't test them all while writing this message) spits
something to the screen between the moment where the bootloader hands
off control and the display driver is initialized.  Most of them
glitch a little at suspend time because of the console switch there.
I just reproduced both of these effects with a Fedora 18 live image.

This fixes almost all of that (vga=current is still required because
some early logging somewhere seems to write to the screen by banging
registers directly and not using the console), and it does it in a way
that works without having to modify existing userspace or (try to)
remove the framebuffer console entirely.

Andy


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbbAOQnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:43:40 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:40136 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbbAOQni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:43:38 -0500
Date: Thu, 15 Jan 2015 18:40:54 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Darren Hart <dvhart@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] platform-drivers-x86 for 3.19
Message-ID: <20150115164054.GA21675@node.dhcp.inet.fi>
References: <20141218175126.GA78864@vmdeb7>
 <20150111225802.GA12944@node.dhcp.inet.fi>
 <20150112183831.GA99900@vmdeb7>
 <CAObL_7FCiZJuTQNUfqjoxaRscB+_2fvwpnXDt3d8E+0dFm=i6A@mail.gmail.com>
 <20150112200331.GA23277@node.dhcp.inet.fi>
 <CAObL_7FwxW=oq9L+POVx_4S9HSZW2QM3bnTNW37rDsUA=-U3FA@mail.gmail.com>
 <20150112203003.GB23277@node.dhcp.inet.fi>
 <CAObL_7HNXAxnoNx-K=yJ1C9kkffc9Rf=EmVGJ+=K+5S40m7jSQ@mail.gmail.com>
 <20150113175609.GB130525@vmdeb7>
 <CAObL_7HDckMzgbbaKEH=iYwRdn24ANy5U8EMp=A3ODhWMt_2bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7HDckMzgbbaKEH=iYwRdn24ANy5U8EMp=A3ODhWMt_2bw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:04:55AM -0800, Andrew Lutomirski wrote:
> On Tue, Jan 13, 2015 at 9:56 AM, Darren Hart <dvhart@infradead.org> wrote:
> > On Mon, Jan 12, 2015 at 02:12:44PM -0800, Andrew Lutomirski wrote:
> >> On Mon, Jan 12, 2015 at 12:30 PM, Kirill A. Shutemov
> >> <kirill@shutemov.name> wrote:
> >> > On Mon, Jan 12, 2015 at 12:05:45PM -0800, Andrew Lutomirski wrote:
> >> >> On Mon, Jan 12, 2015 at 12:03 PM, Kirill A. Shutemov
> >> >> <kirill@shutemov.name> wrote:
> >> >> > On Mon, Jan 12, 2015 at 10:42:11AM -0800, Andrew Lutomirski wrote:
> >> >> >> On Mon, Jan 12, 2015 at 10:38 AM, Darren Hart <dvhart@infradead.org> wrote:
> >> >> >> > On Mon, Jan 12, 2015 at 12:58:02AM +0200, Kirill A. Shutemov wrote:
> >> >> >> >> On Thu, Dec 18, 2014 at 09:51:27AM -0800, Darren Hart wrote:
> >> >> >> >> > thinkpad-acpi using software mute simplifies the driver and the user experience
> >> >> >> >> > significantly.
> >> >> >> >>
> >> >> >> >> Except when it doesn't.
> >> >> >> >>
> >> >> >> >> I'm probably in minority, but I don't use fancy userspace to mess with my
> >> >> >> >> mixer and the mute button worked just fine for me before the change.
> >> >> >> >> Wasted half an hour to find out what happened is not a pure win from user
> >> >> >> >> experience point of view.
> >> >> >> >>
> >> >> >> >> Is it really necessary to have software_mute_requested == true by default?
> >> >> >> >> Can fancy userspace ask for desired behaviour instead and change kernel to
> >> >> >> >> not send hotkeys change notification until software_mute is enabled?
> >> >> >> >>
> >> >> >> >> --
> >> >> >> >>  Kirill A. Shutemov
> >> >> >> >>
> >> >> >> >
> >> >> >> > Thanks for the report Kirill,
> >> >> >> >
> >> >> >> > Andy, we're at RC4, so if we need to fix (or revert) this fix, we only have a
> >> >> >> > couple weeks to do so.
> >> >> >> >
> >> >> >> > Kirill, to define the scope of the problem, if you specify
> >> >> >> > software_mute_requested as false on the kernel command line, does your system
> >> >> >> > function as expected?
> >> >> >>
> >> >> >> If I understood Kirill's email correctly, the only issue is that he
> >> >> >> liked the old behavior.  Kirill, is that correct?
> >> >> >
> >> >> > Yes. For now I use thinkpad_acpi.software_mute=0 to get old behaviour.
> >> >> >
> >> >>
> >> >> What aspect of the old behavior is better than the new default behavior?
> >> >
> >> > It's not necessary better. The new behavior just broke my use-case.
> >> >
> >> > I don't have anything in my system what would react on KEY_MUTE and I used
> >> > the functionality platform provides until it suddenly stopped working.
> >> >
> >> > I personally can live with new thinkpad_acpi. I'll probably update my
> >> > configuration to react on the software button.
> >> >
> >> > But who else will get frustrated after update to v3.19?
> >>
> >> Can you try the equivalent of:
> >>
> >> bindsym XF86AudioMute exec amixer -q set Master toggle
> >>
> >> for your desktop environment?  Note that this is exactly what you'd do
> >> if you were using any laptop that wasn't a thinkpad.
> >
> > Unless we hear back from Kirill on why this isn't workable, I'm inclined to
> > leave this as is. Between the kernel module option and this keybinding,
> > equivalent behavior can be easily achieved, and the general use case is
> > significantly improved.
> >
> > The current gap appears to be the mute LED in the button itself, which can be
> > addressed moving forward.
> 
> I should have clarified this better.  The command:
> 
> amixer -q set Master toggle
> 
> should toggle the mute LED in sync with the master mixer on all
> ThinkPad models with a mute LED.  This works on my X220, and Borislav
> confirmed off-list that it works on his X230.  If there's a ThinkPad
> with a mute LED on which this doesn't work, then IMO it's a bug and
> should be fixed.

Okay. Mute and mute led works. Any idea how to get mic mute led work?
What happend to your patch on the topic?

http://permalink.gmane.org/gmane.linux.drivers.platform.x86.devel/1962

-- 
 Kirill A. Shutemov

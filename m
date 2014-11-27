Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaK0W4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 17:56:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaK0W4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 17:56:47 -0500
Date: Thu, 27 Nov 2014 17:56:37 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141127225637.GA24019@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Don Zickus <dzickus@redhat.com>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141126002501.GA11752@redhat.com>
 <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
 <20141126024032.GA13246@redhat.com>
 <20141126225745.GA30346@redhat.com>
 <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 11:17:16AM -0800, Linus Torvalds wrote:
 > On Wed, Nov 26, 2014 at 2:57 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > So 3.17 also has this problem.
 > > Good news I guess in that it's not a regression, but damn I really didn't
 > > want to have to go digging through the mists of time to find the last 'good' point.
 > 
 > So I'm looking at the watchdog code, and it seems racy wrt parking and startup.
 > 
 > In particular, it sets the high priority *after* starting the hrtimer,
 > and it goes back to SCHED_NORMAL *before* canceling the timer.
 > 
 > Which seems completely ass-backwards. And the smp_hotplug_thread stuff
 > explicitly enables preemption around the setup/cleanup/part/unpark
 > operations.
 > 
 > However, that would be an issue only if trinity might be doing things
 > that enable and disable the watchdog. And doing so under insane loads.
 > Even then it seems unlikely.
 > 
 > The insane loads you have. But even then, could a load average of 169
 > possibly delay running a non-RT process for 22 seconds? Doubtful.
 > 
 > But just in case: do you do cpu hotplug events (that will disable and
 > re-enable the watchdog process?).  Anything else that will part/unpark
 > the hotplug thread?

That's root-only iirc, and I'm not running trinity as root, so that
shouldn't be happening. There's also no sign of such behaviour in dmesg
when the problem occurs.

 > Quite frankly, I'm just grasping for straws here, but a lot of the
 > watchdog traces really have seemed spurious...

Agreed.

Currently leaving 3.16 running. 21hrs so far.

	Dave


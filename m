Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968012Ab3HIPwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:52:01 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:58588 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934068Ab3HIPv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:51:58 -0400
MIME-Version: 1.0
In-Reply-To: <000e01ce94af$12710ef0$37532cd0$%jun@samsung.com>
References: <CAD=FV=U3aT1KKtSwAFhYURJJerp70ij8h647=xyV51et4jYipg@mail.gmail.com>
	<CAOesGMjaF2K0CnuWBj7xdXGAQk-XRetBstaQdd9EZzBYrmDjeA@mail.gmail.com>
	<86mworfzsf.fsf@void.printf.net>
	<000e01ce94af$12710ef0$37532cd0$%jun@samsung.com>
Date: Fri, 9 Aug 2013 08:51:57 -0700
Message-ID: <CAD=FV=X9G66zg+OQ5C0gkkkYDdrkegkZdmWNXRDiS2V5_yY+6w@mail.gmail.com>
Subject: Re: dw_mmc: Does anyone use multiple slots?
From: Doug Anderson <dianders@google.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sonny Rao <sonnyrao@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 8, 2013 at 8:18 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Fri, August 09, 2013, Chris Ball wrote:
>> On Fri, Aug 09 2013, Olof Johansson wrote:
>> > On Thu, Aug 8, 2013 at 5:16 PM, Doug Anderson <dianders@google.com> wrote:
>> >
>> >> I guess my overall question is: if there are no actual implementations
>> >> of multislot, shouldn't we kill it and simplify the code a whole lot?
>> >> If someone out there has a real multislot device they can step back in
>> >> and do it more correctly?
>> >>
>> >> Of course we need to find someone to actually go through and do the
>> >> killing of multislot, but finding that person might be easier if there
>> >> was some agreement that it was good to do.
>> >
>> > There clearly seems to be no in-tree users of multislot. If someone
>> > new comes in, we have the code in the history and can revert the
>> > removal (or at least use it as reference for re-introduction).
>> >
>> > I vote for removing it. It adds really annoying complexity for
>> > something that nobody uses.
>>
>> I agree with Olof, for what it's worth.  (The maintainers of the
>> driver are Jaehoon and Seungwon, though.)
>
> I feel like there is no actual use case for that though origin Synopsys IP supports.
> Multi-slot  might be not useful in terms of performance because shared bus should be allowed.
> (At least this is the way I see it, though)
> As Exynos's host does so, other hosts which are introduced in Linux seems use one card per host.
> If it's really not found now, I could agree on this topic.

This all sounds very promising.  Certainly we should wait a little
longer to see if others find / respond to this thread, but otherwise
we can go ahead?

It's possible to do this in somewhat small steps.  I think the first
step is to remove num_slots and remove all loops over num_slots.  That
actually sounds pretty easy/small, though it will touch a lot of code.
 After that we can try to move things out of the separate slot
structure, I think.  That might be a bit of a bigger change.  I can
keep that as a back burner task, but I wouldn't object at all to
someone else doing it!  ;)

The big question, though, is what to do about device tree bindings
(cringe).  Really bus-width, wp-gpios, and disable-wp ought to be
promoted up and we should remove the "slot" subnode.  ...but that of
course breaks the stable API.

-Doug

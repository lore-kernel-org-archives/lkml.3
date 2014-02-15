Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaBOEO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 23:14:58 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:51267 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaBOEOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 23:14:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140215041119.GA29012@kroah.com>
References: <1391820619-25487-1-git-send-email-courtney.cavin@sonymobile.com>
	<CAJe_ZhfgNUN5=azLrjyLLkh262zv2oBP-ioS8xtBWPonOPacrA@mail.gmail.com>
	<20140215034046.GA26468@kroah.com>
	<CAJe_Zhe-n6bYUYcbhfHhZ6Cc-8h5Ag7D69hd4G9AtFPjFkWsug@mail.gmail.com>
	<20140215041119.GA29012@kroah.com>
Date: Sat, 15 Feb 2014 09:44:55 +0530
Message-ID: <CAJe_ZhegDnRHHtn3_2Oz_Mx_hRAzG6ta1n62=b2NSON4YeDbSQ@mail.gmail.com>
Subject: Re: [RFC 0/6] mailbox: add common framework and port drivers
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>,
        "Anna, Suman" <s-anna@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Tony Lindgren <tony@atomide.com>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        Pawel Moll <pawel.moll@arm.com>, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Loic Pallardy <loic.pallardy@st.com>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Craig McGeachie <slapdau@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 February 2014 09:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, Feb 15, 2014 at 09:27:48AM +0530, Jassi Brar wrote:
>> On 15 February 2014 09:10, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Sat, Feb 15, 2014 at 09:02:07AM +0530, Jassi Brar wrote:
>> >> Hi,
>> >>
>> >> On 8 February 2014 06:20, Courtney Cavin <courtney.cavin@sonymobile.com> wrote:
>> >> > There is currently no common framework for mailbox drivers, so this is my
>> >> > attempt to come up with something suitable.  There seems to be a need for
>> >> > making this generic, so I have attempted to do just that.  Most of this is
>> >> > modeled pretty strongly after the pwm core, with some influences from the clock
>> >> > core.
>> >> >
>> >> > Looking at the existing use-cases, and some new ones, it would appear that the
>> >> > requirements here are rather simple. We need essentially two things for
>> >> > consumers:
>> >> >         - put_message
>> >> >         - callback for receiving messages
>> >> >
>> >> > The code currently uses atomic notifiers for callbacks.  The common omap core
>> >> > deals with fifos and work-queues in order to escape atomic contexts, but from
>> >> > what I can see, this is unneeded.  I am also of the opinion that the contexts
>> >> > can be much better managed in the drivers which are working with these
>> >> > contexts, rather than generically.
>> >> >
>> >> > Hopefully this will be suitable for the plethora of other drivers around the
>> >> > kernel which implement mailboxes, as well.  In any case, I'm rather interested
>> >> > to see what the rest of the world thinks.
>> >> >
>> >> > Keep in mind that while the pl320 & omap code should compile, I don't currently
>> >> > have a platform on which I can perform proper testing.  I also removed the
>> >> > context save/restore code from omap2 mailbox support, because I think it should
>> >> > be able to be done via driver suspend/resume, but haven't done a full
>> >> > investigation just yet.
>> >> >
>> >> > I'm also aware that breaking omap, just to fix it again probably isn't the best
>> >> > course of action, and I'm open to suggestions.
>> >> >
>> >> Did you try to look up the history of mailbox api development?  Google
>> >> search: 'mailbox common api'
>> >>
>> >> I (Linaro/Fujitsu), Suman Anna (TI), LeyFoon Tan (Intel), Craig
>> >> McGeachie(Broadcom) and Loic Pallardy(ST) already worked a generic
>> >> Mailbox framework and infact have controller drivers working over
>> >> them.
>> >>  For some confidentiality and some lazy and some confusion or whatever
>> >> reasons the final version of drivers and API wasn't submitted upstream
>> >> yet.
>> >
>> > Then, in all reality, it doesn't exist at all, and so, we will evaluate
>> > this submission instead.
>> >
>> > Just because you all can't send something for merging, doesn't mean you
>> > get to block someone else who has got their act together, that's not
>> > fair.
>> >
>> Yup probably not much fair. But then also one usually look for any
>> early development efforts. IIRC only I and Anna started. Others later
>> joined us looking at archives. Not to vindicate our gang though.
>>
>>  Now we could either punish us and have this api tread the same
>> development path where everyone had their requirements (and the
>> only-waiting-for-approval controller drivers to convert) .... OR we
>> could see if our/original/old API just works for the purposes of Sony
>> as well (which it will most probably) and then we could upstream it
>> with one more 'works-for-me-too'.
>
> What is stopping you submitting your patches right now?
>
Nothing. I'll freshen it up and submit today.

Thanks.

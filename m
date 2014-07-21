Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbaGUNzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:55:23 -0400
Received: from smtp206.alice.it ([82.57.200.102]:51277 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099AbaGUNzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:55:21 -0400
Date: Mon, 21 Jul 2014 15:55:01 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/4] Rename hid-lenovo-tpkbd to hid-lenovo
Message-Id: <20140721155501.5c223e1e00518c7bb94d0835@ao2.it>
In-Reply-To: <alpine.DEB.2.02.1407181016170.17078@marmot.wormnet.eu>
References: <1405236262-8070-1-git-send-email-jm@lentin.co.uk>
	<1405236262-8070-2-git-send-email-jm@lentin.co.uk>
	<20140714114227.161b4bf0767e1bbf3268852c@ao2.it>
	<alpine.DEB.2.02.1407181016170.17078@marmot.wormnet.eu>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014 10:35:35 +0100 (BST)
Jamie Lentin <jm@lentin.co.uk> wrote:

> On Mon, 14 Jul 2014, Antonio Ospite wrote:
> 
> > On Sun, 13 Jul 2014 08:24:19 +0100
> > Jamie Lentin <jm@lentin.co.uk> wrote:
> >
> >> Rename module and all functions within so we can add support for other
> >> keyboards in the same file. Rename the _tp postfix to _tpkbd, to
> >> signify functions relevant to the TP USB keyboard.
> >>
> >> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
> >
> > Reviewed-by: Antonio Ospite <ao2@ao2.it>
> >
> > Patch looks good to me, easier to validate now :)
> >
> > A few ideas below for some possible _future_ cleanups, but no reason to
> > hold this one any longer IMHO.
> >
> > Ciao,
> >   Antonio
> >
> >> ---
> >>  ...er-hid-lenovo-tpkbd => sysfs-driver-hid-lenovo} |   0
> >>  drivers/hid/Kconfig                                |  14 +-
> >>  drivers/hid/Makefile                               |   2 +-
> >>  drivers/hid/hid-core.c                             |   2 +-
> >>  drivers/hid/{hid-lenovo-tpkbd.c => hid-lenovo.c}   | 185 +++++++++++----------
> >>  5 files changed, 102 insertions(+), 101 deletions(-)
> >>  rename Documentation/ABI/testing/{sysfs-driver-hid-lenovo-tpkbd => sysfs-driver-hid-lenovo} (100%)
> >>  rename drivers/hid/{hid-lenovo-tpkbd.c => hid-lenovo.c} (64%)
> >>

[...]
> >> -static int tpkbd_features_set(struct hid_device *hdev)
> >> +static int lenovo_features_set_tpkbd(struct hid_device *hdev)
> >>  {
> >>  	struct hid_report *report;
> >> -	struct tpkbd_data_pointer *data_pointer = hid_get_drvdata(hdev);
> >> +	struct lenovo_drvdata_tpkbd *data_pointer = hid_get_drvdata(hdev);
> >
> >
> > I think the word "pointer" here is misleading, sometimes in other parts
> > of the driver it is used as a synonym of trackpoint, but
> > lenovo_drvdata_tpkbd also contains data about leds, so here it looks
> > like it refers to C pointers. I'd call the variable tpkbd_data or
> > tpkbd_drvdata, throughout the driver. What do you think?
> 
> Yes, the rationale behind the name really isn't obvious but all meanings 
> are sorta correct, so it's not that bad :P
> 
> I like tpkbd_drvdata better though, and can correct it in the compact 
> keyboard code too. I wanted to make the variable names match, but didn't 
> get around to it, so will do it next time around.
>

IMHO you can very well use data_pointer for now so the names are
consistent with the current ones; a cleanup can be done later to make
the naming more straightforward too.

> > And the driver could standardize on the word "trackpoint" where
> > appropriate in order to eliminate any ambiguity.
> 
> The key other place I can think of that this happens is for the USB 
> compact keyboard, for it's HID_TYPE_USBMOUSE half (versus the keyboard 
> half). Saying trackpoint there is a mis-truth, since it's also where all 
> the extra keys hide. But I'll have a look through anyway.
> 

I meant: where "pointer" means trackpoint let's just use "trackpoint",
where pointer means "not keyboard" (like in data_pointer apparently)
something else can be used if "trackpoint" is too specific.

But again, this is cleanup: it'd be nice to have it eventually but not
worth blocking this patchset.

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

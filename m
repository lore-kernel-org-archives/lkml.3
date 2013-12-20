Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3LTWgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 17:36:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57676 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3LTWgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 17:36:23 -0500
Date: Fri, 20 Dec 2013 23:36:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Herrmann <dh.herrmann@gmail.com>
cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HID: input: fix input sysfs path for hid devices
In-Reply-To: <CANq1E4QrPAJ7zNdN51PGQD5tkD_gTYfRoHOg7=zwVvnu-xOR0g@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1312202335300.11949@pobox.suse.cz>
References: <1387469113-4129-1-git-send-email-benjamin.tissoires@redhat.com> <CANq1E4QrPAJ7zNdN51PGQD5tkD_gTYfRoHOg7=zwVvnu-xOR0g@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, David Herrmann wrote:

> <benjamin.tissoires@redhat.com> wrote:
> > we used to set the parent of the input device as the parent of
> > the hid bus. This was introduced when we created hid as a real bus, and
> > to keep backward compatibility. Now, it's time to proper set the parent
> > so that sysfs has an idea of which input device is attached to
> > which hid device.
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > ---
> >
> > Hi Jiri,
> >
> > well, the regression test did not showed anything bad, and a look at the hid
> > drivers also showed that no drivers should be armed by that.
> >
> > I think this is valuable because it will give a better understanding of the
> > actual mapping hardware/inputs. Like a touchscreen with pen + touch will have
> > the same hid parent, and I expect X/Wayland to be able to detect this at some
> > point to keep the mapping correctly between the two input devices and the screen.
> >
> > I also need that for hid-replay, so that I can be sure which input is attached
> > to which uhid device, and give up the heuristics I currently use.
> 
> I was just wondering where we have multiple HID devices on a single
> parent, but yeah, uhid is a good example. I actually have no
> objections to this patch and it looks fine. But I cannot tell whether
> anyone relies on this.
> 
> I'd say we should give it a try.

Agreed, let's take it for 3.14, and if anyone complains about breakage 
caused by this (which I don't expect), we'll revert to the previous state.

-- 
Jiri Kosina
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434AbaGQQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:59:24 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40985 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbaGQQ7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:59:22 -0400
From: Dmitry Torokhov <dtor@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bastien Nocera <hadess@hadess.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrik Fimml <patrikf@chromium.org>, linux-pm@vger.kernel.org,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Power-managing devices that are not of interest at some point in time
Date: Thu, 17 Jul 2014 09:59:19 -0700
Message-ID: <3088260.XkiUM6Vtxh@dtor-glaptop>
Organization: Google, Inc.
User-Agent: KMail/4.13.2 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1407171029210.1517-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1407171029210.1517-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 17, 2014 10:39:16 AM Alan Stern wrote:
> On Wed, 16 Jul 2014, Dmitry Torokhov wrote:
> > We are not planning on implementing the policy in kernel, that's
> > indeed task for userspace; but unless we bring in the heavy hammer of
> > forcibly unbinding drivers, we do not currently have universal
> > mechanism of quiescing devices.
> 
> We sort of do: the ->freeze() callback.  But it wasn't intended for
> this kind of use; drivers may very well expect that userspace will
> already be frozen when the callback runs.  Besides, ->freeze() is
> supposed to quiesce devices without powering them down, whereas you
> want to do both.

Right.

> 
> What you're asking for is different from anything the PM subsystem has
> done before.

Right.

> Given this fact, I don't see any alternatives to adding a
> new API or repurposing an existing API.  Either one would be somewhat
> painful.
> 
> For example, we could arrange to invoke ->suspend().  However, since
> the circumstances would be unusual (userspace is still running,
> ->prepare() was not called beforehand, ->suspend_irq() won't be called
> afterward), subsystems and drivers may very well react inappropriately.

I do not think anybody expects that drivers would not have to be modified to 
support this functionality; I expect drivers would have to declare themselves 
"queiscable" and therefore would assert that they will act according to 
whatever rules we set up. I only want to make sure that this new state is 
added to existing list of PM states rather than creating completely new 
facility, so that driver authors have a chance to understand PM state 
transitions that involve their driver. 

Thanks,
Dmitry


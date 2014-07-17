Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbaGQOjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:39:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54750 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932880AbaGQOjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:39:17 -0400
Date: Thu, 17 Jul 2014 10:39:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dtor@google.com>
cc: Bastien Nocera <hadess@hadess.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Patrik Fimml <patrikf@chromium.org>, <linux-pm@vger.kernel.org>,
        Benson Leung <bleung@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Power-managing devices that are not of interest at some point
 in time
In-Reply-To: <CAE_wzQ8HERY+EX_5kjfHML-eu2cxv5ihhYt2nCn34Zws4mgS-A@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1407171029210.1517-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014, Dmitry Torokhov wrote:

> We are not planning on implementing the policy in kernel, that's
> indeed task for userspace; but unless we bring in the heavy hammer of
> forcibly unbinding drivers, we do not currently have universal
> mechanism of quiescing devices.

We sort of do: the ->freeze() callback.  But it wasn't intended for
this kind of use; drivers may very well expect that userspace will
already be frozen when the callback runs.  Besides, ->freeze() is
supposed to quiesce devices without powering them down, whereas you
want to do both.

What you're asking for is different from anything the PM subsystem has
done before.  Given this fact, I don't see any alternatives to adding a
new API or repurposing an existing API.  Either one would be somewhat
painful.

For example, we could arrange to invoke ->suspend().  However, since
the circumstances would be unusual (userspace is still running,
->prepare() was not called beforehand, ->suspend_irq() won't be called
afterward), subsystems and drivers may very well react inappropriately.

Alan Stern


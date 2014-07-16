Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaGPXRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:17:18 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48267 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaGPXRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:17:10 -0400
Date: Wed, 16 Jul 2014 16:17:07 -0700
From: Patrik Fimml <patrikf@chromium.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Patrik Fimml <patrikf@chromium.org>, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dtor@google.com>, Benson Leung <bleung@google.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Power-managing devices that are not of interest at some point in
 time
Message-ID: <20140716231707.GA24781@google.com>
References: <20140716013206.GA13409@google.com>
 <5611777.bNi5p029gt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5611777.bNi5p029gt@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 01:11:31AM +0200, Rafael J. Wysocki wrote:
> Let me try to understand the scenario in the first place.
> 
> To start with, a number of devices is in use (that is, open, there are
> applications listening/talking to them etc).  Now, an event happens, such
> as a laptop lid close and you want some of those devices, but possibly
> not all of them, to quiesce themselves and go into low-power states.
> 
> Is that correct?

Yes, that is accurate.

The primary example is a laptop with an external monitor and mouse
attached which you're using with the lid closed. You want the mouse to
work, but input from the touchpad that might result from the lid being
close to it should be skipped. Also, the touchpad should enter a
low-power state.

We think that triggering this is probably best done in userspace, but
we would need a way of telling devices to quiesce themselves.

And as Oliver has pointed out, it might be desirable to preserve some
state/settings of devices. And it's probably undesirable to go through
the whole process of completely unregistering the device and then
probing/resetting/configuring it again.

Kind regards,
Patrik

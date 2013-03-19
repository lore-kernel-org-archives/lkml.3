Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3CSBE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 21:04:26 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:38415 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3CSBEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 21:04:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130319000656.GC6516@kroah.com>
References: <1363215451-26111-1-git-send-email-jwerner@chromium.org>
	<20130318230922.GA23175@kroah.com>
	<CAODwPW9c6NpDOzmh+q312qLn0fS+eQttQDGdCe0b2EigoJ9_PA@mail.gmail.com>
	<20130319000656.GC6516@kroah.com>
Date: Mon, 18 Mar 2013 18:04:23 -0700
X-Google-Sender-Auth: IQvutF86K9_-9zdRE7aLp-MbLJM
Message-ID: <CAODwPW-5wTyqqQjRiTzgwa=QfKUwx09L6b0Mt+r-Laxk5XoLew@mail.gmail.com>
Subject: Re: [PATCH] usb: Make USB persist default configurable
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sameer Nanda <snanda@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What drivers/devices don't work with persist?  We need to know that now,
> otherwise all other distros and users have problems, right?

We have seen a problem with the LTE modem in the Chromebook Pixel
using the usb/serial/option.c driver, but we are not quite sure of the
root cause yet. It occasionally seems to loose its power session due
to autosuspend and then hit core/hub.c:check_port_resume_type(), where
it gets the reset_resume flag if persist is enabled. However, since
the option driver does not implement the (optional) reset_resume
method, this eventually ends up leaving the device in a state where it
is neither working nor getting cleanly reenumerated.

We are still actively investigating that issue to figure out the
underlying bug (not sure whether it is a general problem with drivers
that do not implement reset_resume... also, we are still only on 3.4
and have not tried to confirm it on 3.8 yet). However, as we generally
hadn't intended persist to be active and this had slipped through our
(admittedly very crude) userspace implementation, I proposed this
patch so that going forward our devices could always have the persist
setting we intend for them at all times.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab3ENAKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:10:11 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59664 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3ENAKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:10:09 -0400
Date: Mon, 13 May 2013 16:20:17 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] HID: input: return ENODATA if reading battery attrs fails
Message-ID: <20130513232017.GA25489@teo>
References: <1368457290-1734-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1368457290-1734-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 05:01:30PM +0200, David Herrmann wrote:
[..]
> I really dislike the way power_supply core calls into the drivers during the
> "add" uevent. If a driver holds an I/O mutex (or anything else), it might
> even deadlock in a very non-obvious way. Is there a reason why we need to
> pass _all_ battery properties along "add" and "remove" uevents? Isn't it
> enough to pass them with "change" uevents? This would guarantee that the
> power_supply callbacks are only called from user-context and "change" events.

I don't think that there is a particular reason for that, but if you want
to change that, then I'd suggest to still keep uevent reporting of all the
properties on "add" and "remove" events, but don't actually call the
drivers' callback, just assume ENODATA.

This way we well preserve the behaviour of the older kernels, so that
userland will not break if, for example, it allocates needed memory on
"add" event, and then assumes that "change" will follow the pattern.

Thanks,

Anton

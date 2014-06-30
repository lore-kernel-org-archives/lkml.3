Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaF3ITo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:19:44 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:51804 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbaF3ITm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:19:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140630065955.GD7687@nuc-i3427.alporthouse.com>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
	<1401980308-5116-5-git-send-email-daniel.vetter@ffwll.ch>
	<1602327.OGkKxHtt2b@grover>
	<3945293.Jtp4nyZMfX@grover>
	<20140630065955.GD7687@nuc-i3427.alporthouse.com>
Date: Mon, 30 Jun 2014 10:19:41 +0200
Message-ID: <CANq1E4SafCPgzuPyJ0=iunyC1bi9OZ18O8g-yXRJT8ZfLjNwGA@mail.gmail.com>
Subject: Re: [PATCH 5/5] drm/i915: Kick out vga console
From: David Herrmann <dh.herrmann@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Ed Tomlinson <edt@aei.ca>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Jun 30, 2014 at 8:59 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Sat, Jun 28, 2014 at 11:55:19PM -0400, Ed Tomlinson wrote:
>> On Saturday 28 June 2014 15:28:22 Ed Tomlinson wrote:
>>
>> Resend without html krud which causes list to bounce the message.
>>
>> > Hi
>> >
>> > This commit ( a4de05268e674e8ed31df6348269e22d6c6a1803 ) hangs my boot with 3.16-git.  Reverting it lets the boot proceed.
>> >
>> > I have an i7 with a built-in i915 and an pcie r7 260x.  The R7 is the primary console.  The i915 is initialized
>> > but does not have a physical display attached.
>> >
>> > With the patch applied the boot stops at the messages:
>> >
>> > [drm] Memory usable by graphics device = 2048M
>> > [drm] Replacing VGA console driver
>
> The issue looks like that we are ripping out the radeon fb_con whilst it
> is active and that upsets everyone. In which case, I think the
> compromise is:

do_take_over_console() should only touch console-drivers like fbcon.
How does this affect the underlying fbdev device? Ripping out active
or inactive fbcon should be just fine, shouldn't it?

Given that this hard-locks at kick_out_vgacon(), this looks more like
a dead-lock to me.

Thanks
David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaJVQqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:46:10 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:38238 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaJVQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:46:06 -0400
Message-ID: <5447DF2D.7090109@gmail.com>
Date: Wed, 22 Oct 2014 19:45:33 +0300
From: Giedrius Statkevicius <giedriuswork@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>,
        Darren Hart <dvhart@infradead.org>
CC: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] platform: hp_accel: add a i8042 filter to remove
 accelerometer data
References: <1413665962-3830-1-git-send-email-giedriuswork@gmail.com> <20141021214508.GF20951@vmdeb7> <5447AF1F.1060806@gmail.com> <5447BD06.70109@tremplin-utc.net>
In-Reply-To: <5447BD06.70109@tremplin-utc.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.10.22 17:19, Éric Piel wrote:
> On the HP laptop I had (with HPQ0004), no fake keys were reported.
I guess this is a new "feature", then.

> It should be noted that on my laptop, the accelerometer is completely
> decoupled from the hard disk. For example, when freefall is detected,
> nothing else happens (that's why you need to run a daemon that will
> listen to the event, and park the disk head). Looking at the bug report,
> it seems your laptop does a lot behind the OS, because apparently the
> disk head is parked automatically. So maybe the scancodes is a new

I'm sorry if I made the impression that it happens automatically but
actually I am running a daemon compiled from
Documentation/laptops/freefall.c. Nothing else is running on top of
linux to park the head when a free fall is detected.

> "feature" they have added in order to more easily report what's
> happening in the back.
> Now, more related to your proposed solution: is this really what we
> want? What's wrong with the current state excepted for some warning
> messages in dmesg? Do we really want to plain drop this information

Well, these are not just a few messages but a lot of them and they clog
the system log, makes it hard to notice the actual useful information,
wastes disk space, etc.

> provided by the hardware? How about just associating the scancodes to
> meaningful keycodes? (I guess one reason no to do that is that it'd
> likely require creating new keycodes corresponding to these pretty
> atypical events in the input layer).

The free fall detection is already handled by lis3lv02d and hp_accel on
hp laptops with this feature and information is provided through
/dev/freefall so, in my opinion, the way to go is to completely drop
these scancodes.

> 
> Is there maybe some general policy about what do to hardware that
> generate such special scancodes?

Really not sure. BTW, I wonder if the same stuff happens on HPQ6007.

Thanks,
Giedrius

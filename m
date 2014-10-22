Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaJVO2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:28:10 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:54421 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbaJVO2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:28:08 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2014 10:28:07 EDT
X-Spam-Flag: NO
X-Spam-Score: -20.918
Message-ID: <5447BD06.70109@tremplin-utc.net>
Date: Wed, 22 Oct 2014 16:19:50 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Giedrius Statkevicius <giedriuswork@gmail.com>,
        Darren Hart <dvhart@infradead.org>
CC: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] platform: hp_accel: add a i8042 filter to remove
 accelerometer data
References: <1413665962-3830-1-git-send-email-giedriuswork@gmail.com> <20141021214508.GF20951@vmdeb7> <5447AF1F.1060806@gmail.com>
In-Reply-To: <5447AF1F.1060806@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/10/14 15:20, Giedrius Statkevicius wrote:
:
> My questions are these:
> - Does any system with the accelerometer whose ACPI id is HPQ0004 or
>   HPQ6007 run into the same issues?
> - If so, what are the scancodes reported by atkbd?
> - If not, then where can I find some documentation to find about this?
>   HP doesn't seem to have published any.
> 
> If other people have the same issue with the same scancodes on 
> accelerometers with different ACPI ids we can go ahead and do what this
> patch does without reacting to what hardware the user has.
> 
> And a general question about what other people think of doing this?
> Maybe there is some better way I don't know of.

Hi,
On the HP laptop I had (with HPQ0004), no fake keys were reported.

It should be noted that on my laptop, the accelerometer is completely
decoupled from the hard disk. For example, when freefall is detected,
nothing else happens (that's why you need to run a daemon that will
listen to the event, and park the disk head). Looking at the bug report,
it seems your laptop does a lot behind the OS, because apparently the
disk head is parked automatically. So maybe the scancodes is a new
"feature" they have added in order to more easily report what's
happening in the back.

Now, more related to your proposed solution: is this really what we
want? What's wrong with the current state excepted for some warning
messages in dmesg? Do we really want to plain drop this information
provided by the hardware? How about just associating the scancodes to
meaningful keycodes? (I guess one reason no to do that is that it'd
likely require creating new keycodes corresponding to these pretty
atypical events in the input layer).

Is there maybe some general policy about what do to hardware that
generate such special scancodes?

Cheers,
Éric

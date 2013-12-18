Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3LRIMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 03:12:47 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53569 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3LRIMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 03:12:45 -0500
MIME-Version: 1.0
In-Reply-To: <190d226e64e177a3cb631b8fc6f4787c.squirrel@mungewell.org>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
	<190d226e64e177a3cb631b8fc6f4787c.squirrel@mungewell.org>
Date: Wed, 18 Dec 2013 09:12:45 +0100
Message-ID: <CANq1E4SDTLzkiWWaAmZ3iU1mSTc2Ce5E=zKHthxrsuDnBUYYMw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Input: ABS2 and friends
From: David Herrmann <dh.herrmann@gmail.com>
To: Simon Wood <simon@mungewell.org>
Cc: "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Input Tools <input-tools@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Dec 17, 2013 at 10:28 PM,  <simon@mungewell.org> wrote:
>> Hi
>>
>> This implements the recently discussed ABS2 API. It's working fine on my
>> machine with libevdev. Comments welcome!
>
> Just looking at the documentation file, I have a couple of suggestions.
>
> 1). Make a note on the direction of gravity wrt the example image. Ie what
> which axis/value will be positive with the device laid flat/stationary on
> a desk. Might just prevent some confusion later.

Yepp, can add that to the Accelerometer section.

> 2). Calibration, Accels and Gyros are noisy in different ways. Gyros tend
> to be wrong in the long term, giving some consistant bias which should be
> calibrated out. Accels are noisy in the short term, but generally right
> over a long period.

I'm not entirely sure where to put calibration/normalization. Letting
user-space deal with that should simplify things a lot. We could even
add it to libevdev. Comments welcome..

> Am I correct that the event framework will provide time-stamping of data,
> thus making computation of relative movements possible.

Yes, part of the evdev API.

Thanks
David

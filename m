Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaB0EjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:39:15 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:40334 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaB0EjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:39:14 -0500
MIME-Version: 1.0
In-Reply-To: <1393454296-32735-1-git-send-email-cworth@cworth.org>
References: <1393454296-32735-1-git-send-email-cworth@cworth.org>
Date: Wed, 26 Feb 2014 20:39:12 -0800
Message-ID: <CAF8JNh+7p7-cNkBv3CB3ZVsi7JrqzPf1bdzsA4rJqKUcY=dZ0Q@mail.gmail.com>
Subject: Re: wacom: Fixes for stylus pressure values for Thinkpad Yoga
From: Ping Cheng <pinglinux@gmail.com>
To: Carl Worth <cworth@cworth.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carl,

Thank you for the heads up. I believe Jason's patchset 4 of 4
(http://www.spinics.net/lists/linux-input/msg29435.html) fixed the
issue for your device and for other's. The patch was submitted last
month. If you can test the set on your device and give us a Tested-by
here, it will help Dmitry to merge the patch upstream.

Thank you for your effort.

Ping

On Wed, Feb 26, 2014 at 2:38 PM, Carl Worth <cworth@cworth.org> wrote:
> This series of patches fixes the pressure values reported for the
> wacom tablet built-in to a Lenovo ThinkPad Yoga laptop. Prior to this
> patch series, if I slowly increased stylus pressure, (expecting a
> gradual increase of values from 0 to 1023), I instead received values
> that increased slowly to 255, then reset to 0 and increased slowly
> again, etc.
>
> The buggy arithmetic that is updated here appears to exist in
> identical forms for other drivers. I did not update any code that I
> was not able to test directly. But it looks like wacom_pl_irq and
> wacom_dtu_irq potentially have similar bugs, (depending on the actual
> pressure_max values encountered in practice).
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

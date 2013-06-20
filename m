Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030383Ab3FTU2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:28:25 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33368 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965269Ab3FTU2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:28:23 -0400
Message-ID: <51C365E0.1060000@gmail.com>
Date: Thu, 20 Jun 2013 22:28:16 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: David Airlie <airlied@linux.ie>,
        Darren Etheridge <darren.etheridge@gmail.com>,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] drm/i2c: tda998x: fix sync generation and calculation
References: <1371757563-27862-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130620200624.GQ2718@n2100.arm.linux.org.uk>
In-Reply-To: <20130620200624.GQ2718@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 10:06 PM, Russell King - ARM Linux wrote:
> On Thu, Jun 20, 2013 at 09:46:03PM +0200, Sebastian Hesselbarth wrote:
>> +	ref_pix      = 3 + mode->hsync_start - mode->hdisplay;
>> +	de_pix_s     = mode->htotal - mode->hdisplay;
>> +	de_pix_e     = de_pix_s + mode->hdisplay;
>> +	hs_pix_s     = mode->hsync_start - mode->hdisplay;
>> +	hs_pix_e     = hs_pix_s + mode->hsync_end - mode->hsync_start;
>
> Correct, however, these can be simplified.
[...]
> These calculations are the same as what was originally in the driver:
>
> +       de_start   = mode->htotal - mode->hdisplay;
> +       de_end     = mode->htotal;
> +       hs_start   = mode->hsync_start - mode->hdisplay;
> +       hs_end     = mode->hsync_end - mode->hdisplay;
>
> when it was first committed.
>
> This is otherwise exactly what I came up with which gets my TV working
> again in HDMI mode.

Russell,

I am fine with any way to describe de/hs but you should notice that
I also modified refpix/refline and added interlaced sync. With the
original sync calculation, on some modes there was source blanking
captured by TDA998x which was also visible in the output image. I
chose the above description to make it more readable.

Also the patch takes care of input sync and output sync inversion
while the original driver always expected positive HS/VS.

I tested these sync settings on 4 DVI monitors and TV sets all
accepted each mode perfectly. Especially, not-so-cheap TV sets
are very picky about wrong sync.

Sebastian

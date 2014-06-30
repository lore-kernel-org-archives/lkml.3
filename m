Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbaF3NDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:03:10 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:51625 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbaF3NDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:03:07 -0400
Message-ID: <53B16006.1080605@vmware.com>
Date: Mon, 30 Jun 2014 15:03:02 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christopher Friedt <chrisfriedt@gmail.com>
CC: dri-devel <dri-devel@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-graphics-maintainer@vmware.com
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com> <CAPM=9tx4hdU0PZqdZcCd-x3HMu+6ZsGibeOHZPLe3OpW9Wsa0g@mail.gmail.com> <533A8E52.5050304@vmware.com> <CAF4BF-Rmxqbbd_xroQbRTWeE2NfKAZm=Jm7SG2bNppHV2odYNA@mail.gmail.com> <53B14E9E.3040505@vmware.com> <CAF4BF-T4VZQtd_3wWfNQ_==KJE0z0N5XonG4jcy=Ys5x_XxJ=w@mail.gmail.com> <53B15A94.3010402@vmware.com> <CAF4BF-TiHkaaOejH6p1QnnepfOxmvirds3vQD2YdXih_6kkUpQ@mail.gmail.com>
In-Reply-To: <CAF4BF-TiHkaaOejH6p1QnnepfOxmvirds3vQD2YdXih_6kkUpQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 02:49 PM, Christopher Friedt wrote:
> On Mon, Jun 30, 2014 at 8:39 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>> xf86-video-vmware in kms mode uses the kernel driver to set these registers.
>> FWIW, the modesetting part of the kernel driver uses SVGA_REG_PITCHLOCK
>> instead of
>> SVGA_REG_BYTES_PER_LINE to set the pitch. That's probably where the
>> clash happens.
> That sounds a bit more accurate. Should kms and fbdev be setting both
> registers then?

>From a quick browse of the device code, it looks like
SVGA_REG_BYTES_PER_LINE is intended for reading only, but I've asked the
experts that are on US time.

However, since the function
vmw_kms_write_svga()
should set up the pitch correctly using PITCHLOCK, could you just try
reverting the last line of your patch, the one that says

vmw_write(vmw_priv, SVGA_REG_BYTES_PER_LINE, info->fix.line_length);

That should hopefully fix the new bug and leave fbdev working as you
intended.

Thanks,
Thomas

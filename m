Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab3EBA5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:57:32 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36965 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3EBA5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:57:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAKMK7uF=4spN_+BtwnXhWvNs4GjM1iXPCN6aTupPkykQqqnU2A@mail.gmail.com>
References: <20130502000206.GH15623@pd.tnic>
	<CAKMK7uF=4spN_+BtwnXhWvNs4GjM1iXPCN6aTupPkykQqqnU2A@mail.gmail.com>
Date: Thu, 2 May 2013 10:57:27 +1000
Message-ID: <CAPM=9tw-Ssu7ZYBZX7ipGt9w7zYG91tKbWZguM5DLPaqTakJPA@mail.gmail.com>
Subject: Re: WARNING: at drivers/gpu/drm/drm_crtc.c:82 drm_warn_on_modeset_not_all_locked+0x8d/0xc0()
From: Dave Airlie <airlied@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 10:41 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Thu, May 2, 2013 at 2:02 AM, Borislav Petkov <bp@alien8.de> wrote:
>> Hi,
>>
>> I'm seeing this when booting latest Linus tree + tip/master in kvm.
>> Config is attached. Looks like it cannot find root fs and panics and
>> calls the panic notifier which screams in drm_crtc.c because not all
>> modeset locks are taken. Maybe bogus?
>
> Locking in the drm panic notifiere is completely bogus (as in simply
> does not exist). The only difference is that with the new locking
> scheme in 3.9 we're now pretty obnixious about checking for these
> kinds of things. Also, drm drivers love to sleep in the panic
> handlers, too. It's somewhere on my giant list of things to fix in drm
> land, but I'm not sure whether I'll get around to it in this life or
> the next. Maybe we just need to shut up the WARN in case of a panic
> ...

Maybe? of course you do.

its a panic, getting anything on the screen is vastly more important than
the locking being perfect, any chance of any info landing on the screen
is being decreased by this spew.

Dave.

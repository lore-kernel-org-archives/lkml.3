Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804AbaFTIal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:30:41 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:60014 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934388AbaFTIai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:30:38 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140619234243.GA8952@kroah.com>
References: <20140618102957.15728.43525.stgit@patser>
	<20140618103653.15728.4942.stgit@patser>
	<20140619011327.GC10921@kroah.com>
	<CAF6AEGv4Ms+zsrEtpA10bGq04LnRjzVb925co49eVxh4ugkd=A@mail.gmail.com>
	<20140619170059.GA1224@kroah.com>
	<CAKMK7uFa57YjeJCFQhWFr_5cRTTpWxBdJ1qtb5Ojnu-KZpe-Lw@mail.gmail.com>
	<20140619200159.GA27883@kroah.com>
	<53A366B3.8020808@zytor.com>
	<20140619234243.GA8952@kroah.com>
Date: Fri, 20 Jun 2014 10:30:37 +0200
X-Google-Sender-Auth: dWBQutslKNBqrucj8PYScJWA-qM
Message-ID: <CAKMK7uEdv81HRWA2ON+tgutut2KiQsaT_NjELko9NXk88JsGrg@mail.gmail.com>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization (v17)
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rob Clark <robdclark@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 1:42 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> I'm actually concerned about this trend.  Downgrading things to WARN_ON
>> can allow a security bug in the kernel to continue to exist, for
>> example, or make the error message disappear.
>
> A BUG_ON makes any error message disappear pretty quickly :)
>
> I'm talking about foolish "ASSERT-like" BUG_ON that driver authors like
> to add to their code when writing it to catch things they are messing
> up.  After the code is working, they should be removed, like this one.

Well except for cases where it's super performance critical I like to
retain these WARN_ON asserts (not BUG_ON). "Is the logic sufficient
locked down with WARN_ONs?" is actually one of the main review
criteria I have for i915 patches, especially on the modeset side.
They're a bit an annoyance for distro's since they result in a
constant (but ever shifting) stream of backtraces, but for me they
serve as an excellent early warning sign when our driver has yet again
lost its marbles (or at least some) way before something user-visibly
bad happens.

And for those screaming that these checks should be hidden behind a
config option and only enabled for validation: Nope, there's too many
combinations of display hardware out there and I simply need our
entire user base to serve as guinea pigs. There's really no other way
to validate this mess called drm/i915.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

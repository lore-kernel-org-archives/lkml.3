Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201Ab3ICRuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:50:03 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53123 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760168Ab3ICRuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:50:01 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1378229848-29113-1-git-send-email-kamal@canonical.com>
References: <1378229848-29113-1-git-send-email-kamal@canonical.com>
Date: Tue, 3 Sep 2013 19:50:00 +0200
Message-ID: <CAKMK7uHUr-qw491-kPjX=qHE+wtcYHC-bMyGehHDuF7w0Jkp7w@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: i915.disable_pch_pwm overrides PCH_PWM_ENABLE quirk
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Kamal Mostafa <kamal@canonical.com>
Cc: David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 7:37 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=47941
>
> Some BIOS configurations of Dell XPS13 are adversely affected by e85843b
> ("drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight") so provide a
> boot param to inhibit the quirk, or force it on.
>
> i915.disable_pch_pwm can be set to
>  -1: auto (default; allows the disabling of pch_pwm by dmi quirk table match)
>   0: inhibits the disabling of pch_pwm (overrides dmi quirk table match)
>   1: forces the disabling of pch_pwm
>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>

Nack. Piling quirk over quirk isn't the right approach and I think I
should just revert the pch_pwm enable quirk again.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

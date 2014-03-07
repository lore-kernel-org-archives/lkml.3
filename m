Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaCGIPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:15:05 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:37640 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaCGIPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:15:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140307084420.20eda4b9@pluto>
References: <1394131242-29567-1-git-send-email-dh.herrmann@gmail.com>
	<20140306225631.0eb29cf3@neptune.home>
	<CANq1E4QZXjfJp7gdDS_2stC0UrzMVvdTj_C05PUmML6cF4v22A@mail.gmail.com>
	<20140307084420.20eda4b9@pluto>
Date: Fri, 7 Mar 2014 09:15:00 +0100
Message-ID: <CANq1E4Qq4EoTm6vae37DBewBnTcnzQOSU2x8FJdPKwRGXsrLsA@mail.gmail.com>
Subject: Re: [RFC] drm: add kernel-log renderer
From: David Herrmann <dh.herrmann@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>> I don't think it makes sense to modify drm_log_ensure_size(). I mean,
>> the worst that can happen is that the *text*-backlog is twice as big
>> as required. But if you have a high-dpi display, you already require
>> like 10x as much space for each framebuffer than for the entire
>> log-buffer. The log-buffer requires 1 byte per *char*. The frambuffer
>> requires at least 8*16*4=512 bytes per char.
>
> That's fair, especially as drm_log_ensure_size() is grow-only.
>
>> Anyhow, integer-scaling should be fairly easy to get done.
>
> I thought providing the font to drm_log_draw() and express
> drm_log_ensure_size() in chars - or pass font to it as well - would be
> easier than scaling.

There are no real high-res fonts in ./lib/fonts/ so I don't think
that's an option. Besides, we don't want high-res fonts, we just want
bigger fonts so scaling seems fine.

Thanks
David

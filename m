Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab3CSR3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:29:43 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:53863 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214Ab3CSR3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:29:41 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1303191139080.15684-100000@netrider.rowland.org>
References: <CAP_ceTzvFkoqi3yC+qtvmW9XmdJ7Qv7Z5Jvf_n_gg0FVfChMeQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1303191139080.15684-100000@netrider.rowland.org>
Date: Tue, 19 Mar 2013 10:29:40 -0700
X-Google-Sender-Auth: 8wbvvB4kLOjmByEjOCgtfytNx7c
Message-ID: <CAODwPW8bAo-ixwmJjGPT94kDVSb+4qO264mOXyZ5RjmisTkYFQ@mail.gmail.com>
Subject: Re: [PATCH] usb: Make USB persist default configurable
From: Julius Werner <jwerner@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Vincent Palatin <vpalatin@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>, Sameer Nanda <snanda@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, okay, that's true.  If a new USB device is plugged in while the
> lid is shut, and then the lid is opened very briefly, it's possible
> that the system could suspend again before the new device's "persist"
> attribute is updated.  Does that case really matter?  The device isn't
> likely to be in use at that point.

It does matter if the device will be used after the next resume,
because that one would use the persist code. If there was a driver
problem it would fail, and if it was a USB stick that is swapped with
a different one of the same model, you could get file system
corruption.

I agree with you that buggy drivers should get fixed (and we are
trying to do that as well), but at the same time we want to be able to
have a system that can keep its policies at all times. We get a lot of
USB problems (especially around suspend/resume), and we don't want to
need to worry every time about which code path we hit and whether one
of those race conditions could have something to do with it. I'm
convinced that having this in the kernel is the cleanest solution for
us, and I just thought it might be useful to standardize a mechanism
for that (I don't really see the maintenance burden in that config
option either, as the persist mechanism itself does not look like it
was going to go away anytime soon).

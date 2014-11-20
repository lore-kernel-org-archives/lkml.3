Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbaKTSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:16:26 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:48880 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbaKTSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:16:25 -0500
MIME-Version: 1.0
In-Reply-To: <546DD783.2030902@collabora.co.uk>
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
 <1416238213-15263-3-git-send-email-javier.martinez@collabora.co.uk>
 <20141118142645.GD24004@x1> <546DD783.2030902@collabora.co.uk>
From: Bill Richardson <wfrichar@chromium.org>
Date: Thu, 20 Nov 2014 10:16:03 -0800
X-Google-Sender-Auth: uB1vrhszeBXEWPrjE_gV6Q9czq4
Message-ID: <CAEgFhe+DQrJ6HqGF1_OWZ77Qs-hZLNgX1bHpx5FOt-y-3xh8gA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mfd: cros_ec: Create sysfs attributes for the
 ChromeOS EC.
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 3:58 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
>
> I don't really know why there are two interfaces for this but I guess
> that different user-space utilities use one or another. Maybe the
> ChromiumOS folks can comment on this.

The /dev/cros_ec interface responds to ioctls and is the primary means
by which userspace applications talk to the EC (replacing three really
awkward bus-specific libraries). It emits a simplified version string
when read so that humans can tell if the EC is alive and speaking the
same protocol that the userspace app expects.

The /sys/class/chromeos/cros_ec/* tree was originally envisioned as a
way to provide additional human-readable interfaces to a subset of the
EC commands, but except for the lightbar it's not often used. The
version component here shows all the version-related info that the EC
can provide.

I apologize for the poor kernel conventions used here. In my
ignorance, I apparently chose the worst code possible to use as a
template, and then invented some new stupidness of my own.


Bill
-- 
Art for Art's Sake
Engineering for Money

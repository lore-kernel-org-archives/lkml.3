Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaJLJdC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 05:33:02 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46903 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaJLJc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 05:32:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAJjB1qKQ0ND2CeF=Npahn0r19WjdTwc7D3Th7PLnn0FJxHa_KQ@mail.gmail.com>
References: <1412885235-14026-1-git-send-email-octavian.purdila@intel.com>
	<1412885235-14026-4-git-send-email-octavian.purdila@intel.com>
	<CAJjB1qKQ0ND2CeF=Npahn0r19WjdTwc7D3Th7PLnn0FJxHa_KQ@mail.gmail.com>
Date: Sun, 12 Oct 2014 12:32:56 +0300
Message-ID: <CAE1zotL4Pb5etHzakCxeDLvZR112XGGaHomZ_dbh=AQVc0wvPg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] i2c: show and change bus frequency via sysfs
From: Octavian Purdila <octavian.purdila@intel.com>
To: Mark Roszko <mark.roszko@gmail.com>
Cc: linux-i2c <linux-i2c@vger.kernel.org>, linux-api@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Johan Hovold <johan@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 11:14 PM, Mark Roszko <mark.roszko@gmail.com> wrote:

> This seems limiting to arches with peripherals that can support a range of
> frequencies rather than fixed numbers.
> Also it creates some portability quirkiness between platforms when all the
> i2c bus drivers have different supported freq lists and you have to match
> exactly the right frequency. I.e. one guy does 60khz but another only has
> 80khz.

Sorry, I don't understand your points here. If this limitations exists
they are not introduced by this patch. This patch just exposes the
frequency so that it can be read or changed in userspace.

> Another issue is in systems where you have i2c devices on the same bus as
> the sysfs user space driver. User space could set a bus frequency that
> prevents operation with a system i2c device.

Changing the frequency is limited to root. Also, bus drivers do not
have to implement set_freq if it is thought not to be safe.

On a different not, I have noticed that a fixed set of frequencies
might not be the best API, since multiple drivers rather support a
rather large set of frequencies in a range. A better API might be to
expose a min-max range and let the bus driver adjust the requested
frequency. I will follow up with a second version that does that.

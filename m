Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaFKRJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:09:30 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:58736 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbaFKRJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:09:28 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1406111837030.21198@scotdoyle.com>
References: <1401800524-28934-1-git-send-email-mika.westerberg@linux.intel.com>
	<CANLzEksLB1=+TePxgPRBhsGKpC-4tWB8JOh-Ey80Hj43LkVn=g@mail.gmail.com>
	<20140604083726.GN1730@lahna.fi.intel.com>
	<CANLzEkuAxGrRHtb=vFAm9AGws7Qyg3A_oQpAGGFaYEqP2A2g8g@mail.gmail.com>
	<alpine.DEB.2.02.1406062259070.31301@scotdoyle.com>
	<alpine.DEB.2.02.1406062316230.32568@scotdoyle.com>
	<20140609124700.GJ1657@lahna.fi.intel.com>
	<alpine.DEB.2.02.1406092332410.8274@scotdoyle.com>
	<alpine.DEB.2.02.1406100610220.8274@scotdoyle.com>
	<20140611092309.GC1657@lahna.fi.intel.com>
	<alpine.DEB.2.02.1406111837030.21198@scotdoyle.com>
Date: Wed, 11 Jun 2014 10:09:26 -0700
X-Google-Sender-Auth: 1MZJZ8et-8trqEBUupP2Dt4Q1-M
Message-ID: <CANLzEkuGWd9s1Ka32BrgGxrCF+gGqVA4=uKuGJMerWaz6NDMpA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] platform/chrome: Probe multiple i2c adapters of
 the same name
From: Benson Leung <bleung@chromium.org>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:51 AM, Scot Doyle <lkml14@scotdoyle.com> wrote:
> The chromeos_laptop module probes the first i2c adapter with a specific name
> for expected hardware. However, the Acer C720 Chromebook has two i2c
> adapters with the same name. This patch probes each i2c adapter with a
> specific name until locating the expected hardware.
>
> Thanks to Mika Westerberg for formatting tips and identifying the need for
> unique bus addresses within each set of identically-named adapters.


Scot,

Is your intention with this patch to replace the one that Mika wrote
that specifically special cased the designware i2c busses? He already
solved this problem in this patch.
https://patchwork.kernel.org/patch/4288591/

I'm not sure about your approach here. It looks like if there's some
ambiguity in the names of the busses, you try to probe the device on
every bus with that name.

We know that bus 0 is going to have the touchpad, and we know that bus
1 is going to have the touchscreen and light sensor. I'd prefer not to
send extra probes for all of the combination of devices that don't
exist.

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org

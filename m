Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbaLPEkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 23:40:23 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:62927 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLPEkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 23:40:16 -0500
MIME-Version: 1.0
In-Reply-To: <1418597547-25086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1418597547-25086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 15 Dec 2014 22:40:15 -0600
X-Google-Sender-Auth: sNovCH20qplaxD1fk15N9nM3cdA
Message-ID: <CAEUsAPZ=8xN5a71-GpKXtcoOE8S_UCBuXxus3t1z3fGD39aCSA@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c: Fix
 for possible null pointer dereference
From: Chris Rorvick <chris@rorvick.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 4:52 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
>         units = 1;
...
>         /* Specified units override the multiplier */
>         if (units)

That doesn't make much sense.  The conditional logic will always be
executed.  Maybe this is what's intended?

        /* Specified units override the multiplier */
-       if (units)
+       if (units > 1)
                mult = mult < 0 ? -units : units;

Chris

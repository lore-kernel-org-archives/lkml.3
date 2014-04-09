Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719AbaDIN7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:59:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37325 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbaDIN7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:59:18 -0400
Date: Wed, 9 Apr 2014 14:58:48 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>, wim@iguana.be,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: intel-mid: add watchdog platform code for
 Merrifield
Message-ID: <20140409145848.4cabbb2f@alan.etchedpixels.co.uk>
In-Reply-To: <3412449.yg5NtfcPeg@ws-stein>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
	<1396990744-10695-3-git-send-email-david.a.cohen@linux.intel.com>
	<20140409134223.6444a598@alan.etchedpixels.co.uk>
	<3412449.yg5NtfcPeg@ws-stein>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm getting curious: How can I use device-tree on x86(_64)?
> Reading the dependencies from CONFIG_OF it can only be used on 32bit systems with some special hardware bases.
> So, how to use otherwise?

There isn't any fundamental thing tying device tree to a given
architecture or 32bitness, it's just that sane PC architectures use ACPI
to enumerate devices, and/or have a discoverable bus architecture.

Some of the phones don't so this now becoems a point of consideration. In
fact it's already also used on CE4100 (which is an embedded media SoC
found in some TV devices and set-top boxes) and on the OLPC (One laptop
per child). There is no intrinsic reason it couldn't be used in other x86
special cases.

If its PC shaped however it probably has ACPI and ACPI and DT are not a
1:1 mapping. ACPI has method invocations, and various firmware provided
interfaces such as the EC, Device tree is better at some other bits.

Converting the phones to embedded device tree rather than adding a
billion little platform files on the other hand seems to me like a
no-brainer.

Alan

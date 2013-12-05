Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab3LEM55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:57:57 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:44464 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab3LEM5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:57:55 -0500
Date: Thu, 5 Dec 2013 13:58:06 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Matt Sealey <neko@bakuhatsu.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, matt.fleming@intel.com,
        Grant Likely <grant.likely@linaro.org>,
        Roy Franz <roy.franz@linaro.org>, Mark Salter <msalter@redhat.com>,
        Patch Tracking <patches@linaro.org>, linaro-uefi@lists.linaro.org,
        Mark Rutland <mark.rutland@arm.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
Message-ID: <20131205125805.GX24997@rocoto.smurfnet.nu>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
 <1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
 <CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
 <20131202210719.GQ24997@rocoto.smurfnet.nu>
 <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 03:06:47PM -0600, Matt Sealey wrote:
> By the time we get half-way through arm/kernel/head.S the cache and
> MMU has been turned off and on and off again by the decompressor, and
> after a large amount of guesswork and arbitrary restriction-based
> implementation, there's no guarantee that the kernel hasn't been
> decompressed over some important UEFI feature or some memory hasn't
> been trashed. You can't make that guarantee because by entering the
> plain zImage, you forfeited that information. This is at worst case
> going to be lots of blank screens and blinking serial console prompts
> and little more than frustration..

So, Grant covered the reason _why_ we coexist with zImage, so I won't
go into that. I will however point out that we are explicitly using the
UEFI interfaces to allocate the regions the zImage will decompress into.
This isn't guesswork, and has in fact already turned up issues with a
couple of UEFI board ports that reserved memory near 0 (which were
indeed previously being silently overwritten by the kernel
decompression).

We _are_ planning to do more development for subsequent patches, making
more use of the UEFI memory map. And by subsequent, I mean hopefully in
time for 3.14. I sneekily included this in the version of uefi.txt sent
out for separate review early November:
http://permalink.gmane.org/gmane.linux.kernel.efi/2657, but not in
the one included with this patch set (since the code isn't there yet).
But we considered it more important to get the basic support ready
first.

At that point, you will see the stub reading the dram_base from the
UEFI memory map rather than DT, and memblock_init getting its input
from there too.

Regards,

Leif

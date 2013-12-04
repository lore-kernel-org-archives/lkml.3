Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3LDWpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 17:45:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57714 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3LDWpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 17:45:05 -0500
Date: Wed, 4 Dec 2013 22:44:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matt Sealey <neko@bakuhatsu.net>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, matt.fleming@intel.com,
        Grant Likely <grant.likely@linaro.org>,
        Roy Franz <roy.franz@linaro.org>, Mark Salter <msalter@redhat.com>,
        Patch Tracking <patches@linaro.org>, linaro-uefi@lists.linaro.org,
        Mark Rutland <mark.rutland@arm.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support
 documentation
Message-ID: <20131204224447.GA19265@srcf.ucam.org>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
 <1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
 <CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
 <20131202210719.GQ24997@rocoto.smurfnet.nu>
 <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 03:06:47PM -0600, Matt Sealey wrote:

> there's no guarantee that the kernel hasn't been decompressed over 
> some important UEFI feature or some memory hasn't been trashed. You 
> can't make that guarantee because by entering the plain zImage, you 
> forfeited that information.

The stub is responsible for ensuring that the compressed kernel is 
loaded at a suitable address. Take a look at efi_relocate_kernel().

> Most of the guessing is ideally not required to be a guess at all, the
> restrictions are purely to deal with the lack of trust for the
> bootloader environment. Why can't we trust UEFI? Or at least hold it
> to a higher standard. If someone ships a broken UEFI, they screw a
> feature or have a horrible bug and ship it, laud the fact Linux
> doesn't boot on it and the fact that it's their fault - over their
> head. It actually works these days, Linux actually has "market share,"
> companies really go out of their way to rescue their "image" and
> resolve the situation when someone blogs about a serious UEFI bug on
> their $1300 laptops, or even $300 tablets.

Yeah, that hasn't actually worked out too well for us.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

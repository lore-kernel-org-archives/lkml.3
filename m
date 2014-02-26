Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaBZWl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:41:56 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43380 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaBZWlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:41:55 -0500
Date: Wed, 26 Feb 2014 22:41:41 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, hpa@zytor.com, linux-efi@vger.kernel.org,
        jmorris@namei.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 12/12] Add option to automatically set trusted_kernel
 when in Secure Boot mode
Message-ID: <20140226224141.1741a746@alan.etchedpixels.co.uk>
In-Reply-To: <1393445473-15068-13-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<1393445473-15068-13-git-send-email-matthew.garrett@nebula.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 15:11:13 -0500
Matthew Garrett <matthew.garrett@nebula.com> wrote:

> UEFI Secure Boot provides a mechanism for ensuring that the firmware will
> only load signed bootloaders and kernels. Certain use cases may also
> require that the kernel prevent userspace from inserting untrusted kernel
> code at runtime. Add a configuration option that enforces this automatically
> when enabled.

I think you have a load more cases to attempt to paper over before you
even pretend to achieve that goal. Firewire for example. Also it only
remotely begins to work if you also force CAP_SYS_RAWIO off globally as
you need to force off things like raw command issuing to various
controllers (especially as some of that code is written on the basis that
'its RAWIO, screw making it secure and doing all the checks we could
bother with'.

RAWIO also disables things like CPU msr access - which is also quite
adequate for subverting a kernel.

Another issue that needs addressing is firmware. Quite a few of our
request_firmware cases load device firmware which is not signed into DMA
capable hardware. Probably also worth checking what the
architectural guarantees on bogus microcode updates is. Maybe we need
firmware signing for such cases to match the mod signing ?

I'm trying to think what else. Possibly disabling it on Pentium-M with
the rep movs erratum (Y19) as it's quite possible to set up suitable
adjacent page sets in user space via the graphics.

Alan

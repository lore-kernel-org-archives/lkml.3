Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3HMJNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:13:22 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56529 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab3HMJNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:13:21 -0400
MIME-Version: 1.0
In-Reply-To: <1376383051.2737.20@driftwood>
References: <20130812164548.GE23006@n2100.arm.linux.org.uk> <1376383051.2737.20@driftwood>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 13 Aug 2013 10:12:59 +0100
Message-ID: <CAFEAcA_KJwzefBH0St2vbGd9gaWsVL9jdrGRBJU9wx2-kuo1vA@mail.gmail.com>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
To: Rob Landley <rob@landley.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        qemu-devel@nongnu.org, Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 August 2013 09:37, Rob Landley <rob@landley.net> wrote:
> Peter says he knows somebody who knows somebody who dug some instance of
> this hardware out of some landfill or something.

No, I personally myself had the hardware. Really.

> Me, I want to get something that works on new qemu _and_ last year's
> qemu, and that's what I got.

Note that in general hoping that current mainline kernel will
always work with ancient QEMU is a losing proposition -- it is
always possible that a kernel improvement will trigger a latent
model bug in QEMU. (To pick a random example, some while ago fixes
to how the kernel dealt with BGR and RGB pixel formats on the
versatile board broke QEMU because we weren't modelling it right;
that was just a QEMU bug for which the fix is "get a newer QEMU".)

The back-compat in the PCI code is so that the older kernels (2.6.x)
will continue to work, which is not quite the same thing.

-- PMM

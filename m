Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3DZMeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:34:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57754 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3DZMeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:34:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Anup Patel <anup.patel@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>, patches@linaro.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
Date: Fri, 26 Apr 2013 14:33:59 +0200
Message-ID: <1577576.O1Cm2pf5KD@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CALrVBkuOmu4u9egdzzfn1tU9B-CFe3w85HZQ9s2gpKvYnaSqvA@mail.gmail.com>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org> <CAFEAcA_xmrHTvR7FxUr3PCKBJY-hZnkeBcqyHksTB4-hqOZS0w@mail.gmail.com> <CALrVBkuOmu4u9egdzzfn1tU9B-CFe3w85HZQ9s2gpKvYnaSqvA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8VHemkHvEwt+wMvhDSA8avb5ekgt6xn3ko/vw0q5NOT
 ndw2esJUOiRZmZWoNgConGarvatUDAzOF4pn4Ompyz6o8T4DYu
 BiBTbUktka/JlypLPE6fGzDbGhmcww4Qmt/iYMa+SrN8DOUtiu
 yHNQtUWR3zlnqeH3iD0ANs7yqzDfyUVjhjKtKgaC0nYwptTtl3
 x5MSZv7SZmL0OXSuqg9pdxXW7ANJYQ4xfF+s8V+D83qwKbpkYr
 JJQpytsH8sCymFOx9nZjpIBwmERQ4sjTU7DA0khWkRnOpcQ+mC
 Z2E5CaDTFBNkw+Nk9D/LFESW0zdJ0/wUX2c5I0iLXAQdsi1LzK
 9RskTj1iPaNp10UE1GUU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 April 2013 17:36:16 Anup Patel wrote:
> On 26 April 2013 17:03, Peter Maydell <peter.maydell@linaro.org> wrote:
> > On 26 April 2013 12:19, Alexander Graf <agraf@suse.de> wrote:
> >> MMIO registers are handled by a different layer than the virtio
> >> console itself. After the virtio refactoring in QEMU, they will
> >> be completely separate drivers.
> >
> > Good point -- we don't really want to be mixing up the
> > transport and the backend. You can see it in the kvmtool
> > patch, in fact -- it introduces an "if this is virtio-console"
> > special case into the mmio.c file which previously was
> > entirely backend agnostic.
> 
> Well, we can always have virtio device specific config registers
> handle by virtio device backends and generic virtio config register
> handled by transport.
> 
> kvmtool patch is hacky because it does not provide virtio device
> specific config read/write callbacks.

Couldn't kvmtool implement the interface used by smh_printch()
for early output instead?

Or if that's not a fitting inteface, maybe a psci call for writing
a character to the console?

	Arnd

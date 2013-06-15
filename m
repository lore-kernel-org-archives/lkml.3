Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3FOSkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 14:40:09 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46387 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3FOSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 14:40:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAN+qd7B+=wbxBKV=JrQa3WcCH16fKLJxnj4dywVyGdxE_L0fOA@mail.gmail.com>
References: <CAN+qd7B5YTFw2m5f7wJY1YxAvSQ3imU4nsV=B1JFUQCEWmfsww@mail.gmail.com>
	<CAN+qd7B+=wbxBKV=JrQa3WcCH16fKLJxnj4dywVyGdxE_L0fOA@mail.gmail.com>
Date: Sat, 15 Jun 2013 11:40:07 -0700
X-Google-Sender-Auth: o_LcywaFfVn2VkZM5mFnCe1W8Lg
Message-ID: <CAE9FiQViu-Y_uvbGL=00KH1_iv4oCvvY-id5Q52UiPjQhg0=Bw@mail.gmail.com>
Subject: Re: bug report about acpiphp
From: Yinghai Lu <yinghai@kernel.org>
To: diego fanesi <diego.fanesi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 8:34 AM, diego fanesi <diego.fanesi@gmail.com> wrote:
> I would like to report a bug about the module acpiphp. I don't know if
> this is the right place, if it isn't please tell me where I should
> write and I will do it.
>
> description: docking station hotplug working on 3.5.0 kernel but not
> in previous and next kernel releases
> hardware: sony vaio serie z SVZ1311C5E + Docking station VGP-PRZ20A
> distro: Ubuntu precise, kernels compiled from the source in kernel.org
>
> The problem is about connecting the docking station after the boot.
> with kernel 3.5.0:
> when I connect the docking station I can see the following log lines (dmesg):
> [ 2442.046921] acpiphp: Slot [1-1] registered
> [ 2442.046945] acpiphp: Slot [2] registered
> [ 2442.046968] acpiphp: Slot [3] registered
> [ 2442.047056] acpiphp: Slot [1-2] registered
> [ 2442.047066] acpiphp_glue: sibling found, but _SUN doesn't match!
> [ 2442.047169] acpiphp: Slot [1-3] registered
> [ 2442.047229] acpiphp: Slot [1-4] registered
> [ 2442.047300] acpiphp: Slot [1-5] registered
>
> after that all the devices are available in the system. I can use the
> external network, the bluray device, and the usb ports available in
> the docking station.
> if I unload the acpiphp module the hotplug doesn't work, meaning no
> log lines and devices not usable.
>
> with any other kernel (I tried also with 3.10rc5):
> when I connect the docking station I cannot see the log lines
> specified above, and the devices are not available. I tried with and
> without acpiphp loaded.
>
> I didn't tried with other 3.5 kernel versions. I tried with 3.7 and
> 3.8 and it is not working
>
> If I connect the docking station before the boot with a non 3.5.0
> kernel and I unplug it I can continue to see the devices available but
> of course not working.

please check v3.10-rc5 +
https://patchwork.kernel.org/patch/2723671/
https://patchwork.kernel.org/patch/2723721/
https://patchwork.kernel.org/patch/2723751/
https://patchwork.kernel.org/patch/2723791/

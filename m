Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3DZLeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:34:14 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61758 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab3DZLeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:34:13 -0400
MIME-Version: 1.0
In-Reply-To: <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org> <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 26 Apr 2013 12:33:50 +0100
Message-ID: <CAFEAcA_xmrHTvR7FxUr3PCKBJY-hZnkeBcqyHksTB4-hqOZS0w@mail.gmail.com>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
To: Alexander Graf <agraf@suse.de>
Cc: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 12:19, Alexander Graf <agraf@suse.de> wrote:
> MMIO registers are handled by a different layer than the virtio
> console itself. After the virtio refactoring in QEMU, they will
> be completely separate drivers.

Good point -- we don't really want to be mixing up the
transport and the backend. You can see it in the kvmtool
patch, in fact -- it introduces an "if this is virtio-console"
special case into the mmio.c file which previously was
entirely backend agnostic.

thanks
-- PMM

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaIWOQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:16:51 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:52736 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaIWOQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:16:49 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.109.222]
In-Reply-To: <54174082.4010008@ti.com>
References: <1404836521-59637-1-git-send-email-s-anna@ti.com>
 <1404836521-59637-3-git-send-email-s-anna@ti.com> <CAK=WgbY-WmcJdnLHDf1CSkJqNBUeUMPTLcEZyLGKnECbxH1OAQ@mail.gmail.com>
 <53D7F6F3.9020804@ti.com> <CAK=WgbZ+NhA5AAhURUOojwnCbi2wYkJ11i-C5e7-kpZL5vD_3g@mail.gmail.com>
 <54174082.4010008@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 23 Sep 2014 17:16:29 +0300
Message-ID: <CAK=WgbZanJYN7-vXW=wo0H40piauHGQHYPPppcCpc+6VapXmeg@mail.gmail.com>
Subject: Re: [PATCH 2/2] remoteproc: add support to handle internal memories
To: Suman Anna <s-anna@ti.com>
Cc: Dave Gerlach <d-gerlach@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Robert Tivy <rtivy@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Mon, Sep 15, 2014 at 10:39 PM, Suman Anna <s-anna@ti.com> wrote:
> These processors need to use their internal RAM for loading, which is
> not for generic usage by the kernel, so defining a CMA block for this
> memory doesn't make sense.

Ok - so just to make sure I understand, this is physical memory you
want to use, which belongs to the remote processor, and which isn't
mapped normally by the kernel?

> Will it suffice to replace the memcpy() with memcpy_toio()?

Yes, memcpy_toio should be fine (and then you don't need to cast the
cookie returned by ioremap).

Thanks,
Ohad.

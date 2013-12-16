Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3LPUi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:38:26 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58980 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3LPUiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:38:25 -0500
Message-ID: <1387226300.13062.161.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Tue, 17 Dec 2013 00:38:20 +0400
In-Reply-To: <201312161856.11384.arnd@arndb.de>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <201312150355.27755.arnd@arndb.de>
	 <1387198885.13062.154.camel@host5.omatika.ru>
	 <201312161856.11384.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 18:56 +0100, Arnd Bergmann wrote:
> Ok, I see. This sounds like some of the other platforms we have with
> external memory buses. If there is a chance that Linux ever has to
> program the per-CS settings into the bus controller, I would suggest
> to represent that as well as a separate node, like this

This is a platform-specific bus (PXA27x). Should it go into pxa27x.dtsi
rather than machine dts?

> In case there is a driver for the extbus node, I would not make it
> "simple-bus" but instead add a separate compatible string to match
> the driver, and let that driver call of_platform_populate
> to probe the children after the bus is set up.

There seems to be none at the moment. However, some machines need to
setup these partitions as a part of their initialization. So complete
migration to DT will require this driver.

In LP-8x4x case everything is setup by the bootloader. So "simple-bus"
works for me.



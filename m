Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3LRUur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:50:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61840 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3LRUup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:50:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Wed, 18 Dec 2013 21:50:38 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> <201312161856.11384.arnd@arndb.de> <1387226300.13062.161.camel@host5.omatika.ru>
In-Reply-To: <1387226300.13062.161.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312182150.39037.arnd@arndb.de>
X-Provags-ID: V02:K0:+tKEwrJm6Cr+BaUfDQYdL3BqkOnTwj77dgoj/xOPU0K
 11t9jDYQH7emhSdw5aiGJdrUKWq1GAUplbUqbJ/UdiKfbXK2tL
 mOmYNhBAu26yfDd83Fs5auQE+cCEICuWlBPeQR8aSD8NspW6sT
 kZCetp2QJm+toPF/VzlQjUoCNNp4SGKxWJtt9pTxNs6thTgSw2
 zWUQwzouYNv+0SESpYPryOBRtwES9ZlIKsBTzXBlkNXMYfgEdm
 g9nKyIRZVjgi3QkKD5GGB4BXwtXWWrQjfjhuJSlSU8Z61Zpt9h
 kjJOPID2iAj+C85pslcZ+h7A04TBvUvLe42UyASXfN34I/zVI2
 VLF4fMPT+EUsDQpp8mpU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 December 2013, Sergei Ianovich wrote:
> On Mon, 2013-12-16 at 18:56 +0100, Arnd Bergmann wrote:
> > Ok, I see. This sounds like some of the other platforms we have with
> > external memory buses. If there is a chance that Linux ever has to
> > program the per-CS settings into the bus controller, I would suggest
> > to represent that as well as a separate node, like this
> 
> This is a platform-specific bus (PXA27x). Should it go into pxa27x.dtsi
> rather than machine dts?

Yes, that was the idea.

> > In case there is a driver for the extbus node, I would not make it
> > "simple-bus" but instead add a separate compatible string to match
> > the driver, and let that driver call of_platform_populate
> > to probe the children after the bus is set up.
> 
> There seems to be none at the moment. However, some machines need to
> setup these partitions as a part of their initialization. So complete
> migration to DT will require this driver.
> 
> In LP-8x4x case everything is setup by the bootloader. So "simple-bus"
> works for me.

Hmm, this is a bit tricky then. I think it would be best to not
use "simple-bus" then, to allow migrating the other platforms later,
but that will be a little more work. Maybe you can register a trivial
driver in the platform code that only calls of_platform_populate on
the device for now?

	Arnd

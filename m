Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab3CSQso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:48:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab3CSQsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:48:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Date: Tue, 19 Mar 2013 16:48:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Fabio Porcedda <fabio.porcedda@gmail.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com> <CAHkwnC9fg7_uhLM2KD3vvj_oFx3EBoQfw8mCN=V9pyV5=k37aA@mail.gmail.com> <CAMuHMdVS56HRDSvr7XCpVEjEWnGti+V=J_m4qQzEid=23ON_fQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVS56HRDSvr7XCpVEjEWnGti+V=J_m4qQzEid=23ON_fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303191648.31527.arnd@arndb.de>
X-Provags-ID: V02:K0:4yuG0bkLjypCGhvOb8sJHv2G8/JHBU7680pzJHFvDfi
 MOnHH++QEQ2xmGW8qvmTh/42cQm3SWWPf/5QW5bzJ+T6tmvpCo
 e7GeSfO8PjsyDr1Umj3hZ3UazbO/83kJjj1oP5540INlW/CtAy
 9rU4/eLQnMGeUsP3eCFZbbLmPNFLbZd2k1CLU2hbuP+ZIzGs91
 onmJ1T7U02hAnQQJMsIR+qj4nuAwduHjN1gaFEYn0kEi3IvpBq
 sJ8i5CJy6iJeXc3NKOcpOEBve1ExAVmWdKVzdoF6Sx4RLuTAlV
 8RzcZp3gbBA0cqIYH83NkUk5DhVC+8sS1R8Wr1LXNYS8/Q/jHl
 EVCme5RrSEoaQP4XPLFU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 March 2013, Geert Uytterhoeven wrote:
> Hmm, so we may have drivers that (now) work perfectly fine with
> module_platform_driver_probe()/platform_driver_probe(), but will start
> failing suddenly in the future?

They will fail if someone changes the initialization order. That would
already break drivers before deferred probing support (and was the reason
we added feature in the first place), but now we can be much more liberal
with the order in which drivers are initialized, except when they are
using platform_driver_probe()

> I guess we need a big fat WARN_ON(-EPROBE_DEFER) in
> platform_driver_probe() to catch these?

Yes, very good idea.

	Arnd

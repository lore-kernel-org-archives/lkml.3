Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab3CSRLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:11:36 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:51977 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3CSRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:11:32 -0400
MIME-Version: 1.0
In-Reply-To: <201303191648.31527.arnd@arndb.de>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <CAHkwnC9fg7_uhLM2KD3vvj_oFx3EBoQfw8mCN=V9pyV5=k37aA@mail.gmail.com>
 <CAMuHMdVS56HRDSvr7XCpVEjEWnGti+V=J_m4qQzEid=23ON_fQ@mail.gmail.com> <201303191648.31527.arnd@arndb.de>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Tue, 19 Mar 2013 18:11:11 +0100
Message-ID: <CAHkwnC9FL9W07=n6bWvcwiE058zcBZwqUwtRB-VVNpU0gv0mNw@mail.gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 5:48 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 19 March 2013, Geert Uytterhoeven wrote:
>> Hmm, so we may have drivers that (now) work perfectly fine with
>> module_platform_driver_probe()/platform_driver_probe(), but will start
>> failing suddenly in the future?
>
> They will fail if someone changes the initialization order. That would
> already break drivers before deferred probing support (and was the reason
> we added feature in the first place), but now we can be much more liberal
> with the order in which drivers are initialized, except when they are
> using platform_driver_probe()
>
>> I guess we need a big fat WARN_ON(-EPROBE_DEFER) in
>> platform_driver_probe() to catch these?
>
> Yes, very good idea.
>
>         Arnd

If it's fine, I'll send a patch for that.

Regards
--
Fabio Porcedda

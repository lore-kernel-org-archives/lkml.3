Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaDWWvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:51:48 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:62477 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaDWWvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:51:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJFRapP6EA_T6fCK1po_4sf=34mpC13t9L0SCo1COB5gQ@mail.gmail.com>
References: <1396646870-29695-1-git-send-email-rabin@rab.in>
	<1396646870-29695-2-git-send-email-rabin@rab.in>
	<CAGXu5jJFRapP6EA_T6fCK1po_4sf=34mpC13t9L0SCo1COB5gQ@mail.gmail.com>
Date: Wed, 23 Apr 2014 15:51:45 -0700
Message-ID: <CAD=FV=U4WxMLyEAgGExc=Q7r9jy=AS3mtxSoi=M+Qgw_e=U-bg@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm: use fixmap for text patching when text is RO
From: Doug Anderson <dianders@google.com>
To: Kees Cook <keescook@chromium.org>
Cc: Rabin Vincent <rabin@rab.in>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>, Jon Medhurst <tixy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees,

On Wed, Apr 23, 2014 at 2:09 PM, Kees Cook <keescook@chromium.org> wrote:

> I think we can use this for the kgdb case too. Has anyone tried that
> yet? Perhaps implementing text_poke() in terms of patch_map/unmap
> calls would be best? Then the arm-specific kgdb hooks can use that,
> since it does the icache flushing separately.

Yes.  I just tried using these patches and it worked for me.  :)  I
didn't actually implement text_poke(), though.

Atop our 3.8 tree, in case anyone is curious

* https://chromium-review.googlesource.com/196670
* https://chromium-review.googlesource.com/196671
* https://chromium-review.googlesource.com/196672
* https://chromium-review.googlesource.com/196673
* https://chromium-review.googlesource.com/196674

Please include me on the CC list for spins of your patches...

-Doug

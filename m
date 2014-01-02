Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaABQMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 11:12:12 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:48171 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaABQMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 11:12:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131231193442.GA25208@core.coreip.homeip.net>
References: <20131231193442.GA25208@core.coreip.homeip.net>
Date: Thu, 2 Jan 2014 08:12:09 -0800
X-Google-Sender-Auth: FDCCexivc8tzBULUmuiWLBWxfYw
Message-ID: <CAD=FV=VjYtXA5XHiuz-bULpW_MCBWxw2eTvg+SQz9CrgsER4AA@mail.gmail.com>
Subject: Re: [PATCH] Input: cros_ec_keyb - switch from using uint8_t to u8
From: Doug Anderson <dianders@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Simon Glass <sjg@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

On Tue, Dec 31, 2013 at 11:34 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> u8 is proper in-kernel type for unsigned byte data.

I won't say that I keep up with all the latest trends here, but this
surprised me so I did some research.  My findings don't agree with
your statement.  Perhaps there are different standards that are used
for the input subsystem?

Specifically looking at
<https://www.kernel.org/doc/Documentation/CodingStyle>, I see:

     Therefore, the Linux-specific 'u8/u16/u32/u64' types and their
     signed equivalents which are identical to standard types are
     permitted -- although they are not mandatory in new code of your
     own.

     When editing existing code which already uses one or the other set
     of types, you should conform to the existing choices in that code.

That makes it sound like the author of that document would prefer
uint8_t but will accept u8.  It also seems like if code is consistent
about using a given type (as this code is) that it shouldn't be
changed.

I'm always happy to be enlightened, though!

-Doug

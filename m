Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab3FETEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:04:43 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54355 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab3FETEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:04:41 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface via sysfs
Date: Wed, 05 Jun 2013 12:04:37 -0700
Message-ID: <1717403.GgHsbyUkDZ@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.10.3 (Linux/3.9.4-200.fc18.x86_64; KDE/4.10.3; x86_64; ; )
In-Reply-To: <51AF8730.4010507@itdev.co.uk>
References: <1370453866-16534-1-git-send-email-nick.dyer@itdev.co.uk> <7380889.l4hHqCT0mm@dtor-d630.eng.vmware.com> <51AF8730.4010507@itdev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 05, 2013 07:45:04 PM Nick Dyer wrote:
> Dmitry Torokhov wrote:
> > On Wednesday, June 05, 2013 06:37:03 PM Nick Dyer wrote:
> >> Atmel maXTouch chips can be addressed via an "Object Based Protocol"
> >> which
> >> defines how i2c registers are mapped to different functions within the
> >> chips. This interface exposes the register map and allows user-space
> >> utilities to inspect and alter object configuration, and to view
> >> diagnostic
> >> data, while the device is running.
> > 
> > I think if the driver was to use regmap then this fucntionality will
> > already be there as regmap exports registers via debugfs.
> 
> Yes, this was suggested in the past and I spent some time looking into it.
> 
> We have made a deliberate choice to implement this via sysfs rather than
> debugfs since it needs to work on devices that don't have debugfs enabled.

Then they will have to enable it. Re-implementing something because
someone might not enable needed subsystem is not a good idea. Let's
say somebody disabled I2C - will you write your own implementation because
of that? Of course not, you just say that for given functionality it
is a prerequisite.

> 
> In addition, there are some quirks about the way in which we have to
> read/write registers which means regmap isn't a good fit.

Could you please elaborate more on this?

Thanks.

-- 
Dmitry

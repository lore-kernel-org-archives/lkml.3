Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab3HUWOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:14:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54200 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3HUWOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:14:03 -0400
MIME-Version: 1.0
In-Reply-To: <1376606573-15093-1-git-send-email-syin@broadcom.com>
References: <1376606573-15093-1-git-send-email-syin@broadcom.com>
Date: Thu, 22 Aug 2013 00:14:02 +0200
Message-ID: <CACRpkdaUacAbLd+i4Y=DXv=aSaUwBSz6-icPV9SVjxZkUjheww@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: Pass all configs to driver on pin_config_set()
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, matt.porter@linaro.org,
        Christian Daudt <csd@broadcom.com>, Markus Mayer <mmayer@broadcom.com>,
        James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sherman,

On Fri, Aug 16, 2013 at 12:42 AM, Sherman Yin <syin@broadcom.com> wrote:

> When setting pin configuration in the pinctrl framework, pin_config_set() or
> pin_config_group_set() is called in a loop to set one configuration at a time
> for the specified pin or group.
>
> This patch 1) removes the loop and 2) changes the API to pass the whole pin
> config array to the driver.  It is now up to the driver to loop through the
> configs.  This allows the driver to potentially combine configs and reduce the
> number of writes to pin config registers.
>
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Christian Daudt <csd@broadcom.com>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> Change-Id: I99cbfa2ae7b774456eb71edb276711b1ddcd42c8
> ---
> Please refer to the discussion with Linus W. "[PATCH] ARM: Adds pin config API
> to set all configs in one function" here:
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166567.html
>
> All c files changed have been build-tested to verify the change compiles and
> that the corresponding .o are successfully generated.

Good work! This is obviously the right thing to do and it's looking
very good.

Right now this does not apply to my "devel" branch, so I'd like you
to rebase on that right now. (This is what will go into v3.12).

This is also late in the development cycle so I believe this is going to
be v3.13 material unless there are more release candidates.

You can also hold on until after the v3.12 merge window and then
rebase it and we'll merge it as a first patch in the v3.13 development
cycle.

What do you say?

Yours,
Linus Walleij

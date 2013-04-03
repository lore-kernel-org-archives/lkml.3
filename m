Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774Ab3DCMhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:37:43 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:44622 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762512Ab3DCMhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <1364547807-22370-1-git-send-email-richard.genoud@gmail.com>
References: <1364547807-22370-1-git-send-email-richard.genoud@gmail.com>
Date: Wed, 3 Apr 2013 14:37:40 +0200
Message-ID: <CACRpkdZu_3BS0tKCYxWNOyZ0BYyH8m_sqTh9mHgnZW3qbU9BLw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: select_state: don't call pinctrl_free_setting
 on error
From: Linus Walleij <linus.walleij@linaro.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 10:03 AM, Richard Genoud
<richard.genoud@gmail.com> wrote:

> As Stephen Warren pointed out, pinctrl_free_setting() was called instead
> of pinmux_disable_setting() on error.
> In this error code, we want to call pinmux_disable_setting() where
> pinmux_enable_setting() was called.
> And when pinconf_apply_setting() was called, we can't do much to undo
> the pin muxing (the closest thing I can think about for "unmuxing" a pin
> is muxing it as GPIO input).
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
> This commit is on top of:
> [PATCH 3/3] pinctrl: pinctrl_select_state: set the old_state back on error

Patch applied with Stephen's Review tag.

Thanks,
Linus Walleij

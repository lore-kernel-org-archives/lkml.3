Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3C2QJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:09:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49585 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3C2QJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:09:19 -0400
Message-ID: <5155BCAC.5050504@wwwdotorg.org>
Date: Fri, 29 Mar 2013 10:09:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: select_state: don't call pinctrl_free_setting
 on error
References: <1364547807-22370-1-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1364547807-22370-1-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 03:03 AM, Richard Genoud wrote:
> As Stephen Warren pointed out, pinctrl_free_setting() was called instead
> of pinmux_disable_setting() on error.
> In this error code, we want to call pinmux_disable_setting() where
> pinmux_enable_setting() was called.

> And when pinconf_apply_setting() was called, we can't do much to undo
> the pin muxing (the closest thing I can think about for "unmuxing" a pin
> is muxing it as GPIO input).

That's likely typically what pinmux_disable_setting() does, or perhaps
it'll select a function for that pin/group that is guaranteed not to
conflict with any possible other mux configuration.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaFLB2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:28:54 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:41488 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFLB2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:28:53 -0400
MIME-Version: 1.0
In-Reply-To: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 11 Jun 2014 20:28:31 -0500
Message-ID: <CAL_JsqJmYH3_tSMtdwQd9QfeB39i5UOxBwBzyP=QjvzK1XSnmQ@mail.gmail.com>
Subject: Re: [RFC 0/5] of: Automatic console registration cleanups
To: Grant Likely <grant.likely@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 11:08 AM, Grant Likely <grant.likely@linaro.org> wrote:
> Hi all,
>
> This is a series that I've been playing with over the last few days to
> clean up the selection of default console devices when using the device
> tree. The device tree defines a way of specifying the console by using a
> "stdout-path" property in the /chosen node, but very few drivers
> actually attempt to use that data, and so for most platforms there needs
> to be a "console=" line in the command line if a serial port is intended
> to be used as the console.
>
> With this series, if there is a /chosen/stdout-path property, and if
> that property points to a serial port node, then when the serial driver
> registers the port, the core uart_add_one_port() function will notice
> and if no console= argument was provided then add it as a preferred
> console.
>
> I've not tested this very extensively yet, but I want to get some
> feedback before I go further.
>
> The one downside with this approach is that it doesn't do anything for
> early console setup. That still needs to be added on a per-driver basis,
> but at least it shouldn't conflict with this approach.

Hey, what happened with this series?

Rob

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaJ1Pd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:33:56 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:41121 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaJ1Pdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:33:54 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZbTXWP34nx8eeAd_BpPuwSspAUZbMv2WRCvaQURiHdfQ@mail.gmail.com>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
	<1413792260-4265-2-git-send-email-antoine.tenart@free-electrons.com>
	<CACRpkdZbTXWP34nx8eeAd_BpPuwSspAUZbMv2WRCvaQURiHdfQ@mail.gmail.com>
Date: Tue, 28 Oct 2014 16:33:53 +0100
Message-ID: <CACRpkda7g7mZoTmHUWoLFaNmMYDShceJ=Gch8UQJ8sTJ+57ydw@mail.gmail.com>
Subject: Re: [PATCH 1/4] Documentation: bindings: pinctrl: document the
 generic groups property
From: Linus Walleij <linus.walleij@linaro.org>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 4:29 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Oct 20, 2014 at 10:04 AM, Antoine Tenart
> <antoine.tenart@free-electrons.com> wrote:
>
>> Group-based drivers use a groups property to define on which groups a
>> mux function is applied to. Document it.
>>
>> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
>
> This is already documented but under another heading.
>
> This section was to be for pin config, we now have a separate
> section for pin muxing.

Bah rather, look in the upstream kernel:

== Generic pin multiplexing node content ==

pin multiplexing nodes:

function                - the mux function to select
groups                  - the list of groups to select with this function

Example:

state_0_node_a {
        function = "uart0";
        groups = "u0rxtx", "u0rtscts";
};
state_1_node_a {
        function = "spi0";
        groups = "spi0pins";
};

== Generic pin configuration node content ==

(...)

Supported generic properties are:

pins                    - the list of pins that properties in the node
                          apply to (either this or "group" has to be
                          specified)
group                   - the group to apply the properties to, if the driver
                          supports configuration of whole groups rather than
                          individual pins (either this or "pins" has to be
                          specified)


So now the first one is explicitly for mux and the latter on explicitly for
configs.

Maybe we have to have "pins" for the mux too, for drivers that do
per-pin function assignment, but it's clear that configs are per-pin
or per-group atleast, while muxing is done in nodes that contain
a "function" element.

Yours,
Linus Walleij

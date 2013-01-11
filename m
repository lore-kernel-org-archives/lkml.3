Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3AKSwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:52:22 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:58780 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab3AKSwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:52:20 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <cover.1357912706.git.nicolas.ferre@atmel.com>
References: <cover.1357912706.git.nicolas.ferre@atmel.com>
Date: Fri, 11 Jan 2013 10:52:19 -0800
Message-ID: <CAOesGMhhSkrvP7X=y8qmdMKKXZ694+1+ZXY3y6HK1E85qaN5sQ@mail.gmail.com>
Subject: Re: [PATCH 0/2 v2] at91/ssc: fixes on ASoC tree for 3.8
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: broonie@opensource.wolfsonmicro.com, voice.shen@atmel.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jan 11, 2013 at 6:08 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> This material was designed to enter Mark's fixes queue, but as discussed with
> Olof, we can imagine merging everything through arm-soc or split the series (of
> 2 patches) and let them progress upstream separated (option that I do not like
> even if I know that the consequences are not so dramatic).
> So please, Olof, if you feel confortable with this series, tell us what you
> prefer and we will make our best to make this material go forward...

You're setting yourself up for awkward merges. The driver change is
strongly dependent on the device tree change by failing probe unless
the device tree update is there, while before this patch, it still
worked.

If you instead use the dts update if it's there, you can merge the two
through independent paths, and later make it mandatory to use the
pinctrl specification. That way you avoid these complicated merge
scenarios where you have to send your platform code through a
subsystem tree instead.

But to be honest, I don't think this is a fix, it's a feature that you
just didn't include in time for the merge window. I don't really see
them as appropriate 3.8 material at this point.

So, nack on this series. Please make the driver change non-dependent
on the new dtsi contents, and merge that through the ASoC tree. Then
the dtsi update can go through arm-soc, and later on you can make it
mandatory.


-Olof

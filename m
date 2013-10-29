Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab3J2QXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:23:34 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:52761 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465Ab3J2QXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:23:32 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1381869563-16083-5-git-send-email-grant.likely@linaro.org>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
	<1381869563-16083-5-git-send-email-grant.likely@linaro.org>
Date: Tue, 29 Oct 2013 09:23:31 -0700
Message-ID: <CAOesGMj03kgJXttm80pHvPYeqg5hOaeOJAJ4DA8tf5LxqdArrQ@mail.gmail.com>
Subject: Re: [RFC 4/9] of/irq: Refactor interrupt-map parsing
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 15, 2013 at 1:39 PM, Grant Likely <grant.likely@linaro.org> wrote:
> All the users of of_irq_parse_raw pass in a raw interrupt specifier from
> the device tree and expect it to be returned (possibly modified) in an
> of_phandle_args structure. However, the primary function of
> of_irq_parse_raw() is to check for translations due to the presence of
> one or more interrupt-map properties. The actual placing of the data
> into an of_phandle_args structure is trivial. If it is refactored to
> accept an of_phandle_args structure directly, then it becomes possible
> to consume of_phandle_args from other sources. This is important for an
> upcoming patch that allows a device to be connected to more than one
> interrupt parent. It also simplifies the code a bit.
>
> The biggest complication with this patch is that the old version works
> on the interrupt specifiers in __be32 form, but the of_phandle_args
> structure is intended to carry it in the cpu-native version. A bit of
> churn was required to make this work. In the end it results in tighter
> code, so the churn is worth it.
>
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This patch stopped exynos/arndale from booting when it hit next (i.e.
last night). I bisected down to this commit.

It seems that the platform is getting stuck calibrating delay loop,
i.e. it is not getting interrupts. Let me know if you want me to
collect more data of some sort.


-Olof

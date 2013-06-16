Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3FPPHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 11:07:38 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:35736 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab3FPPHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 11:07:37 -0400
MIME-Version: 1.0
In-Reply-To: <9E3F9C2076C45D4783F09B90D5BE77CE16B4E6@BADWLRZ-SWMBX13.ads.mwn.de>
References: <9E3F9C2076C45D4783F09B90D5BE77CE16B4E6@BADWLRZ-SWMBX13.ads.mwn.de>
Date: Sun, 16 Jun 2013 23:07:36 +0800
Message-ID: <CACVXFVPrb-6WXadXyYE923+1_MA+y-9p1RRO=ufXXJCkEJu+OQ@mail.gmail.com>
Subject: Re: Questions about Runtime Power Management
From: Ming Lei <tom.leiming@gmail.com>
To: "Morales, Alejandra" <alejandra.morales@tum.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 12:28 AM, Morales, Alejandra
<alejandra.morales@tum.de> wrote:

> - Is runtime power management supported by net devices?

Currently, 'struct net_device' doesn't support runtime power management,
and I submitted one patch to add the support for solving accessing
suspended device by 'ethtool', but it was rejected.

              http://marc.info/?t=135054860600003&r=1&w=2

But the physical device of the net device can support runtime PM, for example,
some PCIe network devices support runtime PM on link change, and usbnet
devices support auto suspend.

Generally, the physical device is the parent of the net device, which is
a class device.

Thanks,
-- 
Ming Lei

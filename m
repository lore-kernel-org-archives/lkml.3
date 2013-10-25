Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3JYWPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:15:10 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51674 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab3JYWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:15:08 -0400
Date: Fri, 25 Oct 2013 15:15:05 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Philippe De Swert <philippe.deswert@jollamobile.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power:power_supply_syfs : Treat PROP_TYPE as a regular
 attribute first
Message-ID: <20131025221504.GA31842@teo>
References: <1376521798-16985-1-git-send-email-philippe.deswert@jollamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1376521798-16985-1-git-send-email-philippe.deswert@jollamobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 02:09:58AM +0300, Philippe De Swert wrote:
> These days we often have USB powered devices. This means that often the
> type is variable. Common examples are smartphones which can be charged
> through a normal USB port on a PC/laptop, a dedicated charger, etc...
> Often those chips also have support for other charger types like a
> mains/DC charger. This means that often there are several psy structures
> in the driver and makes it impossible to stick to just one type.

I would guess that a lot of userland code assumes that the type is fixed.
We can't break this assumption. Plus I don't think we really need the
changing types.

> Userspace sometimes needs to behave differently based on the type of charger
> connected to such devices.

A system with several charger should either:

1. Register all of them (mains, usb, etc.) as a separate power supply
device, and then use PROP_ONLINE to specify whether something is connected
to the port or not.

2. Register only the charger type that is currently connected to the
system.

This is how we've been doing things from the very start.

Thanks,

Anton

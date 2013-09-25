Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3IYEh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 00:37:56 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:47887 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3IYEhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 00:37:55 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CAL85gmAi9qZWdeHt5JWeEW-OuNKdxqt-0fPDeCugnpun_6BDKA@mail.gmail.com>
References: <CAL85gmAi9qZWdeHt5JWeEW-OuNKdxqt-0fPDeCugnpun_6BDKA@mail.gmail.com>
Date: Tue, 24 Sep 2013 21:37:54 -0700
Message-ID: <CAOesGMj9qUKw9hTSmoV76bvbKHbapxyUss4JfrD0pg9=oPpLdg@mail.gmail.com>
Subject: Re: General placement of platform drivers and header files
From: Olof Johansson <olof@lixom.net>
To: Feng Kan <fkan@apm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 24, 2013 at 8:33 PM, Feng Kan <fkan@apm.com> wrote:
> Hi all:
>
> I have some drivers like Queue Manager and co-processor driver that
> are used by other
> drivers like Ethernet. Would it be appropriate to locate these drivers
> under one folder under
> drivers/misc/arch_name/xxx.

drivers/misc is almost always the wrong answer to where to add a driver.

It would help to also know how the devices interact to answer the
question of best location. Are the drivers for the coprocessor and for
the queue manager mostly a pass-through for some operations (and some
shared allocation of resources), i.e. more of a library, or is it a
full-fledged driver that will service interrupts, etc?

> My other question is on common header files (belonging to Queue
> Manager) but is sourced
> by Ethernet, where should those reside. Should they go under
> linux/include/misc/arch_name
> or directly sourced using the ../../../misc/arch_name/headerfile method.

This depends somewhat on where the driver ends up, but somewhere under
include/linux is likely the right place for the in-kernel interface
header files.


-Olof

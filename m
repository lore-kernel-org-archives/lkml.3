Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbaIKUnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:43:02 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44349 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbaIKUnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:43:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
Date: Thu, 11 Sep 2014 13:42:59 -0700
X-Google-Sender-Auth: RbYPJYYOIM53E9aiZuWF-iW3oFc
Message-ID: <CA+55aFx_Kgb6FcOoyQOb=7ud9VL4T3g2EoeOhuPAHUPa-+eG+A@mail.gmail.com>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Dirk Gouders <dirk@gouders.net>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 12:26 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> This is amd two node systems. amd_bus.c tell us bus [00, 7f] is from
> first socket, but _OSC says only [0,7] is from first socket.

That might also explain why Dirk doesn't see it on his other machine.
The other machine doesn't have a buggy ACPI table bus limit.

So yeah, trusting actual hw more than the _OSC entry sounds like the
fix. I don't understand why hardware designers seem to think that ACPI
is a good model, when it would have been so much better to just
introduce hardware standards instead.

Oh well. I guess that boat sailed long long ago.

             Linus

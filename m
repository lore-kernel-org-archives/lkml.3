Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab3DASxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:53:01 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58622 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034Ab3DASxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:53:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQU+LdKtDSQ7J-Hx=JoC=-K8AyPhyOPHTR+54rLwN=DjrA@mail.gmail.com>
References: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
 <1364444885-19751-3-git-send-email-yinghai@kernel.org> <CAErSpo7+V8vU8x2=MfZw3V7XsXKzs6qrvv8G=MqrEdUKcyvoTw@mail.gmail.com>
 <CAE9FiQUWL1+EUf2HZ3CXR87vuUCEE5BCLE18ZP2oE6Eo+_Ueiw@mail.gmail.com>
 <CAErSpo6GTArwivZ=UJox_Laww3zE0rccYt2W4tiwAkSGdT6YYg@mail.gmail.com> <CAE9FiQU+LdKtDSQ7J-Hx=JoC=-K8AyPhyOPHTR+54rLwN=DjrA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 1 Apr 2013 12:52:39 -0600
Message-ID: <CAErSpo7mdJ0f_F67D5-bEpU2JD4cduA1Mt8q8JJU7-54eYFNZQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] eisa, PCI: init eisa early before pnp step in
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Whitehead <mwhitehe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 12:25 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Apr 1, 2013 at 11:15 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> >> Is this a regression?  This must have worked at one time, but it seems
>> >> like we've had pnpacpi_init/isapnp_init/pnpbios_init before PCI
>> >> drivers for quite a while.
>> >
>> > Yes.
>>
>> Do you know when the regression occurred?  If you do, I'll add that
>> info to the "stable" tag.
>
> No, I don't.
>
> Looking at the current code, it should be quite before kernel was using git.
> as first drivers/Makefile in git already has pnp before eisa.
>
> Do we need to dig before 2.6.12 and 2.4?

No, I don't think we need to worry about fixing kernels that old.

But I do wonder whether we fully understand the cause.  I know EISA is
old and obsolete, but it's a little hard to believe that it's been
broken since 2.6.12 and nobody noticed.

Bjorn

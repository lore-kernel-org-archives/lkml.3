Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaAOJBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:01:51 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34750 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaAOJBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:01:50 -0500
MIME-Version: 1.0
In-Reply-To: <20140115084605.GF29177@redhat.com>
References: <1389774152-1526-1-git-send-email-mst@redhat.com>
	<CAMuHMdV=qzDApabSiQj9up_RUW=PoVJA8oWaiWY7d2iQ22AfeQ@mail.gmail.com>
	<20140115084605.GF29177@redhat.com>
Date: Wed, 15 Jan 2014 10:01:49 +0100
X-Google-Sender-Auth: IR_T7BMTOBSGv1yXhDcRFVR_7io
Message-ID: <CAMuHMdW4io2BcPvR-VwLMrCNReTEcUeNgO1ievVw+Eg=UdyeuA@mail.gmail.com>
Subject: Re: [PATCH stable-only] virtio-net: fix build on m68k and sparc64
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 9:46 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Wed, Jan 15, 2014 at 09:36:13AM +0100, Geert Uytterhoeven wrote:
>> On Wed, Jan 15, 2014 at 9:26 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> > As a result of backporting a bugfix, virtio_net started passing void *
>> > to page_address, assuming that it will get silently converted to struct
>> > page *. But this does not happen on architectures where page_address is
>> > a macro, the result is build failure as the macro tries to dereference
>> > void*.
>> >
>> > Fix by reordering code slightly, so we always pass
>> > struct page * to page_address.
>>
>> Thanks for the clue! I was just investigating a similar failure in -next.
>>
>> Gr{oetje,eeting}s,
>>
>>                         Geert
>
> You don't mean linux-next? And not in virtio-net? I don't see page_address
> being used on void * anywhere there.

http://kisskb.ellerman.id.au/kisskb/buildresult/10469287/

I'm making {,set}page_address() static inline to fix this.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaHGO5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:57:34 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:60699 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbaHGO5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:57:32 -0400
MIME-Version: 1.0
In-Reply-To: <5750080.46d2jsPKXX@sifl>
References: <CAMuHMdV4VpaH1nHYO5hr66Xib5o_Pib863JzGRtg2kYcjMp2TQ@mail.gmail.com>
	<5750080.46d2jsPKXX@sifl>
Date: Thu, 7 Aug 2014 16:57:30 +0200
X-Google-Sender-Auth: d9mtOS2bJ4etUkBD6xSfLjlO1ns
Message-ID: <CAMuHMdWyMjUW+FB5FtkoqF7pFsm3C6+VsTK7KE6q7XRFRRMOvw@mail.gmail.com>
Subject: Re: sel_netif_init: 'err' is used uninitialized (was: Re: selinux:
 reduce the number of calls to synchronize_net() when flushing caches)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-security-module@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Thu, Aug 7, 2014 at 4:26 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Thursday, August 07, 2014 12:31:15 PM Geert Uytterhoeven wrote:
>>
>> security/selinux/netif.c: In function ‘sel_netif_init’:
>> /scratch/geert/linux/linux-m68k/security/selinux/netif.c:285: warning:
>> ‘err’ is used uninitialized in this function
>>
>> Should it just return 0, like before?
>> Or should it return the return value of register_netdevice_notifier()
>> instead, which also returns an error code? Or is that failure non-critical?
>
> Hi,
>
> I posted a fix for this two days ago to the SELinux list (see below).  As soon
> as -rc1 is released and linux-next is back in business I'll be pushing the
> patch to the SELinux #next branch.
>
>  * http://marc.info/?l=selinux&m=140727033030054&w=2

Thanks, I had a quick look for it, but couldn't find it.
It's always a good idea to CC lkml for such issues in mainline.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

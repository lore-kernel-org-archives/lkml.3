Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab3EEAmD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 20:42:03 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:37851 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3EEAmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 20:42:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130505003028.GA24796@enc.com.au>
References: <CA+55aFxVDub+aXyOrojz_yRCHHG50MnviOjP_-uRxKLuQRYXUw@mail.gmail.com>
	<1366976933-5514-1-git-send-email-jslaby@suse.cz>
	<CA+55aFxwCY3uagCUf1th6sr5+HGO0Mba-dhS-OtsnJ6o41JANw@mail.gmail.com>
	<20130505003028.GA24796@enc.com.au>
Date: Sat, 4 May 2013 17:42:00 -0700
X-Google-Sender-Auth: VDCBfQYA88mT4RdIIQg9pzTnhZ4
Message-ID: <CA+55aFyWLtCGsXdur-Yz2Ep+aYji3e91goDP-HZS756dc-R7hQ@mail.gmail.com>
Subject: Re: [PATCH v2] TTY: fix atime/mtime regression
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Craig Small <csmall@enc.com.au>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 4, 2013 at 5:30 PM, Craig Small <csmall@enc.com.au> wrote:
>
> I saw someone wants the 10 second resolution, can I get it confirmed
> that the kernel will only be updating at minute intervals (so the .1
> second stuff is completely useless) or 10 second (so the .1 second
> stuff is just confusing for most of us).

Yeah, it's roughly 10s right now (it's actually 8 seconds, because the
power-of-two rounding is cheaper, whatever), and I think that's where
it will remain. It seems sufficient for people to know if somebody is
"active right now", while being seldom enough that you can't actually
get any useful information (ie you can get the "hey, somebody *just*
pressed a key by continually stat'ing the file, and get the timing of
that one key to almost arbitrary precision, but you won't know the
timing of any other keys for another eight seconds, so there's data
there but no useful *information*).

                Linus

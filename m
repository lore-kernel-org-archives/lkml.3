Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbaCUPlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:41:36 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58589 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaCUPld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:41:33 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <532C51F3.8030205@hurleysoftware.com>
References: <532B3691.1070602@hurleysoftware.com> <CAKgNAkisMs4A15B7ts+bAkUY5bcoTTGdE81ur10K3hZoFLxbxw@mail.gmail.com>
 <532C20B7.2070806@hurleysoftware.com> <532C3B6F.2000300@gmail.com>
 <532C46BD.1000208@hurleysoftware.com> <CAKgNAkhg4-QLwQaVxve6KXR=yy0XQik_4+iz5XytE1d_6NjQaw@mail.gmail.com>
 <532C51F3.8030205@hurleysoftware.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 21 Mar 2014 16:41:11 +0100
Message-ID: <CAKgNAkhRu7yZSn+uB1eTcL0gPGPcGsd5Z36pXgfdKOLBcdOoBw@mail.gmail.com>
Subject: Re: man termios
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Ivan <athlon_@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Peter, do you agree that Linux appears to differ from POSIX here? (Not
>> sure if you tried my test program to verify...)
>
>
> I did run the test program to validate that it's observed behavior is that
> implemented by Linux, with which I'm very familiar.
> I don't have a test setup for other *nixes.
>
> I would be interested to know the results of
>
>   ./noncanonical 0 5 3 0
>   hello

Solaris 10:
read() completes when 5 bytes received.
OpenBSD 5.4
read() completes when 5 bytes received.

> and
>
>   ./noncanonical 0 5 3 2
>    hel

Solaris
read blocks()
OpenBSD
read blocks


Plus my test case where Linux differs:

./noncanonical 100 5 3 0

Linux: read() returns after 3 bytes input

Solaris: read() returns only after 5 bytes input
OpenBSD: read() returns only after 5 bytes input


> on other platforms.
>
> With respect to POSIX compliance, it's hard to say. I'm not sure the
> spec contemplates the degenerate case where max bytes < MIN. And

Well, given the way the other implementations behave, I think it does
contemplate it, because it carefull avoids talking about the number of
bytes requested by read() in that case.

> specifically
> with regard to terminal i/o behavior, POSIX is essentially ex post facto,
> and is really documenting existing behavior.
>
> Other than the degenerate case of max bytes < MIN, is there any other
> variation between Solaris and Linux in non-canonical mode?

The only one I've seen is the one I noted. I haven't tested too
exhaustively though.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

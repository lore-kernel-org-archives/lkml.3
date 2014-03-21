Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbaCUODq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:03:46 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38898 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760353AbaCUODo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:03:44 -0400
Message-ID: <532C46BD.1000208@hurleysoftware.com>
Date: Fri, 21 Mar 2014 10:03:41 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Ivan <athlon_@mail.ru>
Subject: Re: man termios
References: <532B3691.1070602@hurleysoftware.com> <CAKgNAkisMs4A15B7ts+bAkUY5bcoTTGdE81ur10K3hZoFLxbxw@mail.gmail.com> <532C20B7.2070806@hurleysoftware.com> <532C3B6F.2000300@gmail.com>
In-Reply-To: <532C3B6F.2000300@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 09:15 AM, Michael Kerrisk (man-pages) wrote:
> On 03/21/2014 12:21 PM, Peter Hurley wrote:
>> On 03/21/2014 06:45 AM, Michael Kerrisk (man-pages) wrote:

>>>> Finally, if the 'count' parameter is less than MIN, read() may return before
>>>> MIN bytes have been received, if 'count' bytes have been received.
>>>
>>> Yes. But it's not clear to me here: do you mean that something in the
>>> man page (or in TLPI) needs fixing?
>>
>> Well, what I mean here is that read() may also _not_ return until MIN bytes have
>> been received, even if 'count' bytes have been received.
>
> Ahh -- I see what you mean. And, it looks like there is a point here where Linux
> differs from POSIX and (at least) Solaris. See the current man-page text below,
> in particular the MIN>0, TIME>0 case. I've also attached a simple test program
> that I used, below.
>
>         In noncanonical mode input is available immediately (without  the
>         user  having  to  type a line-delimiter character), no input pro‐
>         cessing is performed, and line editing is disabled.  The settings
>         of  MIN (c_cc[VMIN]) and TIME (c_cc[VTIME]) determine the circum‐
>         stances in which a read(2) completes;  there  are  four  distinct
>         cases:
>
>         MIN == 0; TIME == 0:
>                If  data  is  available, read(2) returns immediately, with
>                the lesser of the number of bytes available, or the number
>                of  bytes  requested.   If  no  data is available, read(2)
>                returns 0.
>
>         MIN > 0; TIME == 0:
>                read(2) blocks until MIN bytes are available, and  returns
>                up to the number of bytes requested.
>
>         MIN == 0; TIME > 0:
>                TIME  specifies  the limit for a timer in tenths of a sec‐
>                ond.   The  timer  is  started  when  read(2)  is  called.
>                read(2)  returns  either when at least one byte of data is
>                available, or  when  the  timer  expires.   If  the  timer
>                expires  without  any  input  becoming  available, read(2)
>                returns 0.  If data is already available at  the  time  of
>                the call to read() the call behaves as though the data was
>                received immediately after the call.
>
>         MIN > 0; TIME > 0:
>                TIME specifies the limit for a timer in tenths of  a  sec‐
>                ond.  Once an initial byte of input becomes available, the
>                timer is restarted after each further  byte  is  received.
>                read(2)  returns  when  any of the following conditions is
>                met:
>
>                *  MIN bytes have been received.
>
>                *  The interbyte timer expires.
>
>                *  The number of  bytes  requested  by  read(2)  has  been
>                   received.   (POSIX  does  not  specify this termination
>                   condition, and on  some  other  implementations  read()
>                   does not return in this case.)
>
>                Because  the  timer is started only after the initial byte
>                becomes available, at least one byte  will  be  read.   If
>                data  is  already  available  at  the  time of the call to
>                read() the call behaves as though the  data  was  received
>                immediately after the call.
>
>         POSIX does not specify whether the setting of the O_NONBLOCK file
>         status flag takes precedence over the MIN and TIME settings.   If
>         O_NONBLOCK is set, a read() in noncanonical mode may return imme‐
>         diately, regardless of the setting of MIN or TIME.   Furthermore,
>         if  no  data is available, POSIX permits a read() in noncanonical
>         mode to return either 0, or -1 with errno set to EAGAIN.

All looks good.

Thanks again,
Peter Hurley


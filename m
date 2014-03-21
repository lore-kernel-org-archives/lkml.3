Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbaCUQLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:11:19 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53506 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751594AbaCUQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:11:16 -0400
Message-ID: <532C64A1.6090807@hurleysoftware.com>
Date: Fri, 21 Mar 2014 12:11:13 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: linux kernel <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Ivan <athlon_@mail.ru>
Subject: Re: man termios
References: <532B3691.1070602@hurleysoftware.com> <CAKgNAkisMs4A15B7ts+bAkUY5bcoTTGdE81ur10K3hZoFLxbxw@mail.gmail.com> <532C20B7.2070806@hurleysoftware.com> <532C3B6F.2000300@gmail.com> <532C46BD.1000208@hurleysoftware.com> <CAKgNAkhg4-QLwQaVxve6KXR=yy0XQik_4+iz5XytE1d_6NjQaw@mail.gmail.com> <532C51F3.8030205@hurleysoftware.com> <CAKgNAkhRu7yZSn+uB1eTcL0gPGPcGsd5Z36pXgfdKOLBcdOoBw@mail.gmail.com>
In-Reply-To: <CAKgNAkhRu7yZSn+uB1eTcL0gPGPcGsd5Z36pXgfdKOLBcdOoBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 11:41 AM, Michael Kerrisk (man-pages) wrote:
>>> Peter, do you agree that Linux appears to differ from POSIX here? (Not
>>> sure if you tried my test program to verify...)
>>
>>
>> I did run the test program to validate that it's observed behavior is that
>> implemented by Linux, with which I'm very familiar.
>> I don't have a test setup for other *nixes.
>>
>> I would be interested to know the results of
>>
>>    ./noncanonical 0 5 3 0
>>    hello
>
> Solaris 10:
> read() completes when 5 bytes received.
> OpenBSD 5.4
> read() completes when 5 bytes received.

Ok, Linux does the same.

>> and
>>
>>    ./noncanonical 0 5 3 2
>>     hel
>
> Solaris
> read blocks()
> OpenBSD
> read blocks

If you type fast, Linux will complete this read() with 3 bytes.

> Plus my test case where Linux differs:
>
> ./noncanonical 100 5 3 0
>
> Linux: read() returns after 3 bytes input
>
> Solaris: read() returns only after 5 bytes input
> OpenBSD: read() returns only after 5 bytes input

Ok, thanks for testing.

>> on other platforms.
>>
>> With respect to POSIX compliance, it's hard to say. I'm not sure the
>> spec contemplates the degenerate case where max bytes < MIN. And
>
> Well, given the way the other implementations behave, I think it does
> contemplate it, because it carefull avoids talking about the number of
> bytes requested by read() in that case.

I agree that's certainly a valid interpretation.
I'll go back and see if this is a regression but I doubt it.

>> specifically
>> with regard to terminal i/o behavior, POSIX is essentially ex post facto,
>> and is really documenting existing behavior.
>>
>> Other than the degenerate case of max bytes < MIN, is there any other
>> variation between Solaris and Linux in non-canonical mode?
>
> The only one I've seen is the one I noted. I haven't tested too
> exhaustively though.

Thanks again. Please feel free to direct mail my way if you find other
variation.

Regards,
Peter Hurley


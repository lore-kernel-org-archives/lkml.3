Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbbACOpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 09:45:38 -0500
Received: from mail-ie0-f193.google.com ([209.85.223.193]:51806 "EHLO
	mail-ie0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbbACOpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 09:45:36 -0500
MIME-Version: 1.0
X-Originating-IP: [85.24.246.111]
In-Reply-To: <CA+icZUUJfemKC85=p7Huyw7xwfUdXBhePseJCnUKLx9edgpT4w@mail.gmail.com>
References: <1420127170-28421-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CACna6rznUcqGTK0t1k=kjn0NVLycq865780ozyB+VYu78d_BSg@mail.gmail.com>
	<CACna6rxbGRdw7XSYvHAJGxJvMVwjVbAL4ynBM3m9rNggh7gCVQ@mail.gmail.com>
	<CA+icZUWOXMEyobZkudW9BEfkaWFTXQL9XF26g7oJMCzt=4==6g@mail.gmail.com>
	<CAKXHbyO70WdWekSYCY9spMbX2+_kdKTp3JoreDKpCdUBzFwYqw@mail.gmail.com>
	<CACna6rxTYUWvxvu0rFydWxkjbYdHfhV=o+9A+ViCpbV-LFx7fw@mail.gmail.com>
	<CAKXHbyMqTk=k7eieBNtAD+n6+4w3weL82twHBo-o8ebm_3+wvg@mail.gmail.com>
	<CA+icZUUJfemKC85=p7Huyw7xwfUdXBhePseJCnUKLx9edgpT4w@mail.gmail.com>
Date: Sat, 3 Jan 2015 15:45:33 +0100
Message-ID: <CAKXHbyPm+2gy3E_FAVY82ggvJhWe-E_xtrhgeAPxUyRS-FutaA@mail.gmail.com>
Subject: Re: [PATCH] net: wireless: b43legacy: radio.c: Remove unused function
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-03 14:19 GMT+01:00 Sedat Dilek <sedat.dilek@gmail.com>:
>
> On Sat, Jan 3, 2015 at 1:28 PM, Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se> wrote:
> > 2015-01-02 22:34 GMT+01:00 Rafał Miłecki <zajec5@gmail.com>:
> >>
> >> On 2 January 2015 at 18:46, Rickard Strandqvist
> >> <rickard_strandqvist@spectrumdigital.se> wrote:
> >> > 2015-01-02 13:14 GMT+01:00 Sedat Dilek <sedat.dilek@gmail.com>:
> >> >>
> >> >> On Fri, Jan 2, 2015 at 1:06 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
> >> >> > On 2 January 2015 at 13:05, Rafał Miłecki <zajec5@gmail.com> wrote:
> >> >> >> On 1 January 2015 at 16:46, Rickard Strandqvist
> >> >> >> <rickard_strandqvist@spectrumdigital.se> wrote:
> >> >> >>> Remove the function b43legacy_radio_set_tx_iq() that is not used
> >> >> >>> anywhere.
> >> >> >>>
> >> >> >>> This was partially found by using a static code analysis program
> >> >> >>> called cppcheck.
> >> >> >>
> >> >> >> It seems to be for A-PHY based hardware (with 0x2060 radio id) which
> >> >> >> is not handled by b43legacy. Should be safe to drop this code (we
> >> >> >> won't likely need it).
> >> >> >>
> >> >> >> Ack
> >> >> >
> >> >> > For future, we prefix patches with just a driver name. So this could
> >> >> > be simply called
> >> >> > b43legacy: radio.c: Remove unused function
> >> >> >
> >> >>
> >> >> Alternatively...
> >> >>
> >> >> "b43legacy: Remove unused function in radio.c"
> >> >>
> >> >> BTW, as Arnd Bergmann pointed out [1] how did you test with cppcheck
> >> >> to get such stuff?
> >> >>
> >> >> - Sedat -
> >> >>
> >> >> [1] https://lkml.org/lkml/2015/1/2/51
> >> >
> >> >
> >> >
> >> > Hi Rafal and Sedat
> >> >
> >> > Rafal do you mean I should remove the entire b43legacy part?
> >>
> >> 1) I gave you Ack for the changes
> >> 2) You could drop "net: wireless: " or better use something Sedat proposed
> >>
> >> --
> >> Rafał
> >
> >
> >
> > Hi
> >
> > Nice, yes I miss the Ack :)
> >
> > I just got one more complaining about my subject-line in "net: wireless: "
> > I use some sed call for this, so it's easy to fix. I will now remove that
> > part hereinafter.
> > I check in Documentation/ but did not find any clear info for this.
> >
>
> The easiest way to make (sub)maintainers happy is to check the git-log...
>
> $ git log --oneline /path/to/file
>
> ...and look how other contributors labeled their patches.
>
> [1] is the 1st address to look at on how to submit patches to Linux-kernel.
> To promote the good work of Greg, see [2,3] for a video and tutorial
> on that topic, too.
>
> - Sedat -
>
> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/SubmittingPatches
> [2] https://www.youtube.com/watch?v=XXix80GCvpo
> [3] https://github.com/gregkh/kernel-tutorial



Hi Sedat

Thanks for the tip :)

To bad with the audio in the video thow. Have read SubmittingPatches before.


But I have now added a line in my script that does a:

git log -10 --oneline

So I can at least see the other subjekt lines, and make adjustments if
necessary.



Kind regards
Rickard Strandqvist

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3GASOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:14:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33611 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3GASON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:14:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130701144219.2ce56054.mchehab@redhat.com>
References: <20130701075856.6e8daa98.mchehab@redhat.com>
	<CAHFNz9J_FJP4YcCd3-_3x6d5iNDoqpYMMtX1Xd+OFJX4H7so0A@mail.gmail.com>
	<20130701123512.04e0ab62.mchehab@redhat.com>
	<CAHFNz9JJ1kOehY+3R6=c3MNvs0WN+hOXUDbKpG7yD6m=7mwkgw@mail.gmail.com>
	<20130701144219.2ce56054.mchehab@redhat.com>
Date: Mon, 1 Jul 2013 23:44:12 +0530
Message-ID: <CAHFNz9JPbE_m1Xk5CeVdDp3yQmwCvTjpmstAfWHh5XtUmQRAvQ@mail.gmail.com>
Subject: Re: [GIT PULL for v3.11] media patches for v3.11
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zoran Turalija <zoran.turalija@gmail.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Nicolas THERY <nicolas.thery@st.com>,
        Divneil Rai WADHAWAN <divneil.wadhawan@st.com>,
        Vincent ABRIOU <vincent.abriou@st.com>,
        Alain VOLMAT <alain.volmat@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 11:12 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Mon, 1 Jul 2013 21:17:58 +0530
> Manu Abraham <abraham.manu@gmail.com> escreveu:
>
>> On Mon, Jul 1, 2013 at 9:05 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>> > Em Mon, 1 Jul 2013 16:37:58 +0530
>> > Manu Abraham <abraham.manu@gmail.com> escreveu:
>> >
>> >> Mauro,
>> >>
>> >> On Mon, Jul 1, 2013 at 4:28 PM, Mauro Carvalho Chehab
>> >> <mchehab@redhat.com> wrote:
>> >> > Hi Linus,
>> >> >
>> >> > Please pull from:
>> >> >   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>> >> >
>> >> > For the media patches for Kernel v3.11.
>> >> >
>> >>
>> >> >
>> >> > Zoran Turalija (2):
>> >> >       [media] stb0899: allow minimum symbol rate of 1000000
>> >> >       [media] stb0899: allow minimum symbol rate of 2000000
>> >>
>> >>
>> >> Somehow, I missed these patches; These are incorrect. Please revert
>> >> these changes.
>> >> Simply changing the advertized minima values don't change the search algorithm
>> >> behaviour, it simply leads to broken behaviour.
>> >>
>> >> NACK for these changes.
>> >
>> > While this patch came from a sub-maintainer's tree, looking at its
>> > history, the patch was proposed here:
>> >         https://linuxtv.org/patch/18341/
>> >
>>
>>
>> Wherever it came from, the patch is incorrect. Anyone can throw in
>> any patch as they want.
>>
>>
>> > From what it is said there, with this patch, 6 additional channels
>> > were discovered when using with Eutelsat 16A, that uses a symbol
>> > rate between 2MS/s to 5 MS/s. Without this patch, those channels won't
>> > be discovered, as the core won't try to use a symbol rate outside
>> > the range.
>>
>> What you are stating is a hit and miss scenario, sometimes it might lock
>> and sometimes it wouldn't.
>
> Well, before this change, it was a full miss scenario, as it will
> never lock on low symbol rate channels.
>
>> The scanning algorithm that I implemented for the demodulator works
>> with a symbol rate as low as 5 MSPS alone. Anything lower than that
>> is hit and miss.
>
> Ok, so latter patches need to improve the algorithm to improve it
> for lower symbol rates. By getting feedback about this patch, we'll
> know more about how bad is the current algorithm, as people may now
> report and work on improve it.
>
>> > Of course, transponders with a symbol rate equal or upper than 5MS/s
>> > won't be affected by this patch.
>> >
>>
>>
>> How can you be sure ? I myself am not very sure. While we worked on
>> the demodulator in the early days, we had different situations where a
>> previous failed state could cause lockup of the demodulator, eventually
>> resulting tuning failures.
>
> If that happens, that would be a firmware or hardware issue.
> As I said before, ST can provide us an answer if the hardware has
> such bug.
>
>> > Even if this is not a perfect patch and some changes would be
>> > needed to improve tuning for those low symbol rate transponders,
>> > it seems better than before, as at least now some channels are tuned.
>> >
>> > The only reason I can see to reverse this patch is that if setting
>> > the frontend to low bit ranges could damage the frontend or could
>> > hit some bug on the hardware (or internal firmware).
>> >
>> > Yet, from the datasheet pointed by the patch author, it seems that
>> > this frontend allows such low symbol rates:
>> >         http://comtech.sg1002.myweb.hinet.net/pdf/dvbs2-6899.pdf
>>
>>
>> The frontend allows a different lower symbol rate with a different
>> scanning algorithm, not with this existing current one.
>>
>> I am pretty sure, that author saw some specifications written some
>> place and simply copied those numbers in here. Also sure that he
>> has no idea about the algorithm in use.
>>
>> According to ST itself, a 2MSPS algorithm was created for a very
>> specific customer requirement, which is not applicable to the existing
>> algorithm in use with the Linux STB0899 demodulator driver.
>
> Ok, so let's wait for ST to provide us some feedback on this public
> thread, in order to be sure that we need to reverse it because of
> some hardware bug, or to get an improved algorithm that will better
> work with low symbol rates.

I don't think anyone is going to spend enough time to answer your
stupid comments.

As being the author of this driver, and the person who added support
for cards based on the chipset: NACK

Linus,

I NACK the patches for the said reasons.


Regards,

Manu



Regards,

Manu

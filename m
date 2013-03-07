Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3CGARt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:17:49 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:57184 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab3CGARs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:17:48 -0500
MIME-Version: 1.0
In-Reply-To: <569718148.80620.1361906088301.JavaMail.mail@webmail13>
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
 <Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
 <CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com>
 <337833384.57445.1361860509194.JavaMail.mail@webmail08> <CAErSpo6CbO5KYXiErv6J_Dnm1u694C5fQPP2_cZL8VKDEnZa9A@mail.gmail.com>
 <569718148.80620.1361906088301.JavaMail.mail@webmail13>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 6 Mar 2013 17:17:26 -0700
Message-ID: <CAErSpo6UkVhSf+nFW4zwJLBQw_0RQ5H9Bv-UuQRb6zdwsFPw4g@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: stern@rowland.harvard.edu, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, rjw@sisk.pl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 12:14 PM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
> Feb 27, 2013 12:47:01 AM, Bjorn Helgaas wrote:
> On Mon, Feb 25, 2013 at 11:35 PM, Artem S. Tashkinov wrote:
>>> Feb 26, 2013 03:57:52 AM, Bjorn Helgaas wrote:
>>>>
>>>>Where are we at with this, Artem?  I assume it's still a problem.
>>>>
>>>
>>> Yes, it is, Bjorn.
>>>
>>> In order to eliminate this problem I switched back to MBR yesterday, because
>>> so far I haven't received any instructions or guidance as to how I can debug
>>> it further. I'm absolutely sure USB write speed is just another manifestation of
>>> it so I decided not to debug USB specifically (it just doesn't make too much
>>> sense).
>>>
>>> What I see is that something terribly wrong is going on but if Linus has no ideas
>>> I, as an average Joe, don't have a slightest clue as to what I can do.
>>>
>>> The bug report with necessary, but seemingly useless information, can be
>>> found here: https://bugzilla.kernel.org/show_bug.cgi?id=53551
>>>
>>> If anyone comes up with new ideas I can quickly try UEFI again now that I
>>> have two HDDs at my disposal (the old one is formatted as GPT, the new one is
>>> MBR).
>>
>>The ideas I saw are:
>>
>>1) Figure out whether it ever worked.  If an older kernel worked
>>correctly and a newer one is broken, bisection is at least a
>>possibility.  You mentioned that it did work before (Feb 12), but in
>>the past you never suspended twice in one boot session, whereas maybe
>>you did when seeing the problem?
>
> This is difficult to say since the first kernel I tried to run in EUFI mode was
> 3.7.x, so I've no idea if any previous ones ever worked.
>
>>
>>2) Try the "setpci" to set the MSI address back to the original value
>>to see if it makes a difference (see my Feb 12 message).
>
> I will try it soon and report back to you.
>
>>
>>3) Collect "lspci -vvv -xxxx" output to investigate the XHCI
>>Unsupported Request errors.
>>
>>4) Use usbmon to collect traces before and after the suspend.
>
> Likewise. Still I don't quite understand why you are persistent in your
> desire to investigate USB controllers specifically - my problem affects
> all storage devices that I have.

Well, in the absence of good ideas about what's going on, I guess we
have to pursue even the bad ideas that don't seem like they'd be
related :)  Speaking of bad ideas, any news on 2) and 3) above?

You mentioned in the bugzilla that Windows complains about MTRRs being
changed across the S4 sleep state transition.  I don't think Linux
looks for such a change.  You could try looking at /proc/mtrr before
and after the suspend/resume to see if anything changed there.  It
looks like there's even support for *writing* the MTRRs via
/proc/mtrr, so if anything did change, you could also try changing it
back.

Bjorn

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab3BZSrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:47:04 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:47434 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3BZSrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:47:02 -0500
MIME-Version: 1.0
In-Reply-To: <337833384.57445.1361860509194.JavaMail.mail@webmail08>
References: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
	<Pine.LNX.4.44L0.1302191119270.2215-100000@iolanthe.rowland.org>
	<CAErSpo7NZoOQZyW76HEoOTVgdqL2CgbVScAeF6HGLAVaNCq0=w@mail.gmail.com>
	<337833384.57445.1361860509194.JavaMail.mail@webmail08>
Date: Tue, 26 Feb 2013 11:46:59 -0700
Message-ID: <CAErSpo6CbO5KYXiErv6J_Dnm1u694C5fQPP2_cZL8VKDEnZa9A@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: stern@rowland.harvard.edu, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, rjw@sisk.pl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 11:35 PM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
> Feb 26, 2013 03:57:52 AM, Bjorn Helgaas wrote:
>>
>>Where are we at with this, Artem?  I assume it's still a problem.
>>
>
> Yes, it is, Bjorn.
>
> In order to eliminate this problem I switched back to MBR yesterday, because
> so far I haven't received any instructions or guidance as to how I can debug
> it further. I'm absolutely sure USB write speed is just another manifestation of
> it so I decided not to debug USB specifically (it just doesn't make too much
> sense).
>
> What I see is that something terribly wrong is going on but if Linus has no ideas
> I, as an average Joe, don't have a slightest clue as to what I can do.
>
> The bug report with necessary, but seemingly useless information, can be
> found here: https://bugzilla.kernel.org/show_bug.cgi?id=53551
>
> If anyone comes up with new ideas I can quickly try UEFI again now that I
> have two HDDs at my disposal (the old one is formatted as GPT, the new one is
> MBR).

The ideas I saw are:

1) Figure out whether it ever worked.  If an older kernel worked
correctly and a newer one is broken, bisection is at least a
possibility.  You mentioned that it did work before (Feb 12), but in
the past you never suspended twice in one boot session, whereas maybe
you did when seeing the problem?

2) Try the "setpci" to set the MSI address back to the original value
to see if it makes a difference (see my Feb 12 message).

3) Collect "lspci -vvv -xxxx" output to investigate the XHCI
Unsupported Request errors.

4) Use usbmon to collect traces before and after the suspend.

I googled around a bit looking for similar reports.  I found lots of
suspend issues, mostly with Windows, but no leads yet.  It looks like
the board has been around for a while, so you would think we'd have
some other reports of a problem this bad.  But maybe it really is
related to UEFI and nobody really uses that yet?

Bjorn

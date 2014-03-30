Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaC3KRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 06:17:20 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:48047 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaC3KRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 06:17:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140323193839.GY15608@titan.lakedaemon.net>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
	<20140319201838.GA11403@redhat.com>
	<CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com>
	<20140321132816.GW15608@titan.lakedaemon.net>
	<532DC3D3.9060008@linux.com>
	<CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com>
	<20140323193839.GY15608@titan.lakedaemon.net>
Date: Sun, 30 Mar 2014 12:17:17 +0200
X-Google-Sender-Auth: XD69p3i05UR4H3Nw2civXV9fRgA
Message-ID: <CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com>
Subject: Re: [RFC] QR encoding for Oops messages
From: Levente Kurusa <levex@linux.com>
To: Jason Cooper <jason@lakedaemon.net>,
        =?ISO-8859-2?B?VGVvZG9yYSBC42x1/uM=?= <teobaluta@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

(sorry for the late reply, looks like this mail has ran away from my clients)

2014-03-23 20:38 GMT+01:00 Jason Cooper <jason@lakedaemon.net>:
> All,
>
> On Sat, Mar 22, 2014 at 08:20:01PM +0200, Teodora Bãluþã wrote:
>> On Sat, Mar 22, 2014 at 7:09 PM, Levente Kurusa <levex@linux.com> wrote:
>> > On 03/21/2014 02:28 PM, Jason Cooper wrote:
> ...
>> >> I would definitely like to see the QR output incorporated into a
>> >> kernel.org url.  That would remove the need for installing another app,
>> >> and would ease bug reporting.
>> >
>> > I still struggle to understand how could that be done. We can encode the
>> > QR code as ASCII. Okay, that's fine, however it is very long. Encoding
>> > 'Unable to handle kernel paging request at 0000000f' gave a 449 character
>> > long sequence with very strange characters [0]. We should try to shorten
>> > it, imho. Not sure how to do that though.
>
> The man page for qrencode says you can have up to 4000 characters in a
> qrcode.  However, I've seen readers have trouble with a 2048bit ascii
> armored PGP public key (3929 characters).
>
> I grabbed a random oops from oops.kernel.org, it weighed in at 1544
> bytes, not too bad.  I then did:
>
> $ echo "https://oops.kernel.org/?qr=`cat oops.txt | gzip -9 | base64 -wrap=0`" | wc -c
> 993

I did the same with another OOPS and it had 1953 characters. That's quite a big
a big difference! :-)

I created a QR image from the URL then, and it was 147x147, which is
pretty small.
It took me quite a long time to make my phone recognize it, but it
worked nicely.

Result of work is in this directory:

http://levex.fedorapeople.org/kernel/qr/


>
> The benefit of a url is that any QR reader can automagically report an
> oops.  While a specific app could parse the URL/oops locally if the
> user desires.
>
>> it misses the point of having a QR code in the first place. The way I
>> see it, having a QR decoder app installed that can do an offline
>> decoding is a less greater effort than popping out a browser on the
>> machine you're working on.
>
> I think you're selling the advantage of the QR code short.  Automated
> reporting (via the url) is a _huge_ plus.  The app you conceive of could
> still parse it in place if the user desires.
>
> My point for the URL isn't to use the internet/server to automate oops
> parsing for the user.  Rather it's to make it easy to report oopses to
> developers.  While still preserving the ability of your app to parse it
> for the user.

Ah I see now. oops.kernel.org/?qr=<QR> would simply parse the
base64'd+gzip'd oops message and then report it.

Now I guess we need to think how to make it work without a
framebuffer. I already suggested using the ASCII characters,
but seeing the resolution of this QR code for example (147x147),
made me realize that we can't shuffle that into a 80x25 textmode
display. Any ideas how to fix that or should we just simply depend
on a framebuffer being present?

--
Regards,
Levente Kurusa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaCWTlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:41:44 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16375 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751578AbaCWTio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:38:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Y0M7/i2TGoGsKySFbA3m+hOvLbiPghLU=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2C0DF549AC1
Date: Sun, 23 Mar 2014 15:38:39 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Teodora =?utf-8?B?QsSDbHXFo8SD?= <teobaluta@gmail.com>
Cc: Levente Kurusa <levex@linux.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
Message-ID: <20140323193839.GY15608@titan.lakedaemon.net>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
 <20140319201838.GA11403@redhat.com>
 <CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com>
 <20140321132816.GW15608@titan.lakedaemon.net>
 <532DC3D3.9060008@linux.com>
 <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

On Sat, Mar 22, 2014 at 08:20:01PM +0200, Teodora Băluţă wrote:
> On Sat, Mar 22, 2014 at 7:09 PM, Levente Kurusa <levex@linux.com> wrote:
> > On 03/21/2014 02:28 PM, Jason Cooper wrote:
...
> >> I would definitely like to see the QR output incorporated into a
> >> kernel.org url.  That would remove the need for installing another app,
> >> and would ease bug reporting.
> >
> > I still struggle to understand how could that be done. We can encode the
> > QR code as ASCII. Okay, that's fine, however it is very long. Encoding
> > 'Unable to handle kernel paging request at 0000000f' gave a 449 character
> > long sequence with very strange characters [0]. We should try to shorten
> > it, imho. Not sure how to do that though.

The man page for qrencode says you can have up to 4000 characters in a
qrcode.  However, I've seen readers have trouble with a 2048bit ascii
armored PGP public key (3929 characters).

I grabbed a random oops from oops.kernel.org, it weighed in at 1544
bytes, not too bad.  I then did:

$ echo "https://oops.kernel.org/?qr=`cat oops.txt | gzip -9 | base64 -wrap=0`" | wc -c
993

The benefit of a url is that any QR reader can automagically report an
oops.  While a specific app could parse the URL/oops locally if the
user desires.

> it misses the point of having a QR code in the first place. The way I
> see it, having a QR decoder app installed that can do an offline
> decoding is a less greater effort than popping out a browser on the
> machine you're working on.

I think you're selling the advantage of the QR code short.  Automated
reporting (via the url) is a _huge_ plus.  The app you conceive of could
still parse it in place if the user desires.

My point for the URL isn't to use the internet/server to automate oops
parsing for the user.  Rather it's to make it easy to report oopses to
developers.  While still preserving the ability of your app to parse it
for the user.

thx,

Jason.

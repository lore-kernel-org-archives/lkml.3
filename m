Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593Ab3CLVVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:21:05 -0400
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:58095 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755716Ab3CLVVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:21:03 -0400
X-Greylist: delayed 3330 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2013 17:21:03 EDT
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: w1-gpio: fix erroneous gpio requests
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <20130312202028.GA6060@kroah.com>
Date: Wed, 13 Mar 2013 04:24:20 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Johan Hovold <jhovold@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Mack <zonque@gmail.com>,
        =?iso-8859-1?Q?Ville_Syrj=E4l=E4?= <syrjala@sci.fi>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <FE853F2C-A85A-4D0E-BF0E-80698F3E6567@jcrosoft.com>
References: <1363116094-8630-1-git-send-email-jhovold@gmail.com> <20130312202028.GA6060@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1499)
X-Ovh-Tracer-Id: 10304235947661962102
X-Ovh-Remote: 124.77.162.22 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 13, 2013, at 4:20 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Tue, Mar 12, 2013 at 08:21:34PM +0100, Johan Hovold wrote:
>> Fix regression introduced by commit d2323cf773 ("onewire: w1-gpio: add
>> ext_pullup_enable pin in platform data") which added a gpio entry to the
>> platform data, but did not add the required initialisers to the board
>> files using it. Consequently, the driver would request gpio 0 at probe,
>> which could break other uses of the corresponding pin.
>> 
>> On AT91 requesting gpio 0 changes the pin muxing for PIOA0, which, for
>> instance, breaks SPI0 on at91sam9g20.

not only on AT91, 0 is a valid gpio
>> 
>> Cc: stable <stable@vger.kernel.org>
>> Signed-off-by: Johan Hovold <jhovold@gmail.com>
>> ---
>> 
>> Not sure whose tree this should go in through, so adding relevant maintainers
>> and authors as CC.
> 
> As I took the offending patch, I might as well take this fix for it as
> well.
> 
> Unless anyone else objects?
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.


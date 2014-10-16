Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaJPJpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:45:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58008 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751293AbaJPJpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:45:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Darren Hart <dvhart@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "dvhart@infradead.org" <dvhart@infradead.org>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties support
Date: Thu, 16 Oct 2014 12:05:16 +0200
Message-ID: <2459115.UMgof0Byf6@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <543E9605.6020502@linux.intel.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <20141015151702.GG20034@leverpostej> <543E9605.6020502@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 15, 2014 05:43:01 PM Darren Hart wrote:
> 
> On 10/15/14 17:17, Mark Rutland wrote:
> > On Wed, Oct 15, 2014 at 03:46:39PM +0100, Darren Hart wrote:
> 
> >> Mark, what would you propose we do differently to enable this driver to
> >> be firmware-type agnostic?
> > 
> > For this particular driver, all I'm asking for is that the
> > "used-by-rtas" property is not moved over from of_find_property to
> > device_get_property. It is irrelevant for all ACPI systems. Evidently my
> > comment was unclear; I apologise for that.
> 
> So my objection here is that by keeping the of_* terms in the driver we
> are required to include of, although it does safely convert to returning
> NULL if !CONFIG_OF I suppose.

Agreed.

> > We have status = "disabled" as a less specific mechanism for telling the
> > OS to ignore a node in DT. I was under the impression that ACPI already
> > had a mechanism for marking devices to be ignored, but perhaps I am
> > mistaken.
> 
> That is correct, in ACPI this would be properly implemented with the
> _STA reserved named method. In which case it wouldn't enumerate.
> 
> > 
> > The concerns I mentioned at the end of my original reply were of a more
> > general nature than this particular device description.

Moreover, to me, the question really is "Does this driver need to be any
different depending on whether DT or ACPI is used by the platform and if
so, then why?".

In my opinion, there is no technical reason for such differences to be present
in this particular case.  The fact that the "used-by-rtas" property does not
make sense for the ACPI case doesn't imply that the driver should not be allowed
to check it then.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

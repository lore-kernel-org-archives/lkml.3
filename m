Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaJOPnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:43:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:63916 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaJOPna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:43:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,725,1406617200"; 
   d="scan'208";a="614963196"
Message-ID: <543E9605.6020502@linux.intel.com>
Date: Wed, 15 Oct 2014 17:43:01 +0200
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties
 support
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <1413378271.2762.77.camel@infradead.org> <20141015131551.GC20034@leverpostej> <1413379736.2762.79.camel@infradead.org> <20141015134209.GD20034@leverpostej> <db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org> <543E88CF.5060504@linux.intel.com> <20141015151702.GG20034@leverpostej>
In-Reply-To: <20141015151702.GG20034@leverpostej>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/15/14 17:17, Mark Rutland wrote:
> On Wed, Oct 15, 2014 at 03:46:39PM +0100, Darren Hart wrote:

>> Mark, what would you propose we do differently to enable this driver to
>> be firmware-type agnostic?
> 
> For this particular driver, all I'm asking for is that the
> "used-by-rtas" property is not moved over from of_find_property to
> device_get_property. It is irrelevant for all ACPI systems. Evidently my
> comment was unclear; I apologise for that.

So my objection here is that by keeping the of_* terms in the driver we
are required to include of, although it does safely convert to returning
NULL if !CONFIG_OF I suppose.

> We have status = "disabled" as a less specific mechanism for telling the
> OS to ignore a node in DT. I was under the impression that ACPI already
> had a mechanism for marking devices to be ignored, but perhaps I am
> mistaken.

That is correct, in ACPI this would be properly implemented with the
_STA reserved named method. In which case it wouldn't enumerate.

> 
> The concerns I mentioned at the end of my original reply were of a more
> general nature than this particular device description.
> 
> Thanks,
> Mark.
> 

-- 
Darren Hart
Intel Open Source Technology Center

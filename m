Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbbAIOMC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:12:02 -0500
Received: from mga14.intel.com ([192.55.52.115]:30967 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbbAIOMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:12:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,731,1413270000"; 
   d="scan'208";a="667122111"
From: "Ong, Boon Leong" <boon.leong.ong@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Darren Hart <dvhart@infradead.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] platform/x86: Add Intel Galileo platform specific
 setup
Thread-Topic: [PATCH 2/2] platform/x86: Add Intel Galileo platform specific
 setup
Thread-Index: AQHQI40vC/jPbCARaECVf0xQIEga65y2wS2AgABtYoCAAAMzAIAAsj9A
Date: Fri, 9 Jan 2015 14:11:55 +0000
Message-ID: <AF233D1473C1364ABD51D28909A1B1B7326E3F6C@PGSMSX105.gar.corp.intel.com>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
 <1419873783-5161-3-git-send-email-pure.logic@nexus-software.ie>
 <20150109044613.GB9311@vmdeb7> <54AFB8D7.6020306@nexus-software.ie>
 <54AFBB86.5040307@nexus-software.ie>
In-Reply-To: <54AFBB86.5040307@nexus-software.ie>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>On 09/01/15 11:17, Bryan O'Donoghue wrote:
>>> So this will load on any Quark device, Galileo or not, that doesn't
>>> provide a system_id. Is there any reason we need to support 0.8.0 and
>>> earlier firmware?
>>
>> Every Galileo Gen1 device ships with firmware version 0.7.5. You can
>> do an EFI capsule update to 0.8.0 which still isn't DMI-enabled - or
>> you can go and get a firmware greater than 0.9.0 and get DMI strings.
>
>I should add to that. Hundreds of the Gen1 devices were given away @
>MakerFaire Rome 2013, and AFAIK thousands were given to universities. So
>there's probably a few thousands boards floating around with the 0.7.5
>firmware that we want to support.
>
>Like I say - I think the fall-back is the simplest option and is also safe. I can add in
>the old way of identifying the boards and we can review it for appropriateness.
>I didn't include that old method for the fallback because it involves mapping SPI
>flash and parsing custom headers but - it works - even if it is ugly.
>

I agree with Bryan on his view-point. The logic to default to Galileo Gen-1 with older-firmware.
seems reasonable to me too. We cannot for sure older Galileo Gen-1 user will upgrade to newer
version of firmware. I suspect that many will not (because lack of understanding of how
UEFI capsule can do that or lack of equipment to flash it too, especially university students). 

So for the lack of better & robust approach, the default fallback when DMI string is not
detectable to GENv1 seems reasonable.

My 2 cents.

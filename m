Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbbAGW7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 17:59:46 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38464 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755285AbbAGW7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 17:59:43 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18wtCYmYx9l0opv658lIXmrL3tgqHvzX4w=
X-DKIM: OpenDKIM Filter v2.0.1 titan B12566403D4
Date: Wed, 7 Jan 2015 17:59:04 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Jon Masters <jcm@redhat.com>
Cc: Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
Message-ID: <20150107225904.GQ24989@titan.lakedaemon.net>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>
 <2161376.07iV9ANMSk@wuerfel>
 <20150107115039.GA2199@e104818-lin.cambridge.arm.com>
 <1520439.Y1rXzXY1eS@wuerfel>
 <20150107172741.GY2634@sirena.org.uk>
 <20150107184158.GO24989@titan.lakedaemon.net>
 <54AD8FF2.60407@redhat.com>
 <54AD917A.2040307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AD917A.2040307@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 03:05:14PM -0500, Jon Masters wrote:
> On 01/07/2015 02:58 PM, Jon Masters wrote:
> > On 01/07/2015 01:41 PM, Jason Cooper wrote:
> 
> >> One of the reasons I've really enjoyed working with ARM platforms and DT
> >> is the absence of this type of 'feature'.  I honestly don't care whether
> >> the kernel gets the board configuration info from DT or ACPI or FOO, as
> >> long as we can avoid the security mistakes of the past:
> >>
> >>   http://www.spiegel.de/international/world/catalog-reveals-nsa-has-back-doors-for-numerous-devices-a-940994.html
> > 
> > ACPI is not the great satan. I'm aware certain others in the community
> > have written missinformed blog posts and G+ rants equating ACPI with SMI
> > and even with various other system firmware. I can't force someone to
> > become informed on a topic, especially if it's politically useful to
> > them to hate on ACPI and use the security paranoia handwavy argument.
> 
> To clarify, and this is not directed at you Jason, it is politically
> useful to some who have written rants those business models are built
> upon being paid to enable platforms. For those folks, standardized
> platforms which allow a common OS approach are seen as threatening.

Ahh, thanks for clarifying.

> In the previous rants (which were really instigated as a result of the
> above) ACPI was equated with SMM (System Management Mode), which is a
> bit like the Secure/Trusted world on AArch64 in which you might run
> another "Trusted" OS. These are the places where you want to watch out
> to malware of the kind cited in your link, not in ACPI tables.

fwiw, I *am* concerned about those spaces.  It seems we agree on their
vulnerability to attack (plus being meaty targets).

To more concisely state my other reply to you, wrt to AML, I'm primarily
concerned about a malicious update to the ACPI tables.  The ACPI tables
in the update would be otherwise normal, except for the AML blob that
contains some extra code.  The malicious payload.  Then, a routine call
into an AML (for pinctrl, say) executes the malicious code.

The plausibility and preventability of that style of attack is what I'm
hoping to nail down with this discussion.

thx,

Jason.

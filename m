Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaF0LHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:07:49 -0400
Received: from www.xora.org.uk ([80.68.91.202]:43563 "EHLO
	xora.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaF0LHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:07:31 -0400
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2014 07:07:31 EDT
Date: Fri, 27 Jun 2014 11:57:05 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>, linux-acpi@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, lorenzo.pieralisi@arm.com,
        rric@kernel.org, Al Stone <al.stone@linaro.org>,
        linaro-acpi@lists.linaro.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Charles.Garcia-Tobin@arm.com
Subject: Re: [PATCH v4 06/13] ARM64 / ACPI: Introduce early_param for "acpi"
Message-ID: <20140627105705.GA5677@xora-haswell.xora.org.uk>
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
 <1403840976-7456-7-git-send-email-hanjun.guo@linaro.org>
 <23398804.v8nA0xfjOe@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23398804.v8nA0xfjOe@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 11:07:48AM +0200, Arnd Bergmann wrote:
> On Friday 27 June 2014 11:49:29 Hanjun Guo wrote:
> > +
> > +static int __init parse_acpi(char *arg)
> > +{
> > +       if (!arg)
> > +               return -EINVAL;
> > +
> > +       /* "acpi=off" disables both ACPI table parsing and interpreter */
> > +       if (strcmp(arg, "off") == 0) {
> > +               disable_acpi();
> > +       }
> > +       /* acpi=strict disables out-of-spec workarounds */
> > +       else if (strcmp(arg, "strict") == 0) {
> > +               acpi_strict = 1;
> > +       } else {
> > +               /* Core will printk when we return error */
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +early_param("acpi", parse_acpi);
> 
> Can you explain in the changelog what happens for the acpi=off case? Does this
> mean we fall back to using data from the dtb instead, or will it just not work?
> 
> If I understand correctly, this option makes sense on PC systems that will
> still be able to boot using the legacy BIOS services and implicit assumptions
> about the hardware, but that never works on arm64.
> 
Yes the way ACPI has been integrated on ARM64 in these patches if you
supply acpi=off it will fall back to DTB if supplied by firmware.

Graeme


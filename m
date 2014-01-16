Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaAPRDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:03:34 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42349 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaAPRD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:03:26 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 04/18] driver core & of: Mark of_nodes of added device as populated
To: Rob Herring <robherring2@gmail.com>, Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
In-Reply-To: <CAL_JsqJGQFstgFu=tpho91C0iv4eH9XSCAVKfXXQO4Z+yD-0tw@mail.gmail.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com> < 1387815830-8794-5-git-send-email-pawel.moll@arm.com> < CAL_JsqJGQFstgFu=tpho91C0iv4eH9XSCAVKfXXQO4Z+yD-0tw@mail.gmail.com>
Date: Thu, 16 Jan 2014 17:03:20 +0000
Message-Id: <20140116170320.F083BC40973@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014 11:28:01 -0600, Rob Herring <robherring2@gmail.com> wrote:
> On Mon, Dec 23, 2013 at 10:23 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> > In "Device Tree powered" systems, platform devices are usually
> > massively populated with of_platform_populate() call, executed
> > at some level of initcalls, either by generic architecture
> > or by platform-specific code.
> >
> > There are situations though where certain devices must be
> > created (and bound with drivers) before all the others.
> > This presents small challenge in DT-driven systems, as
> > devices explicitly created in early code would be created
> > again by of_platform_populate().
> 
> Isn't this already at least partially solved with the aux data
> support? I'm guessing the difference here is how the early device is
> created.

Still, creating a device early and then trying to remember that it has
been done does nothing but add complexity for a very small number of use
cases. I still would much rather see things that need really early setup
to avoid the device model entirely and do the bare minimum needed to
allow the kernel to get to initcall time. In the cases where a subsystem
API requires a struct device, I would consider using a dummy throwaway
struct device for the early bits.

g.

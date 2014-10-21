Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaJUKF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:05:57 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53443 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaJUKFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:05:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>,
        Ankit Jindal <ankit.jindal@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>, "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@apm.com" <patches@apm.com>, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>
Subject: Re: [PATCH v3 5/6] Documentation: dt-bindings: Add binding info for X-Gene QMTM UIO driver
Date: Tue, 21 Oct 2014 12:05:42 +0200
Message-ID: <3725049.9xPbukhCva@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141021091412.GB15293@leverpostej>
References: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org> <1413871011-4101-6-git-send-email-ankit.jindal@linaro.org> <20141021091412.GB15293@leverpostej>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:27uoHhagJuTbG5dplru47xfIeB7JvP4EbVAagwkRBuP
 qIeYGirOJOcYXPyrL19RwXQEb/QyNFqKF0JlC4jmpNvRQtjNrk
 EP/ZClDPdgXdJahNJCchG3DHpePp6VP/+YiLkJwfXvJRnn8ozh
 GJ+J+wchkV9dpsgLMJSc7MKw3I3Uwcfoiepv0kTF3lgFwSg/nn
 3OdQg1V9PtMhSJTkNQlGfddy7yKtxoVemTfTHQallsp1b1WkS9
 vtCzKqZJI/8Cbe7sFoI56JOgL12xddt0sYXzK/H2CABGQl11ad
 DF+0t6Z+Cb9UTpcG6cwGSYhVpNWOQU/EbCuRzpS8JStAZvdblv
 CnclY860T7ajUdFFp2FM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2014 10:14:12 Mark Rutland wrote:
> 
> > +The Applied Micro X-Gene SOC has on-chip QMTM (Queue manager
> > +and Traffic manager). It is a device for managing hardware queues.
> > +It also implements QoS among hardware queues hence term "traffic"
> > +manager is present in its name. QMTM UIO nodes are defined for user
> > +space access to this device using UIO framework.
> 
> The binding should describe the hardware, not the software. Please drop
> mention of UIO, userspace, etc.

I have a bad feeling about the entire idea of doing the UIO driver first,
there are too many unknowns here and we should not break the binding
when the proper driver gets added.

The X-Gene is meant for server workloads, so the UIO approach is not
a good longterm solution anyway. My impression is that it would be
better to first get the kernel driver for this hardware merged and
the binding fixed, and then a UIO stub could get added to that driver,
taking over the hardware by user space. This would also solve the
arbitration between the two driver implementations. It's also possible
that by that time, we will have a functional VFIO framework for
platform devices.

	Arnd

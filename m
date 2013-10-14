Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3JNXWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 19:22:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53636 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3JNXWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 19:22:46 -0400
Date: Tue, 15 Oct 2013 00:22:39 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "corentin.chary@gmail.com" <corentin.chary@gmail.com>,
        "acpi4asus-user@lists.sourceforge.net" 
	<acpi4asus-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] platform: x86: asus-wmi: add fan control
Message-ID: <20131014232239.GA29716@srcf.ucam.org>
References: <1381236524-19633-1-git-send-email-felipe.contreras@gmail.com>
 <CAHR064ge8zew7uMeD+_LXR3ju5ARGG1y8utLOFzOLexny_DPLA@mail.gmail.com>
 <1381421199.4248.2.camel@x230.lan>
 <CAMP44s04+_aP7KpVMTUjdNcRWMg6PC6HBaNhF_uhAHm=fhmTcw@mail.gmail.com>
 <20131013151729.GA4028@srcf.ucam.org>
 <CAMP44s0utW0ABWgFicDH=vDMxZbQudeM6D13RL8BfPnr55hR8Q@mail.gmail.com>
 <20131014155254.GB20187@srcf.ucam.org>
 <CAMP44s3O6z6-gVCqhCps7fKSKMbL9JSakZLfBUxqUYytrWFWKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s3O6z6-gVCqhCps7fKSKMbL9JSakZLfBUxqUYytrWFWKw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 06:18:36PM -0500, Felipe Contreras wrote:
> On Mon, Oct 14, 2013 at 10:52 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > It wouldn't be appropriate to alter the firmware behaviour by default,
> > but yeah, that's the kind of thing that the thermal framework exists to
> > do.
> 
> Well, how do I do that? The driver is up and running, and I can
> manually set different fan speeds, however nothing seems to happen
> automatically when the temperature increases.

The easiest is to just do it from userspace. I think Intel have some 
code for doing this, but I haven't looked at the thermal code for years.

> > I don't think you can easily register multiple drivers for the same WMI
> > device.
> 
> I don't mean this one, I mean the standalone one. Actually, the first
> one I sent doesn't require all this system memory stuff.

Banging EC registers directly is the wrong thing to do. Going via WMI is 
correct.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

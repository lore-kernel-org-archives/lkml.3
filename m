Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaAYQS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 11:18:28 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52084 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbaAYQSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 11:18:24 -0500
X-Sasl-enc: /8WSxR9QpX5HP8CS1vmGq0f8tV3Nd1GOXWdCE1Q2TA79 1390666703
Date: Sat, 25 Jan 2014 14:18:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [kernel 3.13.0-06058-g2d08cd0] Strange ACPI error messages
Message-ID: <20140125161817.GB25531@khazad-dum.debian.net>
References: <CADDKRnDZt9Q4XKyJcO1htMrCJYj6_5yECURBHsJ7O==hup7ZRw@mail.gmail.com>
 <9739501.rBu7tJQIYj@vostro.rjw.lan>
 <4387759.ffnsEjDaad@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4387759.ffnsEjDaad@vostro.rjw.lan>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jan 2014, Rafael J. Wysocki wrote:
> On Saturday, January 25, 2014 02:53:24 PM Rafael J. Wysocki wrote:
> > On Saturday, January 25, 2014 11:03:09 AM Jörg Otte wrote:
> > > Kernel 3.13.0-06058-g2d08cd0 displays following errors on the console:
> > > 
> > > ACPI: \_PR_.CPU4: failed to get CPU APIC ID.
> > > ACPI: \_PR_.CPU5: failed to get CPU APIC ID.
> > > ACPI: \_PR_.CPU6: failed to get CPU APIC ID.
> > > ACPI: \_PR_.CPU7: failed to get CPU APIC ID.
> > > 
> > > I don't have CPUs 4..7! Error messages regarding not existing
> > > CPUs should not be displayed.
> > > kernel 3.13.0-05617-g3aacd62 and before did'nt show this messages.
> > > 
> > > This is a regression. I never saw this messages before.
> > 
> > Does your system show any other suspicious symptoms or are you worried about
> > those messages only?
> 
> Gerry, this is your commit b981513f806d (ACPI / scan: bail out early if failed
> to parse APIC ID for CPU).  Apparently, the BIOS has room for 4 CPUs more than
> there actually are in the system.  Maybe we can reduce the log level of those
> messages to avoid ringing bells unnecessarily?

It is standard practice (at least in SuperMicro boxes, but I've also seen it
elsewhere) for the BIOS to have ACPI tables mentioning all cores supported
by the biggest core-count CPU topology possible by the motherboard.  The
cores you don't have are reported as if they were hotpluggable but absent,
even if they will *never* show up at runtime.  Meh.

So yes, such warnings will get annoying *very* quickly.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbaGHTRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:17:45 -0400
Received: from cernmx13.cern.ch ([188.184.36.46]:33164 "EHLO CERNMX13.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932580AbaGHTRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:17:16 -0400
From: Federico Vaga <federico.vaga@cern.ch>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <michel.arruat@cern.ch>
Subject: Re: PCIe bus enumeration
Date: Tue, 8 Jul 2014 21:20:59 +0200
Message-ID: <3107266.EcOOcRPPM0@harkonnen>
Organization: CERN
User-Agent: KMail/4.12.5 (Linux/3.14.9-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <CAErSpo5ixtc=n0f56=QvtxYnXumZiao6NMgBVAWpcJH4f7QA4g@mail.gmail.com>
References: <280883016.9onmf0miLq@pcbe13110.cern.ch> <5283004.YemU4lhtKD@pcbe13110.cern.ch> <CAErSpo5ixtc=n0f56=QvtxYnXumZiao6NMgBVAWpcJH4f7QA4g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [81.65.79.216]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2014 12:23:39 Bjorn Helgaas wrote:
> On Tue, Jul 8, 2014 at 1:15 AM, Federico Vaga 
<federico.vaga@cern.ch> wrote:
> >> > So, It looks like that some BIOS disable the bridge when there
> >> > is
> >> > nothing behind it. Why? Power save? :/
> >> 
> >> Could be power savings, or possibly to conserve bus numbers,
> >> which
> >> are a limited resource.
> > 
> > what is the maximum number of buses?
> 
> 256.

Well, it is not a small number. I will ask directly to the company who 
sell this crate and ask them what is going on in the BIOS

> > At this point I'm a little bit confused about the definition "slot
> > numbers" :) You mean the 22, 25, ...
> 
> Right.  Bus numbers are under software control, to some degree (as a
> general rule, an x86 BIOS assigns them and Linux leaves them alone,
> but they *can* be changed so they aren't a good thing to rely on).
> The bus number of a root bus is usually determined by hardware or
> by an arch-specific host bridge driver.  The bus number below a
> PCI-PCI bridge is determined by the bridge's "secondary bus number"
> register, which software can change.
> 
> Slot numbers are based on the Physical Slot Number in the PCIe Slot
> Capability register.  This is set by some hardware mechanism such as
> pin strapping or a serial EEPROM.  Software can't change it, so you
> can rely on it to be constant.  (There's also a mechanism for
> getting a slot number from ACPI, but that should also return a
> constant value).  The problem is that I don't think the Linux slot
> number support is very good, so I'm sure there's plenty of stuff
> that we *should* be able to do that we can't do *yet*.

Mh, I understand. Let's say that I have time to spend on this problem 
(I do not know) and contributing to the PCI subsystem. How many 
differences are there between 3.2, 3.6, 3.16/next? We are using 
3.2/3.6 at the moment, but probably you should expect that it will 
work on the last version :)

-- 
Federico Vaga

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab3BWVen (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 16:34:43 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:36060 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab3BWVeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 16:34:00 -0500
Date: Sat, 23 Feb 2013 12:21:17 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 4/8] FMC: add documentation for the core
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
        Juan David Gonzalez Cobas <dcobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        linux-doc@vger.kernel.org
In-Reply-To: <fc6de6d3c561ddfbd08a44a6f0f50882a9cbfa2e.1361469466.git.rubini@gnudd.com>
	(from rubini@gnudd.com on Thu Feb 21 12:14:12 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1361643677.11282.5@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 12:14:12 PM, Alessandro Rubini wrote:
> This is selected sections of the current manual for fmc-bus, as
> developed outside of the kernel before submission.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
> Acked-by: Emilio G. Cota <cota@braap.org>
> Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

Acked-by: Rob Landley <rob@landley.net>

On the basis it's all nicely in its own subdirectory not bothering  
anyone else.

That said:

> +The data structure that describe a device is detailed in *note FMC
> +Device::, the one that describes a driver is detailed in *note FMC
> +Driver::.

What is this *note thingy:: syntax? It recurs a lot. Some sort of  
reference into the PDF you started out with a link to, maybe?

 From your 00-INDEX additions:

> +FMC-and-SDB.txt
> +	- What are FMC and SDB, basic concepts for this framework

> +What is FMC
> +***********
> +
> +FMC, as said, stands for "FPGA Mezzanine Card". It is a standard
> +developed by the VME consortium called VITA (VMEbus International  
> Trade
> +Association and ratified by ANSI, the American National Standard
> +Institute.  The official documentation is called "ANSI-VITA 57.1".
> +
> +The FMC card is an almost square PCB, around 70x75 millimeters, that  
> is
> +called mezzanine in this document.  It usually lives plugged into
> +another PCB for power supply and control; such bigger circuit board  
> is
> +called carrier from now on, and a single carrier may host more than  
> one
> +mezzanine.

A basic concept of this framework is that you have a 70x75 PCB? Is this  
part of that ANSI-VITA standard?

> +In the typical application the mezzanine is mostly analog while the
> +carrier is mostly digital, and hosts an FPGA that must be configured  
> to
> +match the specific mezzanine and the desired application. Thus, you  
> may
> +need to load different FPGA images to drive different instances of  
> the
> +same mezzanine.

 From the top level 00-INDEX:

> +fmc/
> +	- information about the FMC bus abstraction

And then...

> +FMC, as such, is not a bus in the usual meaning of the term, because
> +most carriers have only one connector, and carriers with several
> +connectors have completely separate electrical connections to them.
> +This package, however, implements a bus as a software abstraction.

USB is point to point connections with switches in between. It's still  
got B in the acronym. I'm not sure what you're saying here.

> +
> +What is SDB
> +***********
> +
> +SDB (Self Describing Bus) is a set of data structures that we use for
> +enumerating the internal structure of an FPGA image. We also use it  
> as
> +a filesystem inside the FMC EEPROM.

Are you trying to document infrastructure to implement a standard, or a  
bespoke driver for a specific piece of hardware? How much of this is  
generic? Are there other vendors who might someday want to use this  
code?

Anyway, no serious objection, but I note that reading to this point I  
didn't feel I had enough information to wrap my head around what it's  
for. It's documentation by people who already know this stuff, for  
people who already know this stuff. (There's a long tradition of that.  
Oh well.)

Rob

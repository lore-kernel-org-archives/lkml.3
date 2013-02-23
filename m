Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab3BWW4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 17:56:48 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:48696 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758847Ab3BWW4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 17:56:46 -0500
Date: Sat, 23 Feb 2013 23:56:13 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: rob@landley.net
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, dcobas@cern.ch,
        cota@braap.org, siglesias@igalia.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH 4/8] FMC: add documentation for the core
Message-ID: <20130223225613.GA24239@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1361643677.11282.5@driftwood>
References: <1361643677.11282.5@driftwood> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Acked-by: Rob Landley <rob@landley.net>

Thanks.

> What is this *note thingy:: syntax? It recurs a lot. Some sort of  
> reference into the PDF you started out with a link to, maybe?

My documentation is texinfo and this is the ASCII output, manually
split into different files. I fixed some of the internal references
when I noted them.  But since it's manual work, I didn't do it
carefully.  I suspect I'll need to V2 for some reason anyways.

> A basic concept of this framework is that you have a 70x75 PCB? Is this  
> part of that ANSI-VITA standard?

Yes. the form-factor is fixed, like PC104 in the PC world.  Here's the
jpg of a carrier: http://www.ohwr.org/attachments/download/552 (from
http://www.ohwr.org/projects/spec/wiki). And here's the jpg of a
mezzanine:
http://www.ohwr.org/attachments/download/833/FmcAdc100M14b4cha_top_small.JPG

You find more on the net, also from commercial vendors.

>> +FMC, as such, is not a bus in the usual meaning of the term, because
>> +most carriers have only one connector, and carriers with several
>> +connectors have completely separate electrical connections to them.
>> +This package, however, implements a bus as a software abstraction.
> 
> USB is point to point connections with switches in between. It's still  
> got B in the acronym. I'm not sure what you're saying here.

FMC has no switches, no hotplug, not even shared wires like ISA.  I
took a while to explain some hardware guys that it ought to be a
"bus" in software. That's why I have the paragraph.

>> +What is SDB
>> +***********
>> +
>> +SDB (Self Describing Bus) is a set of data structures that we use for
>> +enumerating the internal structure of an FPGA image. We also use it  
>> as
>> +a filesystem inside the FMC EEPROM.
> 
> Are you trying to document infrastructure to implement a standard, or a  
> bespoke driver for a specific piece of hardware? How much of this is  
> generic? Are there other vendors who might someday want to use this  
> code?

SDB is already implemented and is generic.  We enumerate the devices
inside the FPGA already, and it only costs a few lines of VHDL (using
the support files by Wesley Terpstra) to describe your own FPGA
design. Wesley even discovers and enumerates devices over the
Ethernet, by means of Ethernet-driven device access and SDB-aware host
code -- all code is published.

The SDB specification is discussed in a mailing list and is public
(http://www.ohwr.org/attachments/download/1486/sdb-1.0.pdf). By having
64-bit vendor identifiers we encourage anyone who finds SDB useful to
become a vendor. There are a few vendors already, although I admit the
early adopters are involved in the same set of projects.

> Anyway, no serious objection, but I note that reading to this point I  
> didn't feel I had enough information to wrap my head around what it's  
> for. It's documentation by people who already know this stuff, for  
> people who already know this stuff. (There's a long tradition of that.  
> Oh well.)

I'm aware of this. But it's the same if you read USB documentation
without ever seeing one such device (I remember the feeling :).  FMC
is not common on the shelf, but it is already renown in high-profile
I/O environments.

Thanks
/alessandro

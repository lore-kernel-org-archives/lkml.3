Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbaBQTZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:25:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbaBQTZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:25:24 -0500
From: Thomas Renninger <trenn@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, devel@acpica.org
Subject: Re: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
Date: Mon, 17 Feb 2014 20:25:18 +0100
Message-ID: <4233973.R9Tf84J4Ne@skinner>
User-Agent: KMail/4.11.4 (Linux/3.11.6-4-desktop; KDE/4.11.4; x86_64; ; )
In-Reply-To: <53025956.40505@zytor.com>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <1678556.oPQNyVF84j@skinner> <53025956.40505@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 17, 2014 10:47:50 AM H. Peter Anvin wrote:
> On 02/17/2014 10:23 AM, Thomas Renninger wrote:
> > Easiest I can think of instead of trying to modify RSDP or similar, is
> > to still pass the tables via unzipped, glued cpio which the kernel
> > can access early. The same way it is done for current ACPI table
> > overriding
> > and early microcode passing.
> 
> We shouldn't *need* an RSDP and RSDT/XSDT, though, since all they are
> are pointers to the actual tables.  Rather than hacking around it we
> should probably just fix the fundamental problem.

That is what I described.
If something similar what I wrote gets implemented, you can simply
add ACPI tables to initrd as described here:
Documentation/acpi/initrd_table_override.txt
and if BIOS already provides them they get overridden, otherwise
they get added.

     Thomas

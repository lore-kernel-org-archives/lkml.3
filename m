Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3GIIgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:36:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab3GIIgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:36:06 -0400
Subject: Re: Suspect loop in dmi_scan_machine()
From: Jean Delvare <jdelvare@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20130708163357.GA4752@decadent.org.uk>
References: <1373298554.4298.228.camel@chaos.site>
	 <20130708163357.GA4752@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 09 Jul 2013 10:35:47 +0200
Message-ID: <1373358947.4391.3.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Le Monday 08 July 2013 à 17:33 +0100, Ben Hutchings a écrit :
> On Mon, Jul 08, 2013 at 05:49:14PM +0200, Jean Delvare wrote:
> > I am looking at this commit of yours:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/firmware/dmi_scan.c?id=79bae42d51a5d498500c890c19ef76df41d2bf59
> > 
> > and am a little worried about the for loop in dmi_scan_machine()
> > (non-EFI case):
> [...]
> 
> I don't see any of the bugs you describe.  Let me explain what
> I probably should have put in a comment:
> 
> We want to find a DMI header at [0xf0000, 0xffff0] and possibly an
> SMBIOS header 16 bytes before that.  buf contains a copy of the 32
> bytes centred at p.  On the first iteration p - 16 is out of range, so
> the first 16 bytes of the buffer are filled with zeroes.
> 
> Does that address your concerns?  If not then please explain precisely
> how this loop can go wrong.

Wow. I'm not sure what I was up to yesterday evening but I definitely
should have waited a bit before posting. I read your code again this
morning and it is completely correct, and the concerns I raised
yesterday were plain crap. I suppose your code was too smart for my
tired brain...

Sorry for the noise,
-- 
Jean Delvare
Suse L3


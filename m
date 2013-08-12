Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3HLMdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 08:33:20 -0400
Received: from numidia.opendz.org ([98.142.220.152]:55498 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3HLMdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 08:33:18 -0400
Date: Mon, 12 Aug 2013 13:33:09 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: mvm: make debugfs write() operations write up
 to count bytes
Message-ID: <20130812123309.GA2911@dztty>
References: <1376267972-5636-1-git-send-email-tixxdz@opendz.org>
 <1DC40B07CD6EC041A66726C271A73AE61AA5E38C@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1DC40B07CD6EC041A66726C271A73AE61AA5E38C@IRSMSX102.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 08:19:12AM +0000, Berg, Johannes wrote:
> > Some debugfs write() operations of the MVM Firmware will ignore the count
> > argument, and will copy more bytes than what was specified.
> > Fix this by getting the right count of bytes.
> > 
> > This will also honor restrictions put on the number of bytes to write.
> 
> That makes some sense.
And avoid strncmp() on garbage data.

> > To be consitant this patch also switches the initializer from 'char buf[x] = {}' to
> > the explicit memset() as it is done in other places of the same file.
> 
> I'd rather this (a) be done in a separate patch, and (b) the other way around, switch everything to C99.
Ok

> > Cc: stable@vger.kernel.org
> 
> That doesn't really make sense for the debugfs interface.
Ok

> > +	memset(buf, 0, sizeof(buf));
> > +	if (count > sizeof(buf) - 1)
> > +		count = sizeof(buf) - 1;
> 
> Why -1? And why not use min()/min_t()?
Yes -1 to be sure that the processed string is null terminated

Ok will use min_t 


Will send a second version, Thanks!

> johannes
> -- 
> 
> Intel GmbH
> Dornacher Strasse 1
> 85622 Feldkirchen/Muenchen, Deutschland
> Sitz der Gesellschaft: Feldkirchen bei Muenchen
> Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
> Registergericht: Muenchen HRB 47456
> Ust.-IdNr./VAT Registration No.: DE129385895
> Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052
> 

-- 
Djalal Harouni
http://opendz.org

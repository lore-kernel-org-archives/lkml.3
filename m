Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501Ab3DBU7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:59:10 -0400
Received: from 8bytes.org ([85.214.48.195]:54500 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762440Ab3DBU7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:59:06 -0400
Date: Tue, 2 Apr 2013 22:59:04 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>, suravee.suthikulpanit@amd.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130402205904.GT30540@8bytes.org>
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130402143335.GB15687@8bytes.org>
 <20130402144037.GE5488@pd.tnic>
 <20130402150302.GF15687@8bytes.org>
 <20130402152956.GE4391@pd.tnic>
 <20130402160400.GP30540@8bytes.org>
 <20130402161757.GC17519@pd.tnic>
 <20130402163318.GS30540@8bytes.org>
 <20130402193240.GF17675@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402193240.GF17675@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 22:59:05 2013
X-DSPAM-Confidence: 0.9982
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515b469923673005197199
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 09:32:40PM +0200, Borislav Petkov wrote:
> On Tue, Apr 02, 2013 at 06:33:18PM +0200, Joerg Roedel wrote:

> > Okay, in theory I could implement a feedback loop between timer-setup
> > and intremap code and try fixups until it works. But that seems not to
> > be worth it to work around a buggy BIOS.
> 
> Yeah, same here. It's not like we really need intremap to work - we're
> only trying to fix the annoying error message currently. :-)

Right :)

> > What I actually thought about was providing an IVRS-override on the
> > kernel command line. So that you can specify the IOAPIC_ID->DEVID
> > mapping there and make it work this way. What do you think?
> 
> I guess that is workable. I can imagine people wanting this if they want
> to do the intremap thing on such b0rked BIOSen. So how do I specify this
> IOAPIC_ID->DEVID mapping on the cmdline exactly?


Don't know yet, probably something like ivrs_ioapic[<apicid>]=0:14.2 and
ivrs_hpet[<hpet-id>]=0:14.2. But not entierly sure yet, at least parsing
shouldn't require lex and yacc ;)

> > Yeah, that's my fear too. So we leave it better as it is...
> 
> Hohumm.

Thus shall it be!


	Joerg



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbbA0Uyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:54:49 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:34562 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbbA0Uyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:54:47 -0500
Date: Tue, 27 Jan 2015 12:54:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, wim@iguana.be,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, paul@crapouillou.net
Subject: Re: [PATCH 2/2] watchdog: jz4740: Add DT support
Message-ID: <20150127205430.GB6983@roeck-us.net>
References: <1422371490-44402-1-git-send-email-Zubair.Kakakhel@imgtec.com>
 <1422371490-44402-3-git-send-email-Zubair.Kakakhel@imgtec.com>
 <2690526.hgsE0j4AZc@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2690526.hgsE0j4AZc@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54C7FB16.0136,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 10
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 09:15:37PM +0100, Arnd Bergmann wrote:
> On Tuesday 27 January 2015 15:11:30 Zubair Lutfullah Kakakhel wrote:
> >  };
> >  
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id jz4740_of_matches[] = {
> > +       { .compatible = "ingenic,jz4740-watchdog", },
> > +       { /* sentinel */ }
> > +};
> > +#endif
> > +
> >  static int jz4740_wdt_probe(struct platform_device *pdev)
> >  {
> >         struct jz4740_wdt_drvdata *drvdata;
> > @@ -211,6 +219,7 @@ static struct platform_driver jz4740_wdt_driver = {
> >         .remove = jz4740_wdt_remove,
> >         .driver = {
> >                 .name = "jz4740-wdt",
> > +               .of_match_table = of_match_ptr(jz4740_of_matches),
> >         },
> > 
> 
> Why the #ifdef? Presumably we want to move over jz4740 to DT-only in the
> long run, so you could just remove the #ifdef and the of_match_ptr()
> wrapper.
> 
Only if "depends on OF" is added to its Kconfig entry, or am I missing
something ?

Guenter

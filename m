Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbbA1G06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:26:58 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:46970 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760873AbbA1G05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:26:57 -0500
Date: Tue, 27 Jan 2015 12:52:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, wim@iguana.be,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, paul@crapouillou.net
Subject: Re: [PATCH 1/2] dt: watchdog: Add DT binding documentation for
 jz47xx watchdog timer
Message-ID: <20150127205229.GA6983@roeck-us.net>
References: <1422371490-44402-1-git-send-email-Zubair.Kakakhel@imgtec.com>
 <1422371490-44402-2-git-send-email-Zubair.Kakakhel@imgtec.com>
 <11680810.808F8uDyN0@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11680810.808F8uDyN0@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A010204.54C88130.0063,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 1
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

On Tue, Jan 27, 2015 at 09:16:45PM +0100, Arnd Bergmann wrote:
> On Tuesday 27 January 2015 15:11:29 Zubair Lutfullah Kakakhel wrote:
> > +clocks: phandle to rtcclk
> > +clock-names: must be "rtc"
> > +
> > +Example:
> > +
> > +watchdog: jz47xx-watchdog@0x10002000 {
> > +       compatible = "ingenic,jz4780-watchdog";
> > +       reg = <0x10002000 0x100>;
> > +
> > +       clocks = <&rtclk>;
> > +       clock-names = "rtc";
> > +};
> 
> Why is the name "rtc"? are you sure you are not confusing the output
> name of the clock controller with the input of the watchdog device?
> 
Driver does this (today):

	 drvdata->rtc_clk = clk_get(&pdev->dev, "rtc");

Isn't that the name to use ? Just wondering.

Thanks,
Guenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaFFKbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:31:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38426 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaFFKa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:30:58 -0400
Date: Fri, 6 Jun 2014 12:30:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'Ulf Hansson'" <ulf.hansson@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: autosleep suspend too frquent problem
Message-ID: <20140606103056.GA2175@amd.pavel.ucw.cz>
References: <35FD53F367049845BC99AC72306C23D1029A27656A2D@CNBJMBX05.corpusers.net>
 <20140603120128.GA5080@amd.pavel.ucw.cz>
 <CAPDyKFqnC1u_Nhe7sJrAzBc8YktDUJC4KAKTPtYVK-Qk6mmk0A@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D1029A27656A38@CNBJMBX05.corpusers.net>
 <20140605135108.GA14162@amd.pavel.ucw.cz>
 <35FD53F367049845BC99AC72306C23D1029A27656A3E@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D1029A27656A3E@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-06-06 10:59:13, Wang, Yalin wrote:
> Hi  Pavel,
> 
> 
> This is kernel log from a Android phone:
> 
> <6>[ 7262.353794] PM: suspend exit 2014-05-07 21:19:17.438320072 UTC
> <6>[ 7262.353820] PM: suspend entry 2014-05-07 21:19:17.438348353 UTC
> <6>[ 7264.822367] PM: suspend exit 2014-05-07 21:19:19.906892259 UTC
> <6>[ 7264.822391] PM: suspend entry 2014-05-07 21:19:19.906919447 UTC
> <6>[ 7266.100346] PM: suspend exit 2014-05-07 21:19:21.184872206 UTC
> <6>[ 7266.100371] PM: suspend entry 2014-05-07 21:19:21.184899342 UTC
> <6>[ 7268.650852] PM: suspend exit 2014-05-07 21:19:23.735377778 UTC
> <6>[ 7268.650876] PM: suspend entry 2014-05-07 21:19:23.735404393 UTC
> <6>[ 7269.023665] PM: suspend exit 2014-05-07 21:19:26.398622725 UTC
> <6>[ 7269.023691] PM: suspend entry 2014-05-07 21:19:26.398651787 UTC
> <6>[ 7269.232675] PM: suspend exit 2014-05-07 21:19:28.959217201 UTC
> <6>[ 7269.250878] PM: suspend entry 2014-05-07 21:19:28.977414076 UTC
> <6>[ 7269.256004] PM: suspend exit 2014-05-07 21:19:28.982547202 UTC
> <6>[ 7269.260040] PM: suspend entry 2014-05-07 21:19:28.986580588 UTC
> <6>[ 7269.265169] PM: suspend exit 2014-05-07 21:19:28.991711785 UTC
> <6>[ 7269.269311] PM: suspend entry 2014-05-07 21:19:28.995851004 UTC
> <6>[ 7270.410962] PM: suspend exit 2014-05-07 21:19:30.137503920 UTC
> <6>[ 7270.410986] PM: suspend entry 2014-05-07 21:19:30.137529389 UTC
> <6>[ 7272.970123] PM: suspend exit 2014-05-07 21:19:32.696662461 UTC
> <6>[ 7272.973330] PM: suspend entry 2014-05-07 21:19:32.699869909 UTC
> <6>[ 7275.534527] PM: suspend exit 2014-05-07 21:19:35.261069387 UTC
> <6>[ 7275.534551] PM: suspend entry 2014-05-07 21:19:35.261095846 UTC
> <6>[ 7275.556227] PM: suspend exit 2014-05-07 21:19:35.282769491 UTC
> <6>[ 7275.579152] PM: suspend entry 2014-05-07 21:19:35.305686210 UTC
> <6>[ 7275.822618] PM: suspend exit 2014-05-07 21:19:37.918187092 UTC
> <6>[ 7275.822644] PM: suspend entry 2014-05-07 21:19:37.918215894 UTC
> <6>[ 7276.122721] PM: suspend exit 2014-05-07 21:19:40.479243344 UTC
> <6>[ 7276.122745] PM: suspend entry 2014-05-07 21:19:40.479269125 UTC
> <6>[ 7278.578212] PM: suspend exit 2014-05-07 21:19:42.934733395 UTC
> <6>[ 7278.578237] PM: suspend entry 2014-05-07 21:19:42.934761520 UTC
> 
> You can see there is several times suspend / resume status change 
> Form 2014-05-07 21:19:28. 959217201  to 2014-05-07 21:19:28.995851004
> 
> There is also some suspend fail in this log , the suspend return -EBUSY  
> Because of driver wake up system during suspend process .
> 
> During our power test , suspend frequently like this will consume more
> Power , because it will suspend/resume lots of
> Devices . Why don't we make a time window to make sure there is no more than
> 1 time suspend during the time window ?

If you can optimize power consumption on your hardware, by all means
go ahead. But arbitrary limit "don't suspend more than twice a second"
is probably not a way to go... not without some analysis.

You may want to take a look at n900 -- it uses regular idle, not
suspend, to save power. 

> I remember Android use wakelock for suspend in older linux kernel ,
> The wakelock will make some time window check to make sure
> Not suspend frequently ,  could autosleep also add this ?

Are you sure autosleep does not already have equivalent functionality?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

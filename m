Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaJ1KnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:43:16 -0400
Received: from mail-by2on0077.outbound.protection.outlook.com ([207.46.100.77]:14528
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752979AbaJ1KnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:43:12 -0400
Message-ID: <1414492984.2295.8.camel@leyfoon-vm>
Subject: Re: [PATCH v5 21/29] nios2: Time keeping
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Date: Tue, 28 Oct 2014 18:43:04 +0800
In-Reply-To: <1806277.3CF96bVORX@wuerfel>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
	 <alpine.DEB.2.11.1410252258570.5308@nanos>
	 <CAFiDJ5_zsyQ92W4iYG2Ria12TKpkFa8Au5noos1=gtq6_aPyjg@mail.gmail.com>
	 <1806277.3CF96bVORX@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(51704005)(189002)(199003)(24454002)(377454003)(377424004)(88136002)(6806004)(97736003)(33716001)(105596002)(20776003)(120916001)(47776003)(93886004)(77096002)(85306004)(107046002)(50466002)(92726001)(87936001)(21056001)(92566001)(103116003)(93916002)(31966008)(84676001)(85852003)(89996001)(99396003)(64706001)(86362001)(44976005)(68736004)(19580395003)(19580405001)(87286001)(23676002)(62966002)(50226001)(4396001)(102836001)(110136001)(50986999)(106466001)(76482002)(77156001)(42186005)(46102003)(95666004)(76176999)(80022003)(33646002)(104166001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB211;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB211;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sel, 2014-10-28 at 10:23 +0100, Arnd Bergmann wrote:
> On Tuesday 28 October 2014 10:46:29 Ley Foon Tan wrote:
> > On Sun, Oct 26, 2014 at 5:10 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Fri, 24 Oct 2014, Ley Foon Tan wrote:
> > >> +#ifndef _ASM_NIOS2_TIMEX_H
> > >> +#define _ASM_NIOS2_TIMEX_H
> > >> +
> > >> +typedef unsigned long cycles_t;
> > >> +
> > >> +extern cycles_t get_cycles(void);
> > >> +
> > >> +#define ARCH_HAS_READ_CURRENT_TIMER
> > >
> > > Why does NIOS need that? Does it have a hardware implementation
> > > dependent clock frequency which needs to be calibrated at boot time?
> > This is suggestion from Arnd to use read_current_timer instead of using
> > expensive delay loop calibration during boot.
> 
> My mistake, sorry. I think the right way is to define
> calibrate_delay_is_known() rather than read_current_timer(), I was
> getting confused by the ARM implementation that does both.
Hi Arnd,
No problem, I can change that. But, seem that we don't need to have
calibrate_delay_is_known() as well. We can just set "lpj_fine" variable,
arm64 uses this.

BTW, do you have further comment for other patches in this series? Only
few minor updates since v4 patches and would like to get it into the
v3.18 merge window if possible. What's your opinion? 

Thanks.

Regards
Ley Foon




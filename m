Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaKHAXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:23:09 -0500
Received: from mail-by2on0107.outbound.protection.outlook.com ([207.46.100.107]:43232
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752857AbaKHAXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:23:08 -0500
Message-ID: <1415406169.3805.48.camel@snotra.buserror.net>
Subject: Re: powerpc/8xx: Remove Kconfig symbol FADS
From: Scott Wood <scottwood@freescale.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Vitaly Bordug <vitb@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 7 Nov 2014 18:22:49 -0600
In-Reply-To: <1415350123.4390.43.camel@x220>
References: <1411545979.19525.5.camel@x220>
	 <20141107035008.GA25204@home.buserror.net> <1415350123.4390.43.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:39d9:e257:9f3c:9dae]
X-ClientProxiedBy: BLUPR08CA0054.namprd08.prod.outlook.com (10.141.200.34) To
 BN1PR0301MB0723.namprd03.prod.outlook.com (25.160.78.142)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0723;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(51704005)(377424004)(199003)(92726001)(20776003)(47776003)(23676002)(50466002)(46102003)(40100003)(50226001)(87976001)(86362001)(62966003)(64706001)(103116003)(106356001)(95666004)(97736003)(104166001)(77096003)(102836001)(76176999)(107046002)(110136001)(42186005)(120916001)(87286001)(101416001)(50986999)(33646002)(105586002)(122386002)(21056001)(89996001)(92566001)(31966008)(77156002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0723;H:[IPv6:2601:2:5800:3f7:39d9:e257:9f3c:9dae];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0689;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 09:48 +0100, Paul Bolle wrote:
> On Thu, 2014-11-06 at 21:50 -0600, Scott Wood wrote:
> > On Wed, Sep 24, 2014 at 10:06:19AM +0200, Paul Bolle wrote: 
> > > Another cleanup might be to remove MPC8XXFADS (or "FADS") from the "8xx
> > > Machine Type" choice. Is there any reason left to pick "FADS" as a
> > > machine type?
> > 
> > Nothing references MPC8XXFADS, so yes, it can be removed.
> 
> I'll try to look into this. For the (verbose) reasons below I'll do that
> in a separate patch, if I ever get that far. What follows is mostly a
> note to self.

Yes, make it a separate patch -- I've already got this patch queued up.

> MPC8XXFADS is indeed not referenced anywhere. But it's one of the
> entries in the "8xx Machine Type" choice. And it's common for choice
> blocks the have a "none of the above" entry. Ie, an entry that allows to
> configure nothing. There's a chance MPC8XXFADS is currently used for
> that role. (This is easier to determine for people that - unlike me -
> know what all the symbols in this choice mean. To me they 're basically
> random strings.)

It's not a "none of the above" option.  It's a board type that was
supported in arch/ppc, and only some remnants made it over to
arch/powerpc.  If you don't pick a machine type that results in a
define_machine() struct (with a probe function that matches the device
tree), the kernel will not boot.

-Scott



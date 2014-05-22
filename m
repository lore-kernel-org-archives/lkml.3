Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaEVPjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:39:14 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:21487
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751088AbaEVPjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:39:12 -0400
Date: Thu, 22 May 2014 08:36:58 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robherring2@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RFC] Migrate to Hz resolution for OPP binding
References: <672dd8e9-2857-49fb-848f-d38d38b23c9b@BN1BFFO11FD024.protection.gbl>
 <CAL_Jsq+1_W_d1WWkMUsHZYKXV=t9MN70iR25bnA8Emzh8zb2mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_Jsq+1_W_d1WWkMUsHZYKXV=t9MN70iR25bnA8Emzh8zb2mg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <7a3a47bd-db95-4255-8507-e6494607ea69@BL2FFO11FD018.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(377424004)(24454002)(51704005)(199002)(189002)(164054003)(377454003)(47776003)(79102001)(76176999)(50986999)(50466002)(76482001)(1411001)(20776003)(54356999)(64706001)(15975445006)(4396001)(83506001)(99396002)(21056001)(31696002)(102836001)(85852003)(83072002)(85182001)(85202002)(86362001)(92726001)(33646001)(87936001)(92566001)(77982001)(74316001)(53416003)(19580395003)(19580405001)(83322001)(44976005)(81342001)(74502001)(74662001)(31966008)(23676002)(46102001)(81542001)(80022001)(70736001)(23106003);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB067;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 021975AE46
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Thu, 2014-05-22 at 08:27AM -0500, Rob Herring wrote:
> On Tue, May 20, 2014 at 5:30 PM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > Hi,
> >
> > I guess this is just to evaluate how big the lynch mob will be. Anyway:
> > Triggered by this discussion https://lkml.org/lkml/2014/5/15/46, I
> > looked a little into what it would take to migrate everybody to Hz
> > frequency resolutions to avoid all the conversions between cpufreq, CCF,
> > OPPs, etc.
> > Turns out, OPPs are already stored in Hz resolution in the kernel, but the DT
> > bindings use kHz resolution to specify them in DT. So, code-wise there
> > is just a removal of a multiplication in the OPP parser (see below), but
> > then there are the DT bindings...
> 
> Add this to the list of issues with the current OPP binding and define
> a new binding, not a band-aid.
> 
> > As plan B, I was thinking to add the property 'operating-points-hz'...
> >
> > Any better ideas?
> 
> Fix clk_round_rate to specify how you want to round. There are
> usecases for both rounding up and down. Don't you have the same
> rounding problem with hz? Assume the person filling in OPP values
> knows nothing about the kernel and you could have values rounded both
> ways.

Yes the issue would not be resolved by this alone. But currently the CCF
and OPPs in the kernel use Hz. And if you look at the interaction
between those frameworks with cpufreq, there are plenty of
multiplications/divisions by 1000 to convert between those, with even a
greater loss of accuracy. So, I think agreeing on using Hz as smallest
reasonable frequency resolution across all these frameworks would be a
first step into the right direction.

	Thanks,
	Sören

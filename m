Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964AbaGVV4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:56:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54122 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751272AbaGVV4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:56:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [RFC PATCH v3 00/14] ACPI/EC: Add event storm prevention and cleanup command storm prevention.
Date: Wed, 23 Jul 2014 00:15:10 +0200
Message-ID: <1600083.bSeASC3AGv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802643E0D@SHSMSX101.ccr.corp.intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <9698076.0kdZ11M3j2@vostro.rjw.lan> <1AE640813FDE7649BE1B193DEA596E8802643E0D@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 22, 2014 01:25:00 AM Zheng, Lv wrote:
> Hi, Rafael
> 
> > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > Sent: Tuesday, July 22, 2014 9:12 AM
> > 
> > On Monday, July 21, 2014 02:04:51 PM Lv Zheng wrote:
> > > Note that this patchset is very stable now, it is sent as RFC because it
> > > depends on an ACPICA GPE enhancement series which might be merged from
> > > ACPICA upstream.
> > 
> > Do I remember correctly that this is the plan?
> > 
> > So I'm expecting to receive the Linux versions of the relevant ACPICA changes
> > from you and then I'll apply this material on top of them.
> > 
> > We don't need to wait for the next ACPICA release with this I think, but
> > I'd like the GPE changes to be applied to upstream ACPICA at least before
> > I get them.
> 
> Yes, I'm trying.
> I'll re-send this series after an ACPICA release cycle that contains the dependent GPE series.
> 
> Let me highlight the real value of this EC series:
> This is a good IO driver material to demonstrate:
> 1. runtime idle: this is not implemented yet because of ACPICA issues that are not root caused, let me show this possibility this below.
> 2. storming safe: can also deal with all kinds of silicon without worrying about IRQ storming.
> 
> On top of this, after
> 1. making sure that acpi_evaluate_object(_Qxx) won't be a blocking point, and extending the referenced period to the end of the evaluation,
> 2. adding 1 more patch to the ACPICA series, using a flag to bypass the automatic GPE disabling/enabling,
> 3. adding 1 more patch to make EC event poller  to disable GPE when sleeping,
> Linux EC driver can run without GPE enabled when idle.
> Which means GPE is enabled only when:
> 1. there is an EC command issued from the EC space handler or
> 2. the event poller thread is timed out or woken up by the EVT_SCI.
> 
> So I hope this IO driver enhancement can be a good material to show such possibility.

Yes, it is a good patchset, but I'd like to merge it in an ordered way.
That is, ACPICA upstream first, patches for Linux from that, the EC series on
top of this.  OK?

Rafael


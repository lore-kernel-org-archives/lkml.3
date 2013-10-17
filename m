Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3JQNfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:35:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63478 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755421Ab3JQNfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:35:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH] ACPI / power: Drop automaitc resume of power resource dependent devices
Date: Thu, 17 Oct 2013 15:47 +0200
Message-ID: <2220996.Balj6KfZAP@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <3517410.N1Ot4TpM2j@vostro.rjw.lan>
References: <4814451.BPLed2xxbP@vostro.rjw.lan> <525F8A48.9020007@intel.com> <3517410.N1Ot4TpM2j@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 17, 2013 01:56:23 PM Rafael J. Wysocki wrote:
> On Thursday, October 17, 2013 02:57:12 PM Aaron Lu wrote:
> > On 10/16/2013 09:25 PM, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > The mechanism causing devices depending on a given power resource
> > > (that is, devices that can be in D0 only if that power resource is
> > > on) to be resumed automatically when the power resource is turned
> > > on (and their "inferred" power state becomes D0 as a result) is
> > > inherently racy and in fact unnecessary.
> > > 
> > > It is racy, because if the power resources is turned on and then
> > > immediately off, the device resume triggered by the first transition
> > > to "on" may still happen, causing the power resource to be turned
> > > on again.  That again will trigger the "resume of dependent devices"
> > > mechanism, but if the devices in question are not in use, they will
> > > be suspended in the meantime causing the power resource to be turned
> > > off.  However, the "resume of dependent devices" will next resume
> > > them again and so on.  In some cases (USB port PM in particular) that
> > > leads to an endless busy loop of flipping the resource on and off
> > > continuously.
> > > 
> > > It is needless, because whoever turns a power resource on will most
> > > likely turn it off at some point and the devices that go into "D0"
> > > as a result of turning it on will then go back into D3cold.
> > > Moreover, turning all power resources a device needs to go into
> > > D0 is not sufficient for a full transition into D0 in general.
> > > Namely, _PS0 may need to be executed in addition to that in some
> > > cases.  This means that the whole rationale of the "resume of
> > > dependent devices" mechanism was incorrect to begin with and it's
> > > best to remove it entirely.
> > 
> > With this patch, your previous patch could also be applied now:
> > https://lkml.org/lkml/2013/6/14/173
> > [PATCH 4/4] ACPI / PM: Drop two functions that are not used any more
> 
> Good catch and that code is dead anyway AFAICS, because power_dependent is only
> used in device_pm.c (in those two functions) and in scan.c (where it is
> initialized).

That obviously is with the $subject patch applied.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

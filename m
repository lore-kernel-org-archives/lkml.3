Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3CORGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:06:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52342 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab3CORGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:06:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: Regression: Fixing recursive fault but reboot is needed at boot on HP 6730B - bisected
Date: Fri, 15 Mar 2013 18:13:21 +0100
Message-ID: <2481455.MbROdCkzQM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51431DC0.1090603@infracom.it>
References: <513D8F3A.8030308@gmail.com> <5142ED1A.1040500@infracom.it> <51431DC0.1090603@infracom.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 15, 2013 02:10:24 PM Roberto Oppedisano wrote:
> Hi!
> 
> Il 15/03/2013 10:42, Roberto Oppedisano ha scritto:
> > Il 14/03/2013 18:27, Rafael J. Wysocki ha scritto:
> >> On Thursday, March 14, 2013 09:20:51 AM Roberto Oppedisano wrote:
> >> As Toshi said, this particular commit doesn't make any functional 
> >> changes. Can you please verify if the immediately preceding commit 
> >> 6af9a803f4d2e4137d9f74a8fc9af4857fbda001 works for you? Rafael 
> >
> > I have checked out this commit and it is NOT working.
> >
> > BTW I did find the same commit in my bisection log, and probably
> > it was a false negative (I tried a couple of boot for each working kernel
> > during bisectrion, probably it was not not enough).
> > I'm going to replay the bisection today; will report back ASAP, to see
> > if it ends in something which makes sense to you. 
> 
> Here's the new suspect:
> 
> f95988de06ea62ef5bd861f06e9ef56cea405ed1 is the first bad commit
> commit f95988de06ea62ef5bd861f06e9ef56cea405ed1
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Mon Jan 7 21:17:02 2013 +0100
> 
>      ACPI / scan: Treat power resources in a special way

In that case, please try to comment out the following two lines:

	device_set_wakeup_capable(dev, true);
	acpi_pci_sleep_wake(pci_dev, false);

in pci_acpi_setup() in drivers/pci/pci-acpi.c and see if that improves things
for you.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

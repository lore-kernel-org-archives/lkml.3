Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3LJG6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:58:50 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:31093 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3LJG6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:58:48 -0500
X-IronPort-AV: E=Sophos;i="4.93,864,1378882800"; 
   d="scan'208";a="1426460"
Subject: Re: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset
 120 to 0
From: Michael Chan <mchan@broadcom.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Natarajan Gurumoorthy <natg@google.com>, <nsujir@broadcom.com>,
        <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1386623253.1752.6.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <1386614601-9453-1-git-send-email-natg@google.com>
	 <1386615608.1752.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	 <CAGmqidkxoi9EEe0uC18QQUXwjFP1e_1MXL7VPk+NtU-Ta6FGUg@mail.gmail.com>
	 <52A633B4.9000307@cogentembedded.com>
	 <1386623253.1752.6.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
Content-Type: text/plain; charset="cp1252"
Date: Mon, 9 Dec 2013 22:58:44 -0800
Message-ID: <1386658724.1752.19.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 13:07 -0800, Michael Chan wrote: 
> On Tue, 2013-12-10 at 00:18 +0300, Sergei Shtylyov wrote: 
> > >        We had crashes when the PCI config space got scanned via
> > > /sys/devices/pcixxxx/....../config.
> > 
> > > I agree that this fix will not help if the scan happens before the tg3
> > > driver gets loaded.
> > 
> >     Then perhaps a better place for such fixup would be a PCI quirk?
> > 
> Yes, I agree.  Thanks.
> 

On second thought, I think your original patch should be sufficient and
we don't need to add the PCI quirk to cover so many devices.  The reason
is that indirect access needs to be explicitly enabled in the
MISC_HOST_CTRL (0x68) register.  The default value for register 0x68
should have indirect access disabled.

Nat, does this match what you're seeing?  Did you ever see any system
crash before tg3 loads?


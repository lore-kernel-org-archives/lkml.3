Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab3ETRVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:21:43 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:58652 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3ETRVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:21:41 -0400
MIME-Version: 1.0
In-Reply-To: <5683193.Vsmy0DmceS@vostro.rjw.lan>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <CAErSpo7+AbHi_TwxwHTJunpFb=CMhwMdCni6+NjbhdA=35XhvA@mail.gmail.com> <5683193.Vsmy0DmceS@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 20 May 2013 11:21:17 -0600
Message-ID: <CAErSpo7TvCfQLkMD+zL1W6dNEqMpHYbLtAAHqXf==zbxhE2tcQ@mail.gmail.com>
Subject: Re: Subject : [ PATCH ] pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Zhang, LongX" <longx.zhang@intel.com>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
        "Joseph.Liu@Emulex.Com" <Joseph.Liu@emulex.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 5:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, May 17, 2013 05:43:33 PM Bjorn Helgaas wrote:
>> On Fri, Apr 26, 2013 at 12:28 AM, Zhang, LongX <longx.zhang@intel.com> wrote:

>> > +       /* restore cfg space for possible link reset at upstream */
>> > +       dev->state_saved = true;
>>
>> "dev->state_saved == true" means that the dev->saved_config_space
>> contains valid data.  Why do we know that's the case here?  I see that
>> pcie_portdrv_probe() calls pci_save_state() when we first claim the
>> port, and I guess we're assuming the state saved then is still valid.
>> But why do we need to actually set dev->state_saved here?  Shouldn't
>> it be already set to true anyway?
>
> This is a dirty trick to make pci_restore_state(dev) always work here
> (because it checks dev->state_saved and does nothing if it isn't set).
> I suppose.

Yes, I did investigate enough to see that this is a dirty trick.  My
question is how we know it's safe to do this dirty trick.

>> > +       pci_restore_state(dev);
>> > +       pcie_portdrv_restore_config(dev);
>> > +       pci_enable_pcie_error_reporting(dev);

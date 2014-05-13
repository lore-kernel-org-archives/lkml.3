Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbaEMPMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:12:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42630 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965097AbaEMPM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:12:29 -0400
Date: Tue, 13 May 2014 11:12:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming
 runtime-suspended devices unnecessarily
In-Reply-To: <3343255.BLfH04PmOm@vostro.rjw.lan>
Message-ID: <Pine.LNX.4.44L0.1405131110480.1098-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Rafael J. Wysocki wrote:

> > > +	dev->power.direct_complete = ret > 0 && state.event == PM_EVENT_SUSPEND
> > > +					&& pm_runtime_suspended(dev);
> > 
> > Shouldn't the flag be set under the spinlock?
> 
> I guess you're worried about runtime PM flags being modified in parallel to
> this?  But we've just done the barrier a while ago, so is that still a concern
> here?

A wakeup request from the hardware could cause a runtime resume to 
occur at this time.  The barrier wouldn't prevent that.

It's unlikely, I agree, but not impossible.

Alan Stern


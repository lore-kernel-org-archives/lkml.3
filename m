Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3FBVq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 17:46:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56974 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab3FBVpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 17:45:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 0/2] PM / Runtime: Rework the "runtime idle" helper routine (was: Re: [PATCH RFC] PM / Runtime: Rework the "runtime idle" helper routine)
Date: Sun, 02 Jun 2013 23:50:46 +0200
Message-ID: <2033252.LiVeuYIhnT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1305301247370.1137-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1305301247370.1137-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 30, 2013 01:08:08 PM Alan Stern wrote:
> On Thu, 30 May 2013, Rafael J. Wysocki wrote:
> 
> > > Since you're making this change, wouldn't it be a good idea to adopt
> > > Mika's original suggestion and turn on the RPM_AUTO bit in rpmflags
> > > when the use_autosuspend flag is set?
> > 
> > I'm not actually sure.  It can be done, but I'd prefer to do that as a separate
> > change in any case.
> 
> That makes sense.
> 
> > > What about cases where the runtime-idle callback does
> > > rpm_schedule_suspend or rpm_request_suspend?  You'd have to make sure
> > > that it returns -EBUSY in such cases.  Did you audit for this?
> > 
> > As far as I could.
> > 
> > I'm not worried about the subsystems modified by this patch, because the
> > functionality there won't change (except for PCI, that is).
> 
> Right.  The subsystems that _aren't_ modified are the ones to worry 
> about -- like the USB callback.  They are the ones where the behavior 
> might change.

OK, this time I think I've caught all of them. :-)

I've retained the ACKs and Reviewed-by tags in [1/2], because it only makes
more changes in addition to the previously ACKed ones.  The PCI changeset
has been updated and [2/2] is the documentation update.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

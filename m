Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaEILQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:16:25 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61218 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754241AbaEILQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:16:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of runtime-suspended devices
Date: Fri, 09 May 2014 13:33:02 +0200
Message-ID: <5011531.ltexPOCSJ9@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAPDyKFo7zODwqHxzTuLcnF5sOXNRh5-VHvRdOidBnkPs+airDg@mail.gmail.com>
References: <Pine.LNX.4.44L0.1405081718200.995-100000@iolanthe.rowland.org> <3786444.hNhCASz73P@vostro.rjw.lan> <CAPDyKFo7zODwqHxzTuLcnF5sOXNRh5-VHvRdOidBnkPs+airDg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 09, 2014 09:23:50 AM Ulf Hansson wrote:
> Hi Rafael,
> 
> > @@ -1485,3 +1486,10 @@ out:
> >         return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(pm_runtime_force_resume);
> > +
> > +void pm_set_direct_resume(struct device *dev, bool val)
> > +{
> > +       spin_lock_irq(&dev->power.lock);
> > +       __set_direct_resume(dev, val);
> > +       spin_unlock_irq(&dev->power.lock);
> > +}
> 
> I believe you have to move the implementation of this function inside
> #ifdef CONFIG_PM_RUNTIME.

You're right, I forgot about the recent change in there.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

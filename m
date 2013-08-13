Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab3HMOyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:54:10 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:41715 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892Ab3HMOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:54:08 -0400
Message-ID: <1376405572.10300.385.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/2] Protect cpu map updates from ACPI processor
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com
Date: Tue, 13 Aug 2013 08:52:52 -0600
In-Reply-To: <1497141.gLtk1PtyFs@vostro.rjw.lan>
References: <1376322354-13026-1-git-send-email-toshi.kani@hp.com>
	 <2206062.QmFJav0XuL@vostro.rjw.lan>
	 <1376355303.10300.376.camel@misato.fc.hp.com>
	 <1497141.gLtk1PtyFs@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 13:47 +0200, Rafael J. Wysocki wrote:
> On Monday, August 12, 2013 06:55:03 PM Toshi Kani wrote:
> > On Tue, 2013-08-13 at 02:43 +0200, Rafael J. Wysocki wrote:
> > > On Monday, August 12, 2013 09:45:52 AM Toshi Kani wrote:
> > > > CPU system maps are protected with reader/writer locks.  The reader
> > > > lock, put_online_cpus(), assures that the maps are not updated while
> > > > holding the lock.  The writer lock, cpu_hotplug_begin(), is used to
> > > > udpate the cpu maps along with cpu_maps_update_begin().
> > > > 
> > > > However, the ACPI processor handler updates the cpu maps without
> > > > holding the the writer lock.  This patchset fixes this problem.
> > > > 
> > > > ---
> > > > The patchset is based on linux-next of the pm tree.
> > > 
> > > Basically looks OK to me, but I'd just merge the patches together,
> > > because the [2/2] is the very reason for the change made by [1/2].
> > 
> > I separated for reviewing purpose, but yes, they can be together.  Let
> > me know if you need me to re-send it together.
> 
> I combined them and added a changelog built out of the messages you sent in
> this thread.  Please check:
> 
> http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/?h=bleeding-edge&id=b9d10be7a8e88fdcb12540387c219cdde87b0795
> 

Looks good!
Thanks,
-Toshi


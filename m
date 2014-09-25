Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaIYGHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:07:53 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58405 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIYGHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:07:51 -0400
Date: Thu, 25 Sep 2014 07:07:45 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Thomas Shao <huishao@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH] Drivers: hv: util: Implement Time Synchronization using
 host time sample
Message-ID: <20140925060745.GA9450@sucs.org>
References: <1411451081-13423-1-git-send-email-huishao@microsoft.com>
 <20140923075610.GA10933@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923075610.GA10933@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 09:56:10AM +0200, Olaf Hering wrote:
> On Tue, Sep 23, Thomas Shao wrote:
> 
> > In current hyper-v time sync service,it only gets the initial clock time
> > from the host. It didn't process the following time samples. This change
> > introduced a module parameter called host_time_sync. If it is set to true,
> > the guest will periodically sychronize it's time with the host clock using
> > host time sample. By default it is disabled, because we still recommend
> > user to configure NTP for time synchronization.

You [Microsoft?] do? Can you link to public sources where is this stated
please? I don't see any mention of doing this on
http://technet.microsoft.com/en-us/library/dn720239.aspx .. The only
official Microsoft information with respect to Hyper-V guest time
synchronisation I've seen has been for Windows guests but perhaps I've
looked in the wrong places.

The reason I ask is because regular ntpd is not enough to discipline a
Linux Hyper-V guest's clock. So much drift can occur under load that
ntpd can't bring the clock under sync. For now, I've been using Chrony
which has a higher tolerance for correcting drifting clocks. I'm not the
only one seeing this either (see http://serverfault.com/a/488528/203726
and
http://serverfault.com/questions/523389/linux-clock-loses-10-minutes-every-week
).

It would be good to something official about this issue as it is painful
when happens.

-- 
Sitsofe | http://sucs.org/~sits/

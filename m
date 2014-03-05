Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbaCEEii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:38:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbaCEEih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:38:37 -0500
Date: Tue, 4 Mar 2014 20:38:58 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roland Dreier <roland@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, shli@kernel.org
Subject: Re: [PATCH] Revert "driver core: synchronize device shutdown"
Message-ID: <20140305043858.GA2494@kroah.com>
References: <1393991871-1743-1-git-send-email-roland@kernel.org>
 <20140305040929.GA31130@kroah.com>
 <CAG4TOxONSsyokdy9Sw+fT21QA7E-uY572ZDoNf3V9f7D1ytyxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG4TOxONSsyokdy9Sw+fT21QA7E-uY572ZDoNf3V9f7D1ytyxQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 08:15:36PM -0800, Roland Dreier wrote:
> > Hm, no one seems to have said anything for the past 5 years about this.
> 
> It definitely is hard to hit -- you have to do "shutdown" or "reboot"
> right as something schedules async work.  In our case we have some
> systems with a large and slightly flaky SAS fabric, so there's a
> constant level of re-probing SCSI disks, and we occasionally see
> reboots hanging due to waiting for never-finishing sd probe async
> work.
> 
> AFAICT the synchronization does nothing useful and is just a remnant
> of a patch series where the real meat didn't get applied.  But of
> course it would be great if Shaohua could confirm my understanding.

Shaohua's email address seems to now bounce :(

Arjan, any thoughts?

greg k-h

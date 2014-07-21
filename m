Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbaGUNiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:38:05 -0400
Received: from 8bytes.org ([81.169.241.247]:51209 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbaGUNiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:38:03 -0400
Date: Mon, 21 Jul 2014 15:38:00 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721133800.GM30979@8bytes.org>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721120053.GA14069@amd.pavel.ucw.cz>
 <20140721123613.GL30979@8bytes.org>
 <20140721130629.GA15122@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721130629.GA15122@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 21, 2014 at 03:06:29PM +0200, Pavel Machek wrote:
> > That would just cover the problem that the bitmap data structure and the
> > algorithm in swsusp_free do not scale well on bigmem machines.
> 
> And is it a problem? Hibernation of 12TB machine will take 6 hours if
> you back your swap with SSDs.
> 
> Does not scale == burns additional 60 seconds of CPU time. I think we
> can live with that...

Problem is that these 76s are burned every time, whether you just use
500MB or the full 12TB of the machine.

Next problem is that the bitmaps are allocated (and need to be freed)
without even being sure that a resume will happen.

So when you boot the kernel with 'resume=/dev/something' on the cmdline
it will always take these 76s just for allocating and freeing the
bitmaps for nothing on such a machine.

> ...because noone sane will hibernate 12TB machine.

And Linux is only made for sane people? Thats pretty new to me ;-)

> Yes, that's why I propose to apply just patch 6 -- to avoid soft
> lockup warnings.

Only patch 6 would wrap the problem with the soft lockups, but the other
patches actually improve the resume and boot situation on those
machines.


	Joerg


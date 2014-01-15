Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaAOQq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:46:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbaAOQqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:46:25 -0500
Date: Wed, 15 Jan 2014 11:46:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Young <dyoung@redhat.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, wim@iguana.be,
        dzickus@redhat.com, bhe@redhat.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: add a parameter for stop wdt before register
Message-ID: <20140115164609.GC3180@redhat.com>
References: <20140114082323.GA4485@dhcp-16-126.nay.redhat.com>
 <20140114121639.77fe75ec@alan.etchedpixels.co.uk>
 <20140114162405.GG3096@redhat.com>
 <20140115011142.GC23767@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115011142.GC23767@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 09:11:42AM +0800, Dave Young wrote:

[..]
> > I thought this problem was resolved (atleast conceptually) last time
> > when Don Zickus brought it up.
> > 
> > He mentioned that it was concluded that keep watchdog interval long
> > enough, say 60 seconds and keep on kicking it fast enough, say every
> > 10-20 seconds. That would ensure that after the crash, there is atleast
> > 60 - 20 = 40 seconds left before watchdog expires. And in that duration
> > we should try to boot into second kernel load watchdog driver early enough
> > from initramfs which can start kicking watchdog again.
> 
> Some drivers did stop the watchdog while module loading such as iTCO_wdt.

Instead of stopping why not keep on kicking it till user space takes
over this job. This will also make sure that if kdump kernel hangs,
watchdog wil do the job it is supposed to do?

Thanks
Vivek

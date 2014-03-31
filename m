Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaCaKny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:43:54 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:42701 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751961AbaCaKnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:43:53 -0400
Date: Mon, 31 Mar 2014 12:43:51 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Sasha Levin <sasha.levin@oracle.com>, Tejun Heo <tj@kernel.org>,
        Greg KH <greg@kroah.com>, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
Message-ID: <20140331124351.43033c93@linux.lan.towertech.it>
In-Reply-To: <53393AE4.505@metafoo.de>
References: <5308E3AE.3040405@oracle.com>
	<20140222205217.GC16272@mtj.dyndns.org>
	<20140224120427.6394d5dd@linux.lan.towertech.it>
	<5331FA9E.20506@oracle.com>
	<20140325233936.655a798e@linux.lan.towertech.it>
	<53321D04.2040102@oracle.com>
	<5337653D.6020002@oracle.com>
	<53384080.9020502@oracle.com>
	<20140331114627.5e1a4609@linux.lan.towertech.it>
	<53393AE4.505@metafoo.de>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 11:52:36 +0200
Lars-Peter Clausen <lars@metafoo.de> wrote:

> It's the same bug, device_unregister(&rtc->dev) will try to unregister all 
> sysfs files attached to the device and that function is still called with 
> the rtc mutex held.

 rtc-cmos tries to unregister the rtc device in the probe function,
 which should not be done. 

 the last patches fixes it. I'll keep trying to trigger the bug on my systems.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it


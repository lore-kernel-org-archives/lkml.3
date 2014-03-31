Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaCaMDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:03:48 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:43194 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbaCaMDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:03:47 -0400
Date: Mon, 31 Mar 2014 14:03:44 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Sasha Levin <sasha.levin@oracle.com>, Tejun Heo <tj@kernel.org>,
        Greg KH <greg@kroah.com>, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
Message-ID: <20140331140344.6030c7da@linux.lan.towertech.it>
In-Reply-To: <53394C5E.2030207@metafoo.de>
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
	<20140331124351.43033c93@linux.lan.towertech.it>
	<53394C5E.2030207@metafoo.de>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 13:07:10 +0200
Lars-Peter Clausen <lars@metafoo.de> wrote:

> It doesn't really matter where it is unregistered. device_unregister() will 
> (somewhere down it's callchain) take the kernfs lock, hence it must be 
> callled with the rtc mutex being held.

 Maybe device_remove_attrs could be called in the rtc base class,
 before the device removal?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it


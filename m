Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3H2CFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:05:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18184 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab3H2CFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:05:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,979,1367942400"; 
   d="scan'208";a="8338258"
Message-ID: <521EAB47.4060101@cn.fujitsu.com>
Date: Thu, 29 Aug 2013 10:00:39 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH 0/2] driver core / ACPI: Avoid device removal locking
 problems
References: <1543475.L7gSB7lLAu@vostro.rjw.lan> <20130828122422.GA18348@mtj.dyndns.org> <1592448.YZbpON5n7n@vostro.rjw.lan> <26495758.n1zOCiG3iV@vostro.rjw.lan>
In-Reply-To: <26495758.n1zOCiG3iV@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/29 10:02:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/29 10:03:01,
	Serialize complete at 2013/08/29 10:03:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 08/28/2013 09:45 PM, Rafael J. Wysocki wrote:

> Hi All,
> 
> The following two patches are to address possible deadlocks related to
> device removal and device sysfs attribute access.  In short, some device
> sysfs attribute callbacks need to acquire locks that are also held around
> device removal and that may lead to deadlocks with s_active draining in
> sysfs_deactivate().
> 
> [1/2] Avoid possible device removal deadlocks related to device_hotplug_lock.
> [2/2] Rework the handling of containers by ACPI hotplug (which makes a possible
>       device removal deadlock related to acpi_scan_lock go away).
> 

This version is concise and friendly. It works well on latest kernel tree, and all
the splat goes away.:)

Best regards,
Gu

> On top of linux-next, for v3.12.

> 
> Thanks,
> Rafael
> 
> 



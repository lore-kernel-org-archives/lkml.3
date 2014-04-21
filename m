Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaDUWiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 18:38:11 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:57779 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbaDUWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 18:38:08 -0400
Date: Mon, 21 Apr 2014 18:38:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 1/2] Use lock_device_hotplug() in
 cpu_probe_store() and cpu_release_store()
Message-ID: <20140421223804.GD22730@htj.dyndns.org>
References: <20140411102649.GB26252@mtj.dyndns.org>
 <1397461649.12943.1.camel@ThinkPad-T5421.cn.ibm.com>
 <20140414201315.GD16835@htj.dyndns.org>
 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
 <20140415145017.GK1863@htj.dyndns.org>
 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
 <20140416151749.GE1257@htj.dyndns.org>
 <1397717444.4034.15.camel@ThinkPad-T5421>
 <20140417151728.GK15326@htj.dyndns.org>
 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 21, 2014 at 05:20:59PM +0800, Li Zhong wrote:
> While auditing the usage of lock_device_hotplug_sysfs() for implementing
> it in another way in following patch, it seems to me that the code here
> is to add/remove device, and the files probe/release for cpu bus
> themselves won't be removed. 
> 
> So it seems to me there is no s_active related deadlock here, and we
> could just use lock_device_hotplug().

It may still cause issue if offlining ends up removing sysfs files or
gets involved with the same lock used during cpu hot[un]plug
operations (e.g. offlining racing against cpu hotunplug) and offlining
a cpu does remove files.  Has this change been tested?

Thanks.

-- 
tejun

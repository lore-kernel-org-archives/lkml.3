Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaDXIhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:37:37 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:58337 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaDXIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:37:34 -0400
Message-ID: <1398328643.2805.102.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH v5 1/2] Use lock_device_hotplug() in
 cpu_probe_store() and cpu_release_store()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Date: Thu, 24 Apr 2014 16:37:23 +0800
In-Reply-To: <20140423143940.GD4781@htj.dyndns.org>
References: <20140415145017.GK1863@htj.dyndns.org>
	 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140416151749.GE1257@htj.dyndns.org>
	 <1397717444.4034.15.camel@ThinkPad-T5421>
	 <20140417151728.GK15326@htj.dyndns.org>
	 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140421223804.GD22730@htj.dyndns.org>
	 <1398133777.2805.7.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140422204006.GA3615@mtj.dyndns.org>
	 <1398218426.2805.42.camel@ThinkPad-T5421.cn.ibm.com>
	 <20140423143940.GD4781@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042408-0342-0000-0000-0000088A3867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 10:39 -0400, Tejun Heo wrote:
> On Wed, Apr 23, 2014 at 10:00:26AM +0800, Li Zhong wrote:
> > If you remove cpu0, then the cpu0 directory will be removed, together
> > with the "online" file in the directory, while some other process might
> > be writing 0 or 1 to it.
> > 
> > But here, for the probe/release, take "release" for example, if user
> > writes something that stands for cpu0 to it, the cpu0 will be removed, 
> > and the cpu0 directory and the files under it will be removed. But
> > "release" itself is not removed.
> > 
> > They are attributes of cpu_subsys, not of some specific cpus.
> 
> OIC, so the file itself which triggers removal doesn't get removed.
> Hmmm... but can't you still fall into deadlock?  If on/offline takes
> the same lock under active protection which is also taken while
> removing the cpu files, it doesn't really matter whether the release
> file itself is removed in the process or not.  You can still have ABBA
> deadlock.  What am I missing here?

After thinking it harder, I still couldn't see ABBA here ... 

the active protection taken here is for "probe/release" which will not
be waited for removing something like "online" under cpu#? Or my
assumption that s_active for different files are different locks are
completely wrong? Or I missed something else? 

Thanks, Zhong
> 
> Thanks.
> 



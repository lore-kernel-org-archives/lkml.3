Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaEBPUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:20:48 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:45221 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaEBPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:20:46 -0400
Date: Fri, 2 May 2014 11:20:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
Subject: Re: [PATCH] USB: serial: fix sysfs-attribute removal deadlock
Message-ID: <20140502152042.GD10204@htj.dyndns.org>
References: <1398245539-1618-1-git-send-email-jhovold@gmail.com>
 <20140423141908.GA4781@htj.dyndns.org>
 <1398328155.2805.100.camel@ThinkPad-T5421.cn.ibm.com>
 <20140424143517.GC14460@htj.dyndns.org>
 <20140424145206.GB2206@localhost>
 <1398392217.2805.150.camel@ThinkPad-T5421.cn.ibm.com>
 <20140425101501.GD2206@localhost>
 <1398645587.3046.19.camel@ThinkPad-T5421>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398645587.3046.19.camel@ThinkPad-T5421>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 08:39:47AM +0800, Li Zhong wrote:
> Yes, maybe try to get the module reference is not bad before writing to
> driver attributes, as it doesn't make much sense to really call the
> callbacks for the driver attribute if the driver is being unload.

Please don't do that spuriously.  Active protection is the primary
mechanism for that sort of protection and adding spurious things just
make them confusing.

> And after we get the reference, it is safe for us to break the active.
> But if we don't have such real cases(lockdep warnings), we actually
> don't need to break it. 

Yeah, for cases where active protection should be broken, other
measures should be taken to prevent the underlying data structure /
code from going away.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbaFZDg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 23:36:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaFZDg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 23:36:26 -0400
Date: Wed, 25 Jun 2014 23:36:08 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH] video: hyperv: hyperv_fb: refresh the VM screen by force
 on VM panic
Message-ID: <20140626033608.GA32654@kroah.com>
References: <1403569757-2622-1-git-send-email-decui@microsoft.com>
 <20140624135101.GB10115@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C98353C6@SINEX14MBXC418.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C98353C6@SINEX14MBXC418.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 09:44:14PM +0000, Dexuan Cui wrote:
> >On Tue, Jun 24, 2014 at 08:29:17AM +0800, Dexuan Cui wrote:
> >> Currently the VSC has no chance to notify the VSP of the dirty rectangle on VM
> >> panic because the notification work is done in a workqueue, and in panic() the
> >> kernel typically ends up in an infinite loop, and a typical kernel config has
> >> CONFIG_PREEMPT_VOLUNTARY=y and CONFIG_PREEMPT is not set, so a context switch
> >> can't happen in panic() and the workqueue won't have a chance to run. As a
> >> result, the VM Connection window can't refresh until it's closed and we
> >> re-connect to the VM.
> >> 
> >> We can register a handler on panic_notifier_list: the handler can notify
> >> the VSC and switch the framebuffer driver to a "synchronous mode", meaning
> >> the VSC flushes any future framebuffer change to the VSP immediately.
> >> 
> >> MS-TFS: 157532
> 
> > What is this line for?
> 
> Hi Greg,
> This line is for our internal bug repository.
> We have an automated system to correlate bugs with fixes so that our test
> team knows when a bug fix has been accepted upstream and they need to
> write a new test case for it. 
> 
> The MS-TFS line has appeared in the commit description for a while if you
> search for it in 'git log'  of linux-next.
> 
> Please let us know if you have further comments.

Please don't add marker lines like this that provide no relevancy to
anyone else.  I don't allow gerrit ids for the same reason.  If you want
to refer to a public bug tracker, that's great, otherwise, don't
include it.

greg k-h

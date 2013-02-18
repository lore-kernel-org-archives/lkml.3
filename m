Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3BRVyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 16:54:41 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:40543 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3BRVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 16:54:38 -0500
Date: Mon, 18 Feb 2013 13:54:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: balbi@ti.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, rjw@sisk.pl, linux-pm@vger.kernel.org
Subject: Re: SYSFS "errors"
Message-ID: <20130218215434.GB16794@kroah.com>
References: <20130218153316.GA2663@arwen.pp.htv.fi>
 <20130218155012.GA30974@kroah.com>
 <20130218155215.GB2663@arwen.pp.htv.fi>
 <20130218171334.GA31329@kroah.com>
 <20130218172700.GH2663@arwen.pp.htv.fi>
 <20130218174916.GA2070@kroah.com>
 <20130218184633.GC10755@arwen.pp.htv.fi>
 <20130218164638.7cb53baa@redhat.com>
 <20130218200542.GB20137@arwen.pp.htv.fi>
 <20130218184742.5a4c3c06@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130218184742.5a4c3c06@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 06:47:42PM -0300, Mauro Carvalho Chehab wrote:
> In the past, the sysfs node creation was done using the raw sysfs support.
> Doing dynamic creation with the old code were much more complex. I guess
> that's the reason why the code was written this way. Now that the code 
> uses struct device, it shouldn't be hard to change the code to only 
> create this attribute if the device has support for scrub rate setting.
> 
> Yet, that would change the userspace API. I'm not sure what
> applications would rely on the current behavior. So, changing it
> would require some investigation in order to avoid regressions.

Because sysfs is "one value per file" the lack of a file showing up
shouldn't cause any userspace tools any problems, that is why we did
things this way.

But, of course, userspace programmers do know how to mess things up...

greg k-h

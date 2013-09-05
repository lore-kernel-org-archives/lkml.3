Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3IEV0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 17:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab3IEV0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 17:26:30 -0400
Date: Thu, 5 Sep 2013 17:26:06 -0400
From: Dave Jones <davej@redhat.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kobject: delayed kobject release: help find buggy drivers
Message-ID: <20130905212606.GA22584@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Greg KH <gregkh@linuxfoundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130903185924.046EE660E91@gitolite.kernel.org>
 <20130903204442.GA22222@redhat.com>
 <20130903205527.GA6358@kroah.com>
 <87zjrt6tz4.fsf@rustcorp.com.au>
 <20130905041338.GA21090@redhat.com>
 <20130905045745.GA18876@kroah.com>
 <20130905051945.GB23209@redhat.com>
 <20130905173540.GK6617@n2100.arm.linux.org.uk>
 <20130905192917.GA9339@redhat.com>
 <20130905211113.GA22201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905211113.GA22201@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 05:11:13PM -0400, Dave Jones wrote:
 
 >  > Trying without serial console next..
 > 
 > rebuilt with all serial turned off.
 > 
 > no luck, then it oopses somewhere else. I'm suspecting something isn't
 > right with that debug patch, as the next trace is also in kobject_release

I managed to get to userspace on one boot, and got this.

kobject ffff88023d93f518 has been corrupted (magic 0x6b6b6b6b).  Please enable kobject debugging for full debug.

That looks like SLAB_POISON. Incompatibility between the two options ?

For some reason, even though I have DEBUG_KOBJECT on, I didn't get extra messages output.

	Dave


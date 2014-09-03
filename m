Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbaICMgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:36:13 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:57158 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaICMgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:36:12 -0400
Date: Wed, 3 Sep 2014 13:36:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Tyser <ptyser@xes-inc.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] x86, lpc, Allow only one load of lpc_ich
Message-ID: <20140903123606.GG28985@lee--X1>
References: <1409695097-5831-1-git-send-email-prarit@redhat.com>
 <20140903074315.GB28985@lee--X1>
 <5406E9B0.101@redhat.com>
 <20140903113535.GE28985@lee--X1>
 <540701B5.3020409@redhat.com>
 <20140903121941.GF28985@lee--X1>
 <54070842.2000700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54070842.2000700@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If only one is useful, why have the second one in the first place?
> 
> That's just it -- it shouldn't have been exposed (again, according to Intel).

I didn't mean at an OS level, I mean what's the point of having two on
the h/w.  I guess only Intel may know.

> > If the devices are present and we can see them, why not have 2?  Some
> > users might find a use for them.
> 
> No one will.

Okay, I guess I have my hackers head on here.  Perhaps this guy
shouldn't probe.  It just seems weird to have a device that we know
about and have register access to, but we're specifying "no playing".

> > In the WARNING you submitted only sysfs was having a hard time.
> > Perhaps the real fix would be to allow the Watchdog and GPIO driver to
> > change their name when registering, so they can each have their own
> > sysfs entries.
> 
> /me scratches head.
> 
> How does that help having multiple devices which shouldn't be exposed?

The fact that they shouldn't be exposed should be neither here nor
there.  I'm thinking that they are exposed, so why suffocate them.
Besides, what happens when there is a use-case for two of these
devices?

How are these guys being registered anyway?  Does PCI detect and
register them automatically?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

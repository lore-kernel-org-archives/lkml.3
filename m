Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3IFOlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:41:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44209 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3IFOlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:41:16 -0400
Date: Fri, 6 Sep 2013 10:41:13 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130906144113.GC25882@merlin.infradead.org>
References: <20130906011924.GA7970@redhat.com>
 <20130905212834.605408a4@gandalf.local.home>
 <20130906013455.GA10073@redhat.com>
 <20130905214455.101c6347@gandalf.local.home>
 <20130906014859.GB10073@redhat.com>
 <20130905215154.74c55e9a@gandalf.local.home>
 <20130906035827.GA13446@redhat.com>
 <20130906093252.02c748f5@gandalf.local.home>
 <20130906141852.GA18708@redhat.com>
 <20130906102413.2e52d337@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906102413.2e52d337@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:24:13AM -0400, Steven Rostedt wrote:
> 
> Is it really safe to load modules that were compiled with different
> options?

Certainly not, offsets can change based on config options.

> Sounds like a failure in the install scripts to me.
> 

Definitely a bug in those scripts, os-prober would need to run before
modules_install, since if $INSTALL_MOD_PATH is the same between config
changes, there's no guarantee the modules are loadable on the running
kernel without a reboot.

--Kyle

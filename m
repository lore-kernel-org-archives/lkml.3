Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab3IFPXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:23:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab3IFPW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:22:59 -0400
Date: Fri, 6 Sep 2013 11:22:21 -0400
From: Dave Jones <davej@redhat.com>
To: Kyle McMartin <kyle@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130906152221.GA29715@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kyle McMartin <kyle@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130905212834.605408a4@gandalf.local.home>
 <20130906013455.GA10073@redhat.com>
 <20130905214455.101c6347@gandalf.local.home>
 <20130906014859.GB10073@redhat.com>
 <20130905215154.74c55e9a@gandalf.local.home>
 <20130906035827.GA13446@redhat.com>
 <20130906093252.02c748f5@gandalf.local.home>
 <20130906141852.GA18708@redhat.com>
 <20130906102413.2e52d337@gandalf.local.home>
 <20130906144113.GC25882@merlin.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906144113.GC25882@merlin.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 10:41:13AM -0400, Kyle McMartin wrote:
 > On Fri, Sep 06, 2013 at 10:24:13AM -0400, Steven Rostedt wrote:
 > > 
 > > Is it really safe to load modules that were compiled with different
 > > options?
 > 
 > Certainly not, offsets can change based on config options.
 > 
 > > Sounds like a failure in the install scripts to me.
 > > 
 > 
 > Definitely a bug in those scripts, os-prober would need to run before
 > modules_install, since if $INSTALL_MOD_PATH is the same between config
 > changes, there's no guarantee the modules are loadable on the running
 > kernel without a reboot.

Ugh, it's actually because my local install kernel script calls
grub2-mkconfig after installing a kernel to clean out old ones and not
clutter up the boot menu. (Which in turn scans every disk using os-prober[*])

Don't waste time on this Steve, I'll just work around it somehow.

	Dave

[*] Worst thing.


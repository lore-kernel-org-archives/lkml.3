Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3CVGWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 02:22:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40575 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3CVGWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 02:22:34 -0400
Date: Fri, 22 Mar 2013 06:22:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [CFT] Re: VFS deadlock ?
Message-ID: <20130322062232.GO21522@ZenIV.linux.org.uk>
References: <20130322001257.GH21522@ZenIV.linux.org.uk>
 <CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
 <20130322012208.GJ21522@ZenIV.linux.org.uk>
 <CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
 <20130322014037.GK21522@ZenIV.linux.org.uk>
 <20130322043715.GL21522@ZenIV.linux.org.uk>
 <CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
 <20130322051817.GM21522@ZenIV.linux.org.uk>
 <CA+55aFzbV81KQh_f0=wti9=_6=PXu37z0+NJymhDvzv13GgpuA@mail.gmail.com>
 <20130322060953.GN21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322060953.GN21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 06:09:53AM +0000, Al Viro wrote:

> Hell knows...  At the very least, I'd expect /proc/self to be fairly hot.
> During the boot time - /proc/mounts, /proc/filesystems, /proc/cmdline...
> Dunno.  Would be interesting to slap a printk into proc_lookup_de() and
> see how much (and what) does it hit on a busy system...

FWIW, I'd done a quick and dirty stats collector right now - added hit count
into proc_dir_entry + /proc/counts walking the pde tree and dumping the
counts.  Left it running in practically idle kvm testbox, after boot it
shows
kmsg => 2   
kcore => 4
version => 4   
uptime => 3   
stat => 38 
meminfo => 22 
loadavg => 2
devices => 4   
consoles => 4  
cmdline => 109
filesystems => 118
swaps => 8   
modules => 2
misc => 1  
acpi => 6
fb => 1
counts => 14
sys => 1
bus => 1
fs => 1
net => 18
mounts => 10  
self => 123

IOW, counts on this one are very low so far.  OTOH, that kvm image is
practically idle, doesn't have desktop shite on it, etc.  This really
ought to be checked on something busy...  The first impression is that
the stuff outside of /proc/<pid> and /proc/sys isn't hot enough to care
about any cache retention...

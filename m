Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040Ab3B0Ngo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:36:44 -0500
Received: from dkim2.fusionio.com ([66.114.96.54]:55957 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759859Ab3B0Ngn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:36:43 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2013 08:36:43 EST
X-ASG-Debug-ID: 1361971658-03d6a5664a38810001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Wed, 27 Feb 2013 08:27:36 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs crash when low on memory.
Message-ID: <20130227132736.GH19641@localhost.localdomain>
X-ASG-Orig-Subj: Re: btrfs crash when low on memory.
References: <20130227052247.GA20213@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130227052247.GA20213@redhat.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1361971658
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.123755
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:22:47PM -0700, Dave Jones wrote:
> Something I've yet to repeat managed to leak a whole bunch of memory
> while I was travelling, and locked up my workstation.
> 
> When I got home, this was the last thing printed out before it locked up
> (it did make it into the logs thankfully) after a bunch of instances of
> the oom-killers handywork.

Yeah we have a lot of

ptr = kmalloc();
BUG_ON(ptr);

everywhere.  I'll fix this one up but I really need to sit down and go through
all of them and make sure we do the right thing in all these places.  Thanks,

Josef

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab3B0S0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:26:21 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:52196 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab3B0S0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:26:19 -0500
X-ASG-Debug-ID: 1361989579-03d6a5664941ab0001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Wed, 27 Feb 2013 13:26:17 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
CC: Josef Bacik <JBacik@fusionio.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs crash when low on memory.
Message-ID: <20130227182617.GI19641@localhost.localdomain>
X-ASG-Orig-Subj: Re: btrfs crash when low on memory.
References: <20130227052247.GA20213@redhat.com>
 <20130227132736.GH19641@localhost.localdomain>
 <CAFDW0jK6zigx0YgVMHomUkRQkqpw5mUgkdeynv36LUiQn4XTxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAFDW0jK6zigx0YgVMHomUkRQkqpw5mUgkdeynv36LUiQn4XTxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1361989579
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.123776
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 07:31:11AM -0700, Ahmet Inan wrote:
> > Yeah we have a lot of
> >
> > ptr = kmalloc();
> > BUG_ON(ptr);
> >
> > everywhere.  I'll fix this one up but I really need to sit down and go through
> > all of them and make sure we do the right thing in all these places.  Thanks,
> 
> But what would be the right thing to do when you got no memory?
> Spinlock until you can kmalloc? Pre-reserve some memory?
>

Return ENOMEM?  We have a way to abort transactions now, if it's in a horrible
of enough spot we can just abort the transaction and let the user deal with the
aftermath, it's nicer than panicing.  Thanks,

Josef 

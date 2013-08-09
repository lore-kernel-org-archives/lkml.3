Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030596Ab3HIOfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:35:41 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:45128 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030208Ab3HIOfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:35:39 -0400
X-ASG-Debug-ID: 1376058938-0421b5022123ee00001-xx1T2L
X-Barracuda-Envelope-From: JBacik@fusionio.com
Date: Fri, 9 Aug 2013 10:35:37 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Josef Bacik <jbacik@fusionio.com>, Thorsten Glaser <tg@mirbsd.de>,
        Joe Perches <joe@perches.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>,
        <linux-btrfs@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: btrfs zero divide
Message-ID: <20130809143537.GA861@localhost.localdomain>
X-ASG-Orig-Subj: Re: btrfs zero divide
References: <Pine.BSM.4.64L.1307300820160.20675@herc.mirbsd.org>
 <alpine.DEB.2.02.1307301052010.23107@ayla.of.borg>
 <20130730171329.GF24583@localhost.localdomain>
 <Pine.BSM.4.64L.1307301741360.20305@herc.mirbsd.org>
 <20130730204001.GG24583@localhost.localdomain>
 <87eha33v9f.fsf@igel.home>
 <87a9kr3v2p.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87a9kr3v2p.fsf@igel.home>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1376058938
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.138082
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 02:30:38PM +0200, Andreas Schwab wrote:
> Andreas Schwab <schwab@linux-m68k.org> writes:
> 
> > Josef Bacik <jbacik@fusionio.com> writes:
> >
> >> So stripe_len shouldn't be 0, if it is you have bigger problems :).
> >
> > The bigger problem is that stripe_nr is u64, this is completely bogus.
> > The first operand of do_div must be u32.  This goes through the whole
> > file.
> 
> Of course, what I meant was that the *second* operand must be u32, but
> that doesn't change my point.
> 

Yeah we can change this.  Thanks,

Josef

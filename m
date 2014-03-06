Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaCFSLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:11:36 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:6195 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbaCFSLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:11:34 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Anw7AMy5GFNbsmBr/2dsb2JhbABaKIJeO4MLpgBImB8CAoEaF3SCJQEBAQMBJxMcIwULCAMOCi4hGB4GE4dlAwkMAchADYZ1F4xEghcHhDgBA4lKjQeBbAGBMosxhUiDOi8
Date: Thu, 6 Mar 2014 18:13:05 +0800
From: Fabian Frederick <fabf@skynet.be>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-mtd@lists.infradead.org, akpm@linux-foundation.org,
        rdunlap@infradead.org, joern@lazybastard.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mtd: block2mtd: check device size
Message-Id: <20140306181305.3275a72f0070762cfd6e5670@skynet.be>
In-Reply-To: <20140306085422.GY13420@norris-Latitude-E6410>
References: <20140123205331.03314c6f82f24a6bb4b8ef53@skynet.be>
	<20140129100424.GA15271@localhost>
	<20140129205105.b88b00ea09c07de7014ab1d9@skynet.be>
	<20140306085422.GY13420@norris-Latitude-E6410>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 00:54:22 -0800
Brian Norris <computersforpeace@gmail.com> wrote:

> Hi,
> 
> On Wed, Jan 29, 2014 at 08:51:05PM +0800, Fabian Frederick wrote:
> > On Wed, 29 Jan 2014 07:04:25 -0300 Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:
> > > I saw you sent a v2 for one of the patches on this series,
> > > but maybe this is worth considering too.
> > > 
> > > On Thu, Jan 23, 2014 at 08:53:31PM +0100, Fabian Frederick wrote:
> > > [..]
> > > > -/* FIXME: ensure that mtd->size % erase_size == 0 */
> > > >  static struct block2mtd_dev *add_device(char *devname, int erase_size)
> > > >  {
> > > >  	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
> > > > @@ -250,6 +249,11 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
> > > >  		goto devinit_err1;
> > > >  	}
> > > >  
> > > > +	if ((long)dev->blkdev->bd_inode->i_size % erase_size) {
> > > > +		pr_err("erasesize muse be a divisor of device size\n");
> > > > +		goto devinit_err1;
> > > > +	}
> > > > +
> > > 
> > > Brian: What do you think?
> > > 
> > > Fabian: Have you tested this patch? Can you elaborate a bit more about
> > > the effect it would have, compared to the current behavior?
> > 
> > Hi Ezequiel,
> > 
> >    This patch was tested with the following commands :
> >    
> > rmmod block2mtd;modprobe block2mtd block2mtd=/dev/loop0,<erasesize>;dmesg
> > 
> > with both correct and incorrect values.It tries to address the fixme 
> > comment above the function.
> > (/* FIXME: ensure that mtd->size % erase_size == 0 */) 
> >    
> >    From what I understand, global size must be a multiple of 
> > erase_size when it comes to any MTD I/O operations. If Brian finds this one 
> > interesting I can repost it with current error names against l2-mtd.git/next
> 
> I'm not sure block2mtd would have many users, but the hunk above looks
> reasonable. Feel free to send a patch.

Hi Brian,

   I just send a patch v2 based on linux-next to avoid conflicts with my previous commit about
 mutex management in the same function and still staging there.

Fabian

> 
> >    AFAICS, current behavior let any value work...
> 
> I bet this doesn't work out too well in the end. Maybe I'll give this a
> whirl just to see.
> 
> >  PS : This would need further testing (eg boot command).
> 
> Brian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaA2Utz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:49:55 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:19768 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbaA2Uty convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:49:54 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aiw9AIFo6VJbtAe+/2dsb2JhbABZKIJkOIMCpQxDlRACAoEGF3SCJQEBAQMBJy8jBQsIAxguOR4GE4d9DAHKGBeOTDMHhDgEiUeOYAGBMpBtgzov
Date: Wed, 29 Jan 2014 20:51:05 +0800
From: Fabian Frederick <fabf@skynet.be>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Brian Norris <computersforpeace@gmail.com>, linux-mtd@lists.infradead.org,
        akpm@linux-foundation.org, rdunlap@infradead.org,
        joern@lazybastard.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mtd: block2mtd: check device size
Message-Id: <20140129205105.b88b00ea09c07de7014ab1d9@skynet.be>
In-Reply-To: <20140129100424.GA15271@localhost>
References: <20140123205331.03314c6f82f24a6bb4b8ef53@skynet.be>
	<20140129100424.GA15271@localhost>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014 07:04:25 -0300
Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:

> Hi Fabian,
> 
> I saw you sent a v2 for one of the patches on this series,
> but maybe this is worth considering too.
> 
> On Thu, Jan 23, 2014 at 08:53:31PM +0100, Fabian Frederick wrote:
> [..]
> > -/* FIXME: ensure that mtd->size % erase_size == 0 */
> >  static struct block2mtd_dev *add_device(char *devname, int erase_size)
> >  {
> >  	const fmode_t mode = FMODE_READ | FMODE_WRITE | FMODE_EXCL;
> > @@ -250,6 +249,11 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
> >  		goto devinit_err1;
> >  	}
> >  
> > +	if ((long)dev->blkdev->bd_inode->i_size % erase_size) {
> > +		pr_err("erasesize muse be a divisor of device size\n");
> > +		goto devinit_err1;
> > +	}
> > +
> 
> Brian: What do you think?
> 
> Fabian: Have you tested this patch? Can you elaborate a bit more about
> the effect it would have, compared to the current behavior?

Hi Ezequiel,

   This patch was tested with the following commands :
   
rmmod block2mtd;modprobe block2mtd block2mtd=/dev/loop0,<erasesize>;dmesg

with both correct and incorrect values.It tries to address the fixme 
comment above the function.
(/* FIXME: ensure that mtd->size % erase_size == 0 */) 
   
   From what I understand, global size must be a multiple of 
erase_size when it comes to any MTD I/O operations. If Brian finds this one 
interesting I can repost it with current error names against l2-mtd.git/next

   AFAICS, current behavior let any value work...
  
 PS : This would need further testing (eg boot command).
 
Regards,
Fabian


> -- 
> Ezequiel García, Free Electrons
> Embedded Linux, Kernel and Android Engineering
> http://free-electrons.com

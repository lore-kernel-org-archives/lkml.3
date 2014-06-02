Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaFBR44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:56:56 -0400
Received: from smtprelay0030.hostedemail.com ([216.40.44.30]:51885 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750723AbaFBR4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:56:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3871:3876:4321:5007:7652:7901:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12679:12740:13069:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: force35_763cd5f723049
X-Filterd-Recvd-Size: 1852
Message-ID: <1401731811.7323.2.camel@joe-AO725>
Subject: Re: [PATCH V3] drivers/scsi/bfa/bfad_debugfs.c: replace 2
 kzalloc/copy_from_user by memdup_user
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Date: Mon, 02 Jun 2014 10:56:51 -0700
In-Reply-To: <1401731439-17978-1-git-send-email-fabf@skynet.be>
References: <1401731439-17978-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 19:50 +0200, Fabian Frederick wrote:
> This patch also removes unnecessary printk(KERN_INFO
[]
> diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
[]
> @@ -260,18 +260,10 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
>  	unsigned long flags;
>  	void *kern_buf;
>  
> -	kern_buf = kzalloc(nbytes, GFP_KERNEL);
> +	kern_buf = memdup_user(buf, nbytes);
>  

trivial note:

There's an uncommon blank line here.

Generally this form is:

	foo = memdup_user(bar, len);
	if (IS_ERR(foo))

not

	foo = memdup_user(bar, len);

	if (IS_ERR(foo))


> @@ -336,18 +328,10 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
>  	unsigned long flags;
>  	void *kern_buf;
>  
> -	kern_buf = kzalloc(nbytes, GFP_KERNEL);
> +	kern_buf = memdup_user(buf, nbytes);
>  

here too.



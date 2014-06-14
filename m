Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaFNUDm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:03:42 -0400
Received: from smtprelay0106.hostedemail.com ([216.40.44.106]:46076 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751633AbaFNUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:03:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3868:3872:4184:4250:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13019:13069:13071:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pet46_1fdb62801f861
X-Filterd-Recvd-Size: 2240
Message-ID: <1402776217.2756.23.camel@joe-AO725>
Subject: Re: [PATCH] Coccinelle : Script to detect cast after memory
 allocation
From: Joe Perches <joe@perches.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Date: Sat, 14 Jun 2014 13:03:37 -0700
In-Reply-To: <CAB78YHwDpK988sKk5pzXWhuMszyyS=wtk5ETP-B-JBGdwRPxhw@mail.gmail.com>
References: <20140614154541.GA4179@himangi-Dell>
	 <1402761961.2756.12.camel@joe-AO725>
	 <alpine.DEB.2.02.1406141809050.1962@localhost6.localdomain6>
	 <1402765314.2756.20.camel@joe-AO725>
	 <CAB78YHwDpK988sKk5pzXWhuMszyyS=wtk5ETP-B-JBGdwRPxhw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-15 at 01:03 +0530, Himangi Saraogi wrote:
> Hi,

Hi Himangi.

> I have run the generic rule but it does not detect the cases of
> cast where the k[mzc]alloc or the kmem functions are used. I have used
> flags like recursive-includes, as suggested by Julia, but not any of the
> cases covered by the original script are detected.

Odd.

When I tried it I got things like:

$ cat void.cocci 
@@
void *t;
type other;
@@

-	(other *)t
+	t

$ spatch --version
spatch version 1.0.0-rc14 without Python support and with PCRE support

$ spatch --sp-file void.cocci --recursive-includes drivers/block/cciss_scsi.c
drivers/block/cciss_scsi.c
+++ /tmp/cocci-output-8427-7875f0-cciss_scsi.c
@@ -704,8 +704,7 @@ cciss_scsi_setup(ctlr_info_t *h)
 	struct cciss_scsi_adapter_data_t * shba;
 
 	ccissscsi[h->ctlr].ndevices = 0;
-	shba = (struct cciss_scsi_adapter_data_t *)
-		kmalloc(sizeof(*shba), GFP_KERNEL);	
+	shba = kmalloc(sizeof(*shba), GFP_KERNEL);	
 	if (shba == NULL)
 		return;
 	shba->scsi_host = NULL;




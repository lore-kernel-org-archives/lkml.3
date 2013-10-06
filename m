Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3JFTx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 15:53:28 -0400
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:35563 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754289Ab3JFTx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 15:53:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:7903:7904:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: quill63_1dcae308f4b4e
X-Filterd-Recvd-Size: 1630
Message-ID: <1381089202.2081.157.camel@joe-AO722>
Subject: Re: [PATCH 1/2] tpm: Rename tpm.c to tpm-interface.c
From: Joe Perches <joe@perches.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Peter H?we <PeterHuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net,
        Ashley Lai <ashley@ashleylai.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Date: Sun, 06 Oct 2013 12:53:22 -0700
In-Reply-To: <20131006193824.GA19123@obsidianresearch.com>
References: <20131006193824.GA19123@obsidianresearch.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-06 at 13:38 -0600, Jason Gunthorpe wrote:
> This is preparation for making the tpm module multi-file. kbuild does
> not like having a .c file with the same name as a module. We wish to
> keep the tpm module name so that userspace doesn't see this change.

If that's true, and I don't believe it is,
then Kbuild should be fixed instead.

There are a lot of examples of .c files named
the same as the directory they reside in.

For example:

drivers/net/ethernet/myricom/myri10ge/myri10ge.ko

$ find drivers -type d  | while read file ; do if [ -f $file/$(basename $file).c ] ; then echo $file ; fi ; done



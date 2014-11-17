Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaKQHeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 02:34:31 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49706 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaKQHea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 02:34:30 -0500
Date: Mon, 17 Nov 2014 10:34:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] kernel-audit: Deletion of an unnecessary check
 before the function call "audit_log_end"
Message-ID: <20141117073408.GC4905@mwanda>
References: <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54687F1A.1010809@users.sourceforge.net>
 <20141116111023.GA4905@mwanda>
 <20141116111446.GA4956@mwanda>
 <54688F15.9070703@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54688F15.9070703@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 12:48:37PM +0100, SF Markus Elfring wrote:
> > An example of a bug introduced is here:
> > 
> > https://lkml.org/lkml/2014/11/3/505
> 
> It seems that we try to clarify a different interpretation of "bugs", don't we?
> 

You removed the statement from "if (foo) kfree_fsm(foo);" so now it
prints a warning.

drivers/s390/net/fsm.c
    71  void
    72  kfree_fsm(fsm_instance *this)
    73  {
    74          if (this) {
    75                  if (this->f) {
    76                          kfree(this->f->jumpmatrix);
    77                          kfree(this->f);
    78                  }
    79                  kfree(this);
    80          } else
    81                  printk(KERN_WARNING
    82                          "fsm: kfree_fsm called with NULL argument\n");
    83  }

> It is an usual software development challenge to decide on the best source code places
> where to put input parameter validation (and when it can be omitted), isn't it?

No, it's not.  You should just try to write the most readable software
you can instead of removing if statements because you can.

But that's not my point.  My point is that these patches are not always
welcome so we should not merge them through the trivial tree.

regards,
dan carpenter

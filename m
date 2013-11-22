Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3KVQk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:40:29 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43242 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab3KVQk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:40:28 -0500
Message-ID: <1385138424.11733.34.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [BUG] 3ce1217d6cd5 ima patch causes s390 to crash on boot
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Roberto Sassu <roberto.sassu@polito.it>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 22 Nov 2013 11:40:24 -0500
In-Reply-To: <20131122163502.GE4208@osiris>
References: <20131122114819.GB4208@osiris> <528F5C01.8020304@polito.it>
	 <20131122141314.GC4208@osiris> <528F8515.7040201@polito.it>
	 <20131122163502.GE4208@osiris>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112216-8236-0000-0000-00000414F9AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 17:35 +0100, Heiko Carstens wrote:
> On Fri, Nov 22, 2013 at 05:23:49PM +0100, Roberto Sassu wrote:
> > Another problem that I found is that strsep()
> > modifies the source buffer by replacing the separator
> > character with '\0'. In particular, this function
> > modifies static data initialized at the beginning
> > of the ima_template.c file. Maybe, this is causing
> > the kernel panic. I already sent a patch to fix this
> > problem (attached to the email) even if it is not
> > supposed to land on the 3.13 kernel. Let me know
> > if this fixes the issue. Otherwise, I will check
> > the code more in depth.
> 
> With your patch below applied the kernel boots again.
> So it should go into 3.13 (or a different fix).
> 
> Thanks!

Thanks for testing!  There are a number of bug fixes for this release in
linux-integrity/ima-fixes-new.  Now that the security patches made it
into Linus' tree, I'll send the pull request to James.

thanks,

Mimi


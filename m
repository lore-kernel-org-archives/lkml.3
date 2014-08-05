Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaHEMj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:39:58 -0400
Received: from ozlabs.org ([103.22.144.67]:55668 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbaHEMj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:39:57 -0400
Message-ID: <1407242394.11569.2.camel@concordia>
Subject: Re: [PATCH] arch/powerpc/mm/numa.c: Fix break placement
From: Michael Ellerman <mpe@ellerman.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>, paulus@samba.org,
        akpm@linux-foundation.org, srivatsa.bhat@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, qiuxishi@huawei.com, wangyun@linux.vnet.ibm.com,
        qiudayu@linux.vnet.ibm.com, joe@perches.com, alistair@popple.id.au,
        rcj@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Tue, 05 Aug 2014 22:39:54 +1000
In-Reply-To: <1407230219.3073.5.camel@pasglop>
References: <1407183190-1397-1-git-send-email-andrey.krieger.utkin@gmail.com>
	 <1407230219.3073.5.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-05 at 19:16 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2014-08-04 at 23:13 +0300, Andrey Utkin wrote:
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81631
> > Reported-by: David Binderman <dcb314@hotmail.com>
> > Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> 
> Thanks, I wonder how that managed to remain unnoticed for so long !

1. No one tested it :)
2. The code stupidly initialises ret at the beginning of the function, so the
   compiler can't help us detect the unitialised usage.
3. NOTIFY_OK and NOTIFY_DONE appear to be equivalent in practice.

cheers




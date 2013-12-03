Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3LCPyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:54:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53219 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3LCPyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:54:09 -0500
Date: Tue, 3 Dec 2013 15:51:53 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
Message-ID: <20131203155153.2b5488d2@alan.etchedpixels.co.uk>
In-Reply-To: <1386083821.13256.42.camel@kazak.uk.xensource.com>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
	<529DBA07.6090108@citrix.com>
	<1386068884.13256.9.camel@kazak.uk.xensource.com>
	<529DC7BA.7080506@citrix.com>
	<1386078108.13256.30.camel@kazak.uk.xensource.com>
	<529DF4A0.50103@citrix.com>
	<1386083821.13256.42.camel@kazak.uk.xensource.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If Konrad and Boris agree that breaking the kernel's ABI in this way is
> > acceptable in this specific case, I'll defer to them.
> 
> My opinion as Xen on ARM hypervisor maintainer is that this is the right
> thing to do in this case.

Sounds to me like the difference between "product" and "research toy".
You don't break back compatibility in a product when you can avoid it.
You may wish the publically humiliate those responsible (Linus seems to)
but at the end of the day it's done.

Your boolean choice is a false one anyway - you can do at least three
different things

- Implement and tell people to use the new API, break everyone's PoC and
  deployed systems, prevent old kernels running on newer Xen and
  generally make users lose confidence in it

- Keep the erroneous API and live with the uglies

- Keep the erroneous API working but implement a new clean API (and
  possibly make misuse produce a one per boot whine about fixing your
  kernel)

The Linux approach has tended to be the last one most of the time,
coupled with Linus having a rant 8)

Alan

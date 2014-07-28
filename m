Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaG1MzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:55:10 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45517 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaG1MzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:55:07 -0400
X-IronPort-AV: E=Sophos;i="5.01,749,1400025600"; 
   d="scan'208";a="156355935"
Message-ID: <53D64828.6020209@citrix.com>
Date: Mon, 28 Jul 2014 13:55:04 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Frediano Ziglio <frediano.ziglio@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: xen-devel <xen-devel@lists.xenproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: xen: Fix possible page fault in fifo events
References: <1405432129.1749.5.camel@hamster.uk.xensource.com>
In-Reply-To: <1405432129.1749.5.camel@hamster.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/14 14:48, Frediano Ziglio wrote:
> sync_test_bit function require a long* read access to pointer.
> This is a problem if the you are using last entry in the page causing
> an access to next page. If this page is not readable you get a memory
> access failure (page fault).
> All other x64 bit functions access memory using 32 bit operations.
> For processors different than x64 long aligned operations are used.

I think we should implement a set of 32-bit bit ops.  We fudged around
it for the arm64 problem but this second problem shows we need a better
solution.

David


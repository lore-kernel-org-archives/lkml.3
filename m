Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaIVPEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:04:31 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:24900 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaIVPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:04:23 -0400
X-IronPort-AV: E=Sophos;i="5.04,572,1406592000"; 
   d="scan'208";a="174884327"
Message-ID: <54203A73.8030103@citrix.com>
Date: Mon, 22 Sep 2014 16:04:19 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
CC: <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3 v2] xen/xenbus: Improve failure processing
 code for __xenbus_switch_state()
References: <541AE4E9.2040904@gmail.com> <541AE5C4.2070409@gmail.com>
In-Reply-To: <541AE5C4.2070409@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/14 15:01, Chen Gang wrote:
> When failure occurs, need return failure code instead of 0, or some of
> indirect upper callers may misunderstand.
> 
> e.g. in "block/xen-blkback/xenbus.c":
> 
>     connect() -> xenbus_switch_state() -> __xenbus_switch_state().

Can you make xenbus_switch_state() void?  The callers don't need to do
any error handling.

David

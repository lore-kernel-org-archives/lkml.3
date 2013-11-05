Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3KEMgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 07:36:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:40767 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab3KEMga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 07:36:30 -0500
X-IronPort-AV: E=Sophos;i="4.93,639,1378857600"; 
   d="scan'208";a="68112688"
Message-ID: <5278E64C.40200@citrix.com>
Date: Tue, 5 Nov 2013 12:36:28 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        Matt Wilson <msw@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] grant-table: don't set m2p override if kmap_ops is not
 set
References: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1383650649-13971-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/13 11:24, Roger Pau Monne wrote:
> IMHO there's no reason to set a m2p override if the mapping is done in
> kernel space, so only set the m2p override when kmap_ops is set.

Can you provide a more detailed reasoning about why this is safe?

Did you consider other ways of improving scalability?  e.g., a
per-bucket read-write lock.

David

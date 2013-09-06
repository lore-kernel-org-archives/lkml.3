Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab3IFQHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:07:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18230 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701Ab3IFQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:07:43 -0400
X-IronPort-AV: E=Sophos;i="4.90,855,1371081600"; 
   d="scan'208";a="48952682"
Message-ID: <5229FDCC.5000705@citrix.com>
Date: Fri, 6 Sep 2013 17:07:40 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] xen/p2m: Export set_phys_to_machine.
References: <1378476042-4821-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1378476042-4821-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/13 15:00, Konrad Rzeszutek Wilk wrote:
> We have already exported 'get_phys_to_machine' and there are
> third-party drivers that depend on this other symbol. As such
> lets make this balanced and also export this symbol.

I'm not sure this is a good idea.  It isn't clear why any out of tree
driver would need to mess with the p2m (or that we would actually trust
a third party driver to do this correctly...).

Also, the general kernel policy is not to export symbols that aren't
used by something in the kernel tree itself.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbaDGROj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:14:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:35383 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbaDGROb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:14:31 -0400
X-IronPort-AV: E=Sophos;i="4.97,811,1389744000"; 
   d="scan'208";a="117566235"
Message-ID: <5342DCF3.7080408@citrix.com>
Date: Mon, 7 Apr 2014 18:14:27 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: <konrad@kernel.org>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, <stable@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] xen/spinlock: Don't enable them unconditionally.
References: <1396637284-6312-1-git-send-email-konrad@kernel.org>
In-Reply-To: <1396637284-6312-1-git-send-email-konrad@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 19:48, konrad@kernel.org wrote:
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> The git commit a945928ea2709bc0e8e8165d33aed855a0110279
> ('xen: Do not enable spinlocks before jump_label_init() has executed')
> was added to deal with the jump machinery. Earlier the code
> that turned on the jump label was only called by Xen specific
> functions. But now that it had been moved to the initcall machinery
> it gets called on Xen, KVM, and baremetal - ouch!. And the detection
> machinery to only call it on Xen wasn't remembered in the heat
> of merge window excitement.
> 
> This means that the slowpath is enabled on baremetal while it should
> not be.

Applied to devel/for-linus-3.15.

Thanks.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbaDIOJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:09:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:57771 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbaDIOJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:09:11 -0400
X-IronPort-AV: E=Sophos;i="4.97,826,1389744000"; 
   d="scan'208";a="119503109"
Message-ID: <53455468.5040201@citrix.com>
Date: Wed, 9 Apr 2014 15:08:40 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: <konrad.wilk@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <srostedt@redhat.com>
Subject: Re: [PATCH] x86/xen: Fix 32-bit PV guests's usage of kernel_stack
References: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1397052401-20220-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 15:06, Boris Ostrovsky wrote:
> Commit 198d208df4371734ac4728f69cb585c284d20a15 made 32-bit kernels use
> kernel_stack to point to thread_info. That change missed a couple of
> updates needed by Xen's PV guests:

Can you put the commit subject in addition to the hash?

> 1. kernel_stack needs to be initialized for secondary CPUs
> 2. GET_THREAD_INFO() now uses %fs register which may not be the kernel's
> version when executing xen_iret()

Otherwise,

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David

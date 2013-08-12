Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab3HLSoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:44:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7821 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab3HLSoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:44:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,863,1367971200"; 
   d="scan'208";a="43520611"
Message-ID: <52092CF9.4050006@citrix.com>
Date: Mon, 12 Aug 2013 19:44:09 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Yechen Li <lccycc123@gmail.com>
CC: <xen-devel@lists.xen.org>, <dario.faggioli@citrix.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v1][RFC] drivers/xen,	balloon driver numa
 support in kernel
References: <1376316812-30346-1-git-send-email-lccycc123@gmail.com>
In-Reply-To: <1376316812-30346-1-git-send-email-lccycc123@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/13 15:13, Yechen Li wrote:
>   This small patch adds numa support for balloon driver. Kernel version: 3.11-rc5
>   It's just a RFC version, since I'm waiting for the interface of numa topology.
>   The balloon driver will read arguments from xenstore: /local/domain/(id)/memory
> /target_nid, and settle the memory increase/decrease operation on specified
> p-nodeID.

Its is difficult to review an ABI change without any documentation for
the new ABI.

I would also like to see a design document explaining the overall
approach planned to be used here.  It's not clear why explicitly
specifying nodes is preferable to (e.g.) the guest releasing/populating
evenly across all its nodes (this would certainly be better for the guest).

It seems like unless this is used carefully, all VMs will end up with
suboptimal memory layouts as they are repeatedly balloon up and down to
satisfy the whims of the latest VM being started etc.

David

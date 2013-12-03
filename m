Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3LCLBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:01:33 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:12699 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3LCLBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:01:30 -0500
X-IronPort-AV: E=Sophos;i="4.93,817,1378857600"; 
   d="scan'208";a="77667445"
Message-ID: <529DBA07.6090108@citrix.com>
Date: Tue, 3 Dec 2013 11:01:27 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        Julien Grall <julien.grall@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH RFC] xen-block: correctly define structures in public
 headers
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 10:57, Roger Pau Monne wrote:
> Using __packed__ on the public interface is not correct, this
> structures should be compiled using the native ABI, and __packed__
> should only be used in the backend counterpart of those structures
> (which needs to handle different ABIs).
> 
> This was even worse in the ARM case, where the Linux kernel was
> incorrectly using the X86_32 protocol ABI. This patch fixes it, but
> also breaks compatibility, so an ARM DomU kernel compiled with
> this patch will fail to communicate with PV disk devices unless the
> Dom0 also has this patch.

This ABI change needs to be justified.  Why do you think it is
acceptable to break existing Linux guests?  Because I don't think it is.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3LCLIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:08:10 -0500
Received: from smtp.citrix.com ([66.165.176.89]:30775 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab3LCLIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:08:07 -0500
X-IronPort-AV: E=Sophos;i="4.93,817,1378857600"; 
   d="scan'208";a="80040266"
Message-ID: <1386068884.13256.9.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>
Date: Tue, 3 Dec 2013 11:08:04 +0000
In-Reply-To: <529DBA07.6090108@citrix.com>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
	 <529DBA07.6090108@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 11:01 +0000, David Vrabel wrote:
> On 03/12/13 10:57, Roger Pau Monne wrote:
> > Using __packed__ on the public interface is not correct, this
> > structures should be compiled using the native ABI, and __packed__
> > should only be used in the backend counterpart of those structures
> > (which needs to handle different ABIs).
> > 
> > This was even worse in the ARM case, where the Linux kernel was
> > incorrectly using the X86_32 protocol ABI. This patch fixes it, but
> > also breaks compatibility, so an ARM DomU kernel compiled with
> > this patch will fail to communicate with PV disk devices unless the
> > Dom0 also has this patch.
> 
> This ABI change needs to be justified.  Why do you think it is
> acceptable to break existing Linux guests?  Because I don't think it is.

As I explained in my reply those guests are buggy.

Ian.


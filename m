Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3LCLP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:15:27 -0500
Received: from smtp.citrix.com ([66.165.176.89]:27179 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab3LCLPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:15:24 -0500
X-IronPort-AV: E=Sophos;i="4.93,817,1378857600"; 
   d="scan'208";a="80041612"
Message-ID: <1386069322.13256.11.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>,
        <xen-devel@lists.xenproject.org>,
        BorisOstrovsky <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 3 Dec 2013 11:15:22 +0000
In-Reply-To: <529DCA8F02000078001094FF@nat28.tlf.novell.com>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
	 <1386068729.13256.8.camel@kazak.uk.xensource.com>
	 <529DCA8F02000078001094FF@nat28.tlf.novell.com>
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

On Tue, 2013-12-03 at 11:11 +0000, Jan Beulich wrote:
> >>> On 03.12.13 at 12:05, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> > On Tue, 2013-12-03 at 11:57 +0100, Roger Pau Monne wrote:
> >> Using __packed__ on the public interface is not correct, this
> >> structures should be compiled using the native ABI, and __packed__
> >> should only be used in the backend counterpart of those structures
> >> (which needs to handle different ABIs).
> >> 
> >> This was even worse in the ARM case, where the Linux kernel was
> >> incorrectly using the X86_32 protocol ABI. This patch fixes it, but
> >> also breaks compatibility, so an ARM DomU kernel compiled with
> >> this patch will fail to communicate with PV disk devices unless the
> >> Dom0 also has this patch.
> > 
> > This is acceptable IMHO, the ARM ABI is clearly defined and previous
> > kernels were simply buggy. The fact that front and backend were
> > equivalently buggy and so it happened to work is not an excuse.
> 
> But afaics the change is not just to the ARM form of the ABI,
> but to x86 (32- and 64-bit) too. And that clearly must not be
> altered.

I understood there to be no (intentional) change to the x86 ABIs here.
Obviously that would be a bug in the patch.

Ian.


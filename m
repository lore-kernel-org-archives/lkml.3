Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbbAEKfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:35:08 -0500
Received: from smtp.citrix.com ([66.165.176.89]:52469 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbbAEKfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:35:07 -0500
X-IronPort-AV: E=Sophos;i="5.07,698,1413244800"; 
   d="scan'208";a="210740275"
Message-ID: <54AA68D8.7050400@citrix.com>
Date: Mon, 5 Jan 2015 10:35:04 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: xen/x86: properly retrieve NMI reason
References: <54945D760200007800051157@mail.emea.novell.com>
In-Reply-To: <54945D760200007800051157@mail.emea.novell.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/14 16:16, Jan Beulich wrote:
> Using the native code here can't work properly, as the hypervisor would
> normally have cleared the two reason bits by the time Dom0 gets to see
> the NMI (if passed to it at all). There's a shared info field for this,
> and there's an existing hook to use - just fit the two together. Note
> that the hook can (and should) be used irrespective of whether being in
> Dom0, as accessing port 0x61 in a DomU would be even worse, while the
> shared info field would just hold zero all the time.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

This doesn't build.

In file included from
/local/davidvr/work/k.org/tip/arch/x86/xen/enlighten.c:43:0:
/local/davidvr/work/k.org/tip/include/xen/interface/nmi.h:44:1: warning:
data definition has no type or storage class [enabled by default]
/local/davidvr/work/k.org/tip/include/xen/interface/nmi.h:44:1: error:
type defaults to ‘int’ in declaration of ‘DEFINE_XEN_GUEST_HANDLE’
[-Werror=implicit-int]
cc1: some warnings being treated as errors

David

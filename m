Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaFWJ5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:57:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:9366 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbaFWJ5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:57:39 -0400
X-IronPort-AV: E=Sophos;i="5.01,529,1400025600"; 
   d="scan'208";a="146347754"
Message-ID: <53A7FA0B.4070106@citrix.com>
Date: Mon, 23 Jun 2014 10:57:31 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>
CC: <mjg59@srcf.ucam.org>, <jeremy@goop.org>, <matt.fleming@intel.com>,
        <ian.campbell@citrix.com>, <andrew.cooper3@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mingo@redhat.com>,
        <david.vrabel@citrix.com>, <jbeulich@suse.com>, <hpa@zytor.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        <eshelton@pobox.com>
Subject: Re: [Xen-devel] [PATCH v6 7/9] xen: Put EFI machinery in place
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com> <1403299768-9955-8-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1403299768-9955-8-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/14 22:29, Daniel Kiper wrote:
> This patch enables EFI usage under Xen dom0. Standard EFI Linux
> Kernel infrastructure cannot be used because it requires direct
> access to EFI data and code. However, in dom0 case it is not possible
> because above mentioned EFI stuff is fully owned and controlled
> by Xen hypervisor. In this case all calls from dom0 to EFI must
> be requested via special hypercall which in turn executes relevant
> EFI code in behalf of dom0.
> 
> When dom0 kernel boots it checks for EFI availability on a machine.
> If it is detected then artificial EFI system table is filled.
> Native EFI callas are replaced by functions which mimics them
> by calling relevant hypercall. Later pointer to EFI system table
> is passed to standard EFI machinery and it continues EFI subsystem
> initialization taking into account that there is no direct access
> to EFI boot services, runtime, tables, structures, etc. After that
> system runs as usual.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

(With or without the change suggested by Stefano).

Thanks.

David

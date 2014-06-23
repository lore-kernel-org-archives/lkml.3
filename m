Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaFWN6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:58:50 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22968 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbaFWN6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:58:49 -0400
Date: Mon, 23 Jun 2014 15:57:58 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, mjg59@srcf.ucam.org, jeremy@goop.org,
        matt.fleming@intel.com, ian.campbell@citrix.com,
        andrew.cooper3@citrix.com, stefano.stabellini@eu.citrix.com,
        mingo@redhat.com, jbeulich@suse.com, hpa@zytor.com,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, eshelton@pobox.com
Subject: Re: [Xen-devel] [PATCH v6 7/9] xen: Put EFI machinery in place
Message-ID: <20140623135758.GH28489@olila.local.net-space.pl>
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
 <1403299768-9955-8-git-send-email-daniel.kiper@oracle.com>
 <53A7FA0B.4070106@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A7FA0B.4070106@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:57:31AM +0100, David Vrabel wrote:
> On 20/06/14 22:29, Daniel Kiper wrote:
> > This patch enables EFI usage under Xen dom0. Standard EFI Linux
> > Kernel infrastructure cannot be used because it requires direct
> > access to EFI data and code. However, in dom0 case it is not possible
> > because above mentioned EFI stuff is fully owned and controlled
> > by Xen hypervisor. In this case all calls from dom0 to EFI must
> > be requested via special hypercall which in turn executes relevant
> > EFI code in behalf of dom0.
> >
> > When dom0 kernel boots it checks for EFI availability on a machine.
> > If it is detected then artificial EFI system table is filled.
> > Native EFI callas are replaced by functions which mimics them
> > by calling relevant hypercall. Later pointer to EFI system table
> > is passed to standard EFI machinery and it continues EFI subsystem
> > initialization taking into account that there is no direct access
> > to EFI boot services, runtime, tables, structures, etc. After that
> > system runs as usual.
>
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Thanks for this and second one.

> (With or without the change suggested by Stefano).

I am going to take into account Stefano's idea.

Daniel

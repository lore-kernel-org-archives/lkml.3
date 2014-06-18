Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaFRPMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:12:37 -0400
Received: from mail-we0-f196.google.com ([74.125.82.196]:42973 "EHLO
	mail-we0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaFRPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:12:35 -0400
Date: Wed, 18 Jun 2014 16:12:32 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, Daniel Kiper <daniel.kiper@oracle.com>,
        andrew.cooper3@citrix.com, david.vrabel@citrix.com,
        ian.campbell@citrix.com, jeremy@goop.org, matt.fleming@intel.com,
        x86@kernel.org, tglx@linutronix.de, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com, eshelton@pobox.com,
        mingo@redhat.com, mjg59@srcf.ucam.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
Message-ID: <20140618151232.GQ24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
 <20140618135229.GH24049@console-pimps.org>
 <53A1B726020000780001B6CF@mail.emea.novell.com>
 <alpine.DEB.2.02.1406181523340.13771@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406181523340.13771@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun, at 03:30:25PM, Stefano Stabellini wrote:
> 
> I was thinking the same thing.
> 
> However this patch series doesn't add much code outside
> drivers/xen/efi.c and include/xen/interface/platform.h.
> I think it wouldn't be fair to ask Daniel to refactor the efi code
> currently under arch/x86 to an arch-independent location.
> Whoever comes in later and adds EFI Xen support for ARM can do that.

I agree that we shouldn't necessarily build tons of arch-independent
infrastructure when there's only one user, but it is wise to be careful
about the design decisions being made if you know there's another user
coming around the corner.

What we don't want to happen, is for the designs that we have now to
become set in stone such that they can never be changed, to the
deteriment of code duplication and maintenance.

I don't think that's happening in this patch series, but it's definitely
smart discussing this stuff upfront.

-- 
Matt Fleming, Intel Open Source Technology Center

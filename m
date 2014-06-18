Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbaFROHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:07:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaFROHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:07:37 -0400
Message-ID: <1403099946.32688.33.camel@deneb.redhat.com>
Subject: Re: [PATCH v5 1/7] efi: Use early_mem*() instead of early_io*()
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Date: Wed, 18 Jun 2014 09:59:06 -0400
In-Reply-To: <20140618121709.GF24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
	 <1402678823-24589-2-git-send-email-daniel.kiper@oracle.com>
	 <20140618121709.GF24049@console-pimps.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 13:17 +0100, Matt Fleming wrote:
> Now, the only difference between early_memremap() and early_ioremap(),
> at least on x86, is PAGE_KERNEL vs. PAGE_KERNEL_IO, where PAGE_KERNEL_IO
> has the additional _PAGE_BIT_IOMAP bit set in the pte. But that's a
> software bit for x86.

I can't comment on the x86 MMU details, but using early_memremap() will
get rid of some sparse warnings in the current code.



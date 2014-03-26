Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaCZNZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:25:41 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:48748 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCZNZk convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:11:3>);
	Wed, 26 Mar 2014 09:25:40 -0400
Message-Id: <5332E3600200007800002597@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 26 Mar 2014 13:25:36 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <david.vrabel@citrix.com>, <ian.campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        <fenghua.yu@intel.com>, <matt.fleming@intel.com>,
        <tony.luck@intel.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>, "Tang Liang" <liang.tang@oracle.com>,
        <eshelton@pobox.com>, <mingo@redhat.com>, <linux-efi@vger.kernel.org>,
        <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH v3 4/5] xen: Define EFI related stuff
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-5-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1395781076-12000-5-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.03.14 at 21:57, <daniel.kiper@oracle.com> wrote:
> Define EFI related stuff for Xen.
> 
> This patch is based on Jan Beulich and Tang Liang work.

And with this, ...

> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> Signed-off-by: Tang Liang <liang.tang@oracle.com>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

... these should be in the reverse order to reflect flow.

> +struct xenpf_efi_runtime_call {
> +	uint32_t function;
> +    /*
> +     * This field is generally used for per sub-function flags (defined
> +     * below), except for the XEN_EFI_get_next_high_monotonic_count case,
> +     * where it holds the single returned value.
> +     */
> +	uint32_t misc;
> +	unsigned long status;
> +	union {

You surely would want to use consistent indentation here (i.e. a leading
hard tab)?

> @@ -143,7 +245,25 @@ struct xenpf_firmware_info {
>  			/* must refer to 128-byte buffer */
>  			GUEST_HANDLE(uchar) edid;
>  		} vbeddc_info; /* XEN_FW_VBEDDC_INFO */
> -

Please retain blank lines like this ...

> +		union xenpf_efi_info {
> +			uint32_t version;
> +			struct {
> +				uint64_t addr;   /* EFI_CONFIGURATION_TABLE */
> +				uint32_t nent;
> +			} cfg;
> +			struct {
> +				uint32_t revision;
> +				uint32_t bufsz;  /* input, in bytes */
> +				GUEST_HANDLE(void) name;
> +				/* UCS-2/UTF-16 string */
> +				} vendor;
> +			struct {
> +				uint64_t addr;
> +				uint64_t size;
> +				uint64_t attr;
> +				uint32_t type;
> +				} mem;
> +		} efi_info; /* XEN_FW_EFI_INFO */

... and add one here.

Jan


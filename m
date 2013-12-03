Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3LCPPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:15:32 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:57991 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3LCPP3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Tue, 3 Dec 2013 10:15:29 -0500
Message-Id: <529E039A02000078001097F5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 03 Dec 2013 15:15:22 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Julien Grall" <julien.grall@linaro.org>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Ian Campbell" <ian.campbell@citrix.com>,
        "Roger Pau Monne" <roger.pau@citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        <patches@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/block: Correctly define structures
 in public headers on ARM32 and ARM64
References: <1386083382-7306-1-git-send-email-julien.grall@linaro.org>
In-Reply-To: <1386083382-7306-1-git-send-email-julien.grall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.12.13 at 16:09, Julien Grall <julien.grall@linaro.org> wrote:
> --- a/include/xen/interface/io/blkif.h
> +++ b/include/xen/interface/io/blkif.h
> @@ -146,7 +146,7 @@ struct blkif_request_segment_aligned {
>  struct blkif_request_rw {
>  	uint8_t        nr_segments;  /* number of segments                   */
>  	blkif_vdev_t   handle;       /* only for read/write requests         */
> -#ifdef CONFIG_X86_64
> +#if defined(CONFIG_X86_64) || defined(CONFIG_ARM) || defined(CONFIG_ARM64)

Perhaps using

#ifndef CONFIG_X86_32

would be the better one, assuming that we won't add further
non-64-bit-clean ABI variants?

Jan


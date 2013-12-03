Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3LCLO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:14:58 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:42646 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3LCLO5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 3 Dec 2013 06:14:57 -0500
Message-Id: <529DCB3C0200007800109502@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 03 Dec 2013 11:14:52 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Roger Pau Monne" <roger.pau@citrix.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Julien Grall" <julien.grall@linaro.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define
 structures in public headers
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.12.13 at 11:57, Roger Pau Monne <roger.pau@citrix.com> wrote:
>  struct blkif_request_rw {
>  	uint8_t        nr_segments;  /* number of segments                   */
>  	blkif_vdev_t   handle;       /* only for read/write requests         */
> -#ifdef CONFIG_X86_64
> -	uint32_t       _pad1;	     /* offsetof(blkif_request,u.rw.id) == 8 */
> -#endif
>  	uint64_t       id;           /* private guest value, echoed in resp  */
>  	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
>  	struct blkif_request_segment {
> @@ -157,47 +154,36 @@ struct blkif_request_rw {
>  		/* @last_sect: last sector in frame to transfer (inclusive).     */
>  		uint8_t     first_sect, last_sect;
>  	} seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> -} __attribute__((__packed__));
> +};

Removing the packed attribute here and below is not possible
as long as the defined structures get used in struct blkif_request
as the second field after a uint8_t one, and as long as the
individual fields here aren't natively aligned.

Jan


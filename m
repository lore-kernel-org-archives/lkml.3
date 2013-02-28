Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3B1LH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:07:29 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:58838 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3B1LH2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 28 Feb 2013 06:07:28 -0500
Message-Id: <512F487D02000078000C1E30@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 28 Feb 2013 11:07:25 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Roger Pau Monne" <roger.pau@citrix.com>
Cc: <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 09/12] xen-blkback: move pending
 handles list from blkbk to pending_req
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-10-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1362047335-26402-10-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
> Moving grant ref handles from blkbk to pending_req will allow us to
> get rid of the shared blkbk structure.

At the expense of (slightly?) higher memory requirements?

> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -136,6 +136,7 @@ struct pending_req {
>  	struct list_head	free_list;
>  	struct persistent_gnt	*persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>  	struct page		*pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> +	grant_handle_t		grant_handles[BLKIF_MAX_SEGMENTS_PER_REQUEST];

Adding yet another array here makes it even more desirable to
switch from multiple arrays to a singly array of a structure, thus
improving locality of the memory accesses involved in processing
an individual segment.

Jan


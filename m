Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3B1LIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:08:54 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:58885 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3B1LIx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 28 Feb 2013 06:08:53 -0500
Message-Id: <512F48D302000078000C1E33@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 28 Feb 2013 11:08:51 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Roger Pau Monne" <roger.pau@citrix.com>
Cc: <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 10/12] xen-blkback: make the queue
 of free requests per backend
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-11-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1362047335-26402-11-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
> @@ -122,6 +125,19 @@ static struct xen_blkif *xen_blkif_alloc(domid_t domid)
>  	spin_lock_init(&blkif->free_pages_lock);
>  	INIT_LIST_HEAD(&blkif->free_pages);
>  	blkif->free_pages_num = 0;
> +	blkif->pending_reqs = kzalloc(sizeof(blkif->pending_reqs[0]) *
> +	                              xen_blkif_reqs, GFP_KERNEL);

kcalloc() is preferred in cases like this, I believe.

Jan


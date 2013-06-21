Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965689Ab3FULqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 07:46:38 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44486 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965496Ab3FULqg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 21 Jun 2013 07:46:36 -0400
Message-Id: <51C4593702000078000DFA44@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 21 Jun 2013 12:46:31 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Roger Pau Monne" <roger.pau@citrix.com>
Cc: <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/4] xen-blkback: check the number of
 iovecs before allocating a bios
References: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
 <1371812216-17093-4-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1371812216-17093-4-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.06.13 at 12:56, Roger Pau Monne <roger.pau@citrix.com> wrote:
> @@ -1236,7 +1236,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
>  				     seg[i].nsec << 9,
>  				     seg[i].offset) == 0)) {
>  
> -			bio = bio_alloc(GFP_KERNEL, nseg-i);
> +			int nr_iovecs = (nseg-i) > BIO_MAX_PAGES ? BIO_MAX_PAGES : (nseg-i);

I'm sure this results in a compiler warning (declaration after
statement).

And it surely would read much better if you used some form of
min() - the shorter line would at once allow you to properly
blank separate operands from operators.

Jan

> +			bio = bio_alloc(GFP_KERNEL, nr_iovecs);
>  			if (unlikely(bio == NULL))
>  				goto fail_put_bio;
>  



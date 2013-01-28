Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab3A1QTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:19:09 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:51447 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3A1QTG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 28 Jan 2013 11:19:06 -0500
Message-Id: <5106B30302000078000BA2A2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 28 Jan 2013 16:18:59 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blkback: Check for insane
 amounts of request on the ring.
References: <1359135152-30688-1-git-send-email-konrad.wilk@oracle.com>
 <1359135152-30688-4-git-send-email-konrad.wilk@oracle.com>
 <20130125184323.GC1384@phenom.dumpdata.com>
 <51066A1202000078000BA020@nat28.tlf.novell.com>
 <20130128154231.GF4838@konrad-lan.dumpdata.com>
In-Reply-To: <20130128154231.GF4838@konrad-lan.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.01.13 at 16:42, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Mon, Jan 28, 2013 at 11:07:46AM +0000, Jan Beulich wrote:
>> >>> On 25.01.13 at 19:43, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> > @@ -764,6 +768,9 @@ __do_block_io_op(struct xen_blkif *blkif)
>> >  	rp = blk_rings->common.sring->req_prod;
>> >  	rmb(); /* Ensure we see queued requests up to 'rp'. */
>> >  
>> > +	if (RING_REQUEST_PROD_OVERFLOW(&blk_rings->common, rp, rc))
>> > +		return -EACCES;
>> 
>> Actually I wonder whether we need the new macro at all: It seems
>> to me that using RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rp)
>> here would achieve the same effect.
> 
> But it would not. The RING_REQUEST_CONS_OVERFLOW only check that the
> non-shared ring entries (rsp_prod and rsp_prod_pvt) are less than
> the size of the ring (32). In other words - they check whether we want
> to process more requests as we still have a back-log of responses to
> deal with.

So did you not notice that here 'rp' (i.e. req_prod) is being passed,
not 'rc'?

Jan


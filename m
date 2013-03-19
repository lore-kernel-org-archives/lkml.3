Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3CSOid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:38:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34108 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab3CSOic convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:38:32 -0400
Date: Tue, 19 Mar 2013 10:38:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        martin.petersen@oracle.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH RFC 12/12] xen-block: implement indirect descriptors
Message-ID: <20130319143825.GA30302@phenom.dumpdata.com>
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-13-git-send-email-roger.pau@citrix.com>
 <5147499E.5080209@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <5147499E.5080209@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 06:06:38PM +0100, Roger Pau Monné wrote:
> On 28/02/13 11:28, Roger Pau Monne wrote:
> > Indirect descriptors introduce a new block operation
> > (BLKIF_OP_INDIRECT) that passes grant references instead of segments
> > in the request. This grant references are filled with arrays of
> > blkif_request_segment_aligned, this way we can send more segments in a
> > request.
> > 
> > The proposed implementation sets the maximum number of indirect grefs
> > (frames filled with blkif_request_segment_aligned) to 256 in the
> > backend and 64 in the frontend. The value in the frontend has been
> > chosen experimentally, and the backend value has been set to a sane
> > value that allows expanding the maximum number of indirect descriptors
> > in the frontend if needed.
> 
> I've added some additional debugging messages in blkfront, and found out
> that the queue in blkfront is not providing request bigger than 64
> segments for read requests, or 128 segments for write requests, although
> I set:
> 
> blk_queue_max_segments(info->rq, 256);
> 
> Is there any other limit I'm missing on the number of segments per
> request a queue can provide?

Martin, any ideas?
> 

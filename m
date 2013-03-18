Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3CRRGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:06:41 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:21636 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab3CRRGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:06:40 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355097600"; 
   d="scan'208";a="2618026"
Message-ID: <5147499E.5080209@citrix.com>
Date: Mon, 18 Mar 2013 18:06:38 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 12/12] xen-block: implement indirect descriptors
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com> <1362047335-26402-13-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1362047335-26402-13-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/13 11:28, Roger Pau Monne wrote:
> Indirect descriptors introduce a new block operation
> (BLKIF_OP_INDIRECT) that passes grant references instead of segments
> in the request. This grant references are filled with arrays of
> blkif_request_segment_aligned, this way we can send more segments in a
> request.
> 
> The proposed implementation sets the maximum number of indirect grefs
> (frames filled with blkif_request_segment_aligned) to 256 in the
> backend and 64 in the frontend. The value in the frontend has been
> chosen experimentally, and the backend value has been set to a sane
> value that allows expanding the maximum number of indirect descriptors
> in the frontend if needed.

I've added some additional debugging messages in blkfront, and found out
that the queue in blkfront is not providing request bigger than 64
segments for read requests, or 128 segments for write requests, although
I set:

blk_queue_max_segments(info->rq, 256);

Is there any other limit I'm missing on the number of segments per
request a queue can provide?


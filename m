Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3BRJFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:05:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3BRJFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:05:40 -0500
Message-ID: <5121EED6.7000307@redhat.com>
Date: Mon, 18 Feb 2013 10:05:26 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Asias He <asias@redhat.com>
CC: linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        mst@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 4/9] virtio-blk: use virtqueue_start_buf on req path
References: <1360671815-2135-1-git-send-email-pbonzini@redhat.com> <1360671815-2135-5-git-send-email-pbonzini@redhat.com> <51207AA1.4090408@redhat.com>
In-Reply-To: <51207AA1.4090408@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/02/2013 07:37, Asias He ha scritto:
>> >  static int __virtblk_add_req(struct virtqueue *vq,
>> > -			     struct virtblk_req *vbr)
>> > +			     struct virtblk_req *vbr,
>> > +			     struct scatterlist *data_sg,
>> > +			     unsigned data_nents)
>> >  {
>> >  	struct scatterlist sg;
>> >  	enum dma_data_direction dir;
>> >  	int ret;
>> >  
>> > +	int type = vbr->out_hdr.type & ~VIRTIO_BLK_T_OUT;
>> >  	unsigned int nents = 2;
>> >  	unsigned int nsg = 2;
>> >  
>> > -	if (vbr->nents) {
>> > +	if (type == VIRTIO_BLK_T_SCSI_CMD) {
>> > +		BUG_ON(use_bio);
> Do we really need the BUG_ON?  Even if with use_bio=1,
> VIRTIO_BLK_T_SCSI_CMD cmd can be fired. See this:

I stand corrected... will send the patch with this removed.

Paolo

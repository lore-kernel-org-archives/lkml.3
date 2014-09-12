Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaILTuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:50:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbaILTuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:50:00 -0400
Message-ID: <54134E50.6040805@redhat.com>
Date: Fri, 12 Sep 2014 21:49:36 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-usb <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION 3.17] scsi (uas) disks no longer using tagged command
 queuing
References: <540EC52C.3000804@redhat.com> <20140909152730.GA17882@infradead.org> <540FFBF4.9090001@redhat.com> <20140910154535.GA5102@infradead.org> <541172E9.8070309@redhat.com> <20140911161331.GA24488@infradead.org>
In-Reply-To: <20140911161331.GA24488@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/11/2014 06:13 PM, Christoph Hellwig wrote:
> On Thu, Sep 11, 2014 at 12:01:13PM +0200, Hans de Goede wrote:
>>> So we're initializing the tag map, but scsi_activate_tcq doesn't pick it
>>> up.  I can't really come up with a good explanation for it, but there
>>> even without that there is an elephant in the room:  as part of the
>>> scsi-mq series I moved the bqt field used for this into a union with the
>>> new blk_mq_tag_set.  Below is a patch to get rid of that union, can you
>>> try if that fixes it?
>>
>> Unfortunately that does not fix it :|
> 
> Alright, I guess we need the big bisect hammer unfortunately.
> 
> We should be able to start with trying the first and last commit
> of the big SCSI merge:
> 
>  start:		fcc95a763444017288b318d48367098850c23c0d
>  end:		c21a2c1a4973c8dde32557970fdb44eaa9489aeb

The bisect points to:

[hans@shalem linux]$ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[d285203cf647d7c97db3a1c33794315c9008593f] scsi: add support for a blk-mq
based I/O path.

I've double checked that that commit is bad, and one commit earlier in the
history is good, so that really is the one.

I've tried again to fix the union thing you spotted, which is introduced
by that commit, and again it does not help.

I've taken a quick look at the commit, and my guess with be this has
something to do with the changes surrounding __scsi_alloc_queue .

Regards,

Hans

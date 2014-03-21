Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbaCUQ0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:26:22 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36034 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaCUQ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:26:19 -0400
Message-ID: <532C67D0.4020501@bjorling.me>
Date: Fri, 21 Mar 2014 09:24:48 -0700
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for open firmware
 SSDs
References: <1395383538-18019-1-git-send-email-m@bjorling.me> <1395383538-18019-2-git-send-email-m@bjorling.me> <20140321153749.GA17155@infradead.org>
In-Reply-To: <20140321153749.GA17155@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 08:37 AM, Christoph Hellwig wrote:
> Just curious:  why do you think implementing this as a block remapper
> inside device mapper is a better idea than as a blk-mq driver?

Hi Christoph,

I imagine the layer to interact with a compatible SSD, that either uses
SATA, NVMe or PCI-e as host interface. My original thought was to use
some of device mapper logic (such as raid, prisoning, etc.) to implement
some of the primitives. Maybe this is overkill, and its better to stuff
it between the blk-mq drivers and the blk-mq layer.

> 
> At the request layer you already get a lot of infrastucture for all the
> queueing infrastructure for free, as well as all kinds of other helpers.
> And the driver never remaps bios anyway but always submits new ones as
> far as I can tell.

Good point.

> 
> Does it even make sense to expose the underlying devices as block
> devices?  It surely would help to send this together with a driver
> that you plan to use it on top of.
> 

Agree, an underlying driver is missing. My first plan is to get a draft
firmware for the OpenSSD to be stable and expose its primitives
(read/write/erase) up through the ATA/SCSI stack. Communicating using
vendor specific codes.

- Matias


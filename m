Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaCYDpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 23:45:30 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:39735 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaCYDp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 23:45:28 -0400
Message-ID: <5330FBD5.5000103@bjorling.me>
Date: Mon, 24 Mar 2014 20:45:25 -0700
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Akira Hayakawa <hayakawa@valinux.co.jp>,
        device-mapper development <dm-devel@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, snitzer@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        agk@redhat.com
Subject: Re: [dm-devel] [PATCH RFC v1 01/01] dm-lightnvm: An open FTL for
 open firmware SSDs
References: <1395383538-18019-1-git-send-email-m@bjorling.me>	<1395383538-18019-2-git-send-email-m@bjorling.me>	<20140321153749.GA17155@infradead.org>	<532C67D0.4020501@bjorling.me> <20140325112217.a3d34601d745ace3fbc07c0f@valinux.co.jp>
In-Reply-To: <20140325112217.a3d34601d745ace3fbc07c0f@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2014 07:22 PM, Akira Hayakawa wrote:
> Hi, Matias,
> 
> Sorry for jumping in. I am interested in this new feature, too.
> 
>>> Does it even make sense to expose the underlying devices as block
>>> devices?  It surely would help to send this together with a driver
>>> that you plan to use it on top of.
>>>
>>
>> Agree, an underlying driver is missing. My first plan is to get a draft
>> firmware for the OpenSSD to be stable and expose its primitives
>> (read/write/erase) up through the ATA/SCSI stack. Communicating using
>> vendor specific codes.
> 

Hi Akira,

Indeed. Most of Mohit's work can be applied with this layer. In the same
breath we could also look into nameless writes. It would up open for a
new design for co-operating file systems.

> Exposing FTL to the host layer has potential to share mapping in cache software (or driver) and the device.
> The "Unified Address Space" in the slides below addresses the problem of two levels of indirection.
> http://www1.unine.ch/eurosys2012/posters/saxena.pdf
> 
> Developing API to share mapping between driver and the device sounds interesting, too.
> 
> --
> Akira
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


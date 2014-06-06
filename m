Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaFFK6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbaFFK6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:58:32 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org, felipe.franciosi@citrix.com,
        roger.pau@citrix.com, jerry.snitselaar@oracle.com, axboe@kernel.dk
Subject: Re: Backport request to stable of two performance related fixes for xen-blkfront (3.13 fixes to earlier trees)
References: <20140514191122.GA7659@phenom.dumpdata.com>
	<20140604054848.GA20895@kroah.com> <53919C2B.6080606@suse.cz>
Date: Fri, 06 Jun 2014 12:58:20 +0200
In-Reply-To: <53919C2B.6080606@suse.cz> (Jiri Slaby's message of "Fri, 06 Jun
	2014 12:47:07 +0200")
Message-ID: <87mwdqjodv.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> On 06/04/2014 07:48 AM, Greg KH wrote:
>> On Wed, May 14, 2014 at 03:11:22PM -0400, Konrad Rzeszutek Wilk wrote:
>>> Hey Greg
>>>
>>> This email is in regards to backporting two patches to stable that
>>> fall under the 'performance' rule:
>>>
>>>  bfe11d6de1c416cea4f3f0f35f864162063ce3fa
>>>  fbe363c476afe8ec992d3baf682670a4bd1b6ce6
>> 
>> Now queued up, thanks.
>
> AFAIU, they introduce a performance regression.
>
> Vitaly?

I'm aware of a performance regression in a 'very special' case when
ramdisks or files on tmpfs are being used as storage, I post my results
a while ago:
https://lkml.org/lkml/2014/5/22/164
I'm not sure if that 'special' case requires investigation and/or should
prevent us from doing stable backport but it would be nice if someone
tries to reproduce it at least.

I'm going to make a bunch of tests with FusionIO drives and sequential
read to replicate same test Felipe did, I'll report as soon as I have
data (beginning of next week hopefuly).

-- 
  Vitaly

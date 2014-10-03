Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaJCTGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 15:06:47 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbaJCTGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 15:06:44 -0400
Message-ID: <542EF3BF.1070401@nod.at>
Date: Fri, 03 Oct 2014 21:06:39 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
References: <1412029248-22454-1-git-send-email-richard@nod.at>	 <1412029248-22454-4-git-send-email-richard@nod.at> <1412346676.3795.62.camel@sauron.fi.intel.com>
In-Reply-To: <1412346676.3795.62.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.10.2014 16:31, schrieb Artem Bityutskiy:
> On Tue, 2014-09-30 at 00:20 +0200, Richard Weinberger wrote:
>> +
>> +	for (i = 0; i < UBI_PROT_QUEUE_LEN; i++) {
>> +		list_for_each_entry(wl_e, &ubi->pq[i], u.list) {
>> +			fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
> 
> Similarly to my other posts, is it possible to not touch the WL-internal
> things like 'ubi->pq[]' from fastmap.c? Can we come up with a function
> at wl.c which fastmap.c could call instead?

Fastmap needs basically access to all internal state of UBI, which lives mostly
within wl.c
It needs to iterate over the used, free, erase, scrub RB-trees, the protection queue, etc. to
collect the exact state of all PEBs.

In C++ or Java I would pass an iterator to fastmap.c using a function in wl.c but I'm not sure
how to do such a thing in a sane way in C.

What about having a wl-fastmap.c file which acts as glue layer between fastmap.c and wl.c?

Thanks,
//richard

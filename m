Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaKEPra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:47:30 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbaKEPr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:47:29 -0500
Message-ID: <545A4688.8020708@nod.at>
Date: Wed, 05 Nov 2014 16:47:20 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Subject: Re: [PATCH 05/35] UBI: Fastmap: Ensure that only one fastmap work
 is scheduled
References: <1414586758-9972-1-git-send-email-richard@nod.at>	 <1414586758-9972-6-git-send-email-richard@nod.at> <1415202120.958.123.camel@sauron.fi.intel.com>
In-Reply-To: <1415202120.958.123.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.11.2014 um 16:42 schrieb Artem Bityutskiy:
> On Wed, 2014-10-29 at 13:45 +0100, Richard Weinberger wrote:
>>  	struct ubi_device *ubi = container_of(wrk, struct ubi_device, fm_work);
>>  	ubi_update_fastmap(ubi);
>> +	spin_lock(&ubi->wl_lock);
>> +	ubi->fm_work_scheduled = 0;
>> +	spin_unlock(&ubi->wl_lock);
>>  }
> 
> Why is the 'update_fastmap_work_fn()' function in wl.c? Can we move it
> to fastmap.c?
> 

Please see "[PATCH 29/35] UBI: Move fastmap specific functions out of wl.c".

Thanks,
//richard

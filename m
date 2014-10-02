Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaJBNS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:18:28 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbaJBNS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:18:26 -0400
Message-ID: <542D50A0.1080802@nod.at>
Date: Thu, 02 Oct 2014 15:18:24 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] UBI: Ensure that all fastmap work is done upon WL
 shutdown
References: <1412029248-22454-1-git-send-email-richard@nod.at> <1412029248-22454-2-git-send-email-richard@nod.at> <542D4D95.6000503@codeaurora.org>
In-Reply-To: <542D4D95.6000503@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.10.2014 15:05, schrieb Tanya Brokhman:
>> +#ifdef CONFIG_MTD_UBI_FASTMAP
>> +    flush_work(&ubi->fm_work);
> 
> flush_work returns bool. It might be useful to print that value for debugging.

Why would this be useful?
The sole purpose of this flush is having a barrier.
If flush_work() had to wait (returns true) for a pending work, fine.
If where was no work (returns false) to wait for, also fine. :)

Thanks,
//richard

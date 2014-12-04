Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaLDLEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:04:36 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaLDLEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:04:35 -0500
Message-ID: <54803FC0.7080305@nod.at>
Date: Thu, 04 Dec 2014 12:04:32 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/35] UBI: Fix stale pointers in ubi->lookuptbl
References: <1414586758-9972-1-git-send-email-richard@nod.at> <1414586758-9972-3-git-send-email-richard@nod.at> <54803EBF.9060609@codeaurora.org>
In-Reply-To: <54803EBF.9060609@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tanya,

Am 04.12.2014 um 12:00 schrieb Tanya Brokhman:
> Hi Richard
> 
> On 10/29/2014 2:45 PM, Richard Weinberger wrote:
>> In some error paths the WL sub-system gives up on a PEB
>> and frees it's ubi_wl_entry struct but does not set
>> the entry in ubi->lookuptbl to NULL.
>> Fastmap can stumble over such a stale pointer as it uses
>> ubi->lookuptbl to find all PEBs.
>>
>> Fix this by setting the pointers to free'd ubi_wl_entry to NULL.
> 
> There are 2 more places:
> tree_destroy() and protection_queue_destroy() where ubi_wl_entry is released. Both functions used on power down so all should be good as is, just wanted to make sure you didn't add
> ubi->lookuptbl[e2->pnum] = NULL there on purpose.

I fear you're looking at the old patch series.
Please have a look at:
"[PATCH 3/6] UBI: Fix stale pointers in ubi->lookuptbl" sent on 30.11.2014.

Thanks,
//richard

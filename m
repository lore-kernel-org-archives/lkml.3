Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbaIOW5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:57:24 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41672 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406AbaIOW5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:57:21 -0400
Message-ID: <54176ECD.8090807@gmail.com>
Date: Tue, 16 Sep 2014 06:57:17 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] drivers/xen/xenbus/xenbus_client.c: Improve the failure
 processing for __xenbus_switch_state()
References: <54157282.40402@gmail.com> <5415737D.2030209@gmail.com> <5416FA0C.6090703@citrix.com>
In-Reply-To: <5416FA0C.6090703@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 10:39 PM, David Vrabel wrote:
> On 14/09/14 11:52, Chen Gang wrote:
>> When failure occurs, need return failure code instead of 0, or the upper
>> caller will misunderstand.
>>
>> Also when retry for EAGAIN reason, better to schedule out for a while,
>> so can let others have chance to continue their tasks (especially,
>> their tasks are related EAGAIN under UP kernel).
> 
> Is this fixing a real world problem you have seen?
> 

Not real world, only reading by source code, and some of upper level
callers really check the return value, indirectly (they may
misunderstand).

> xenbus_scanf() and xenbus_printf() already sleep while waiting for the
> response and delaying isn't going to reduce the likelihood of the
> transaction being aborted on the retry.
> 

OK, thanks, what you said sound reasonable to me, I shall remove the
waiting code when send patch v2 for it.


I shall try to send patch v2 within this week end (2014-09-21), if it is
too late to bare, please let me know (I shall try in time).

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed

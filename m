Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaIVPv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:51:26 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51265 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaIVPvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:51:25 -0400
Message-ID: <5420456C.4010103@gmail.com>
Date: Mon, 22 Sep 2014 23:51:08 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3 v2] xen/xenbus: Improve failure processing
 code for __xenbus_switch_state()
References: <541AE4E9.2040904@gmail.com> <541AE5C4.2070409@gmail.com> <54203A73.8030103@citrix.com>
In-Reply-To: <54203A73.8030103@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 11:04 PM, David Vrabel wrote:
> On 18/09/14 15:01, Chen Gang wrote:
>> When failure occurs, need return failure code instead of 0, or some of
>> indirect upper callers may misunderstand.
>>
>> e.g. in "block/xen-blkback/xenbus.c":
>>
>>     connect() -> xenbus_switch_state() -> __xenbus_switch_state().
> 
> Can you make xenbus_switch_state() void?  The callers don't need to do
> any error handling.
> 

After "grep rn xenbus_switch_state *" under "drivers/", it is not one
place to check the return value of xenbus_switch_state(), and also it
is export to outside for individual modules.

So we need change many subsystems for it, and also need face the rick
for incompatible with the old individual modules which source code are
not in upstream.

And are you sure the caller need not notice about it, when it really
fails? (for me, I guess they need notice about it)

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed

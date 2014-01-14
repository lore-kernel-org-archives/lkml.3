Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaANCLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 21:11:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46865 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaANCLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 21:11:12 -0500
Message-ID: <52D49CD5.20805@oracle.com>
Date: Mon, 13 Jan 2014 21:11:33 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: konrad.wilk@oracle.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com
Subject: Re: [PATCH] xen-blkfront: remove type check from blkfront_setup_discard
References: <1389371301-29532-1-git-send-email-olaf@aepfle.de> <52D036FC.6000308@oracle.com> <20140110213746.GA933@aepfle.de> <52D073F0.5020400@oracle.com> <20140113093032.GA13919@aepfle.de> <52D3FD67.2060708@oracle.com> <20140113230740.GA23544@aepfle.de>
In-Reply-To: <20140113230740.GA23544@aepfle.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 06:07 PM, Olaf Hering wrote:
> On Mon, Jan 13, Boris Ostrovsky wrote:
>
>> On 01/13/2014 04:30 AM, Olaf Hering wrote:
>>>> Similarly, if xenbug_gather("discard-secure") fails, I think the code will
>>>> assume that secure discard has not been requested. I don't know what
>>>> security implications this will have but it sounds bad to me.
>>> There are no security implications, if the backend does not advertise it
>>> then its not present.
>> Right. But my questions was what if the backend does advertise it and wants
>> the frontent to use it but xenbus_gather() in the frontend fails. Do we want
>> to silently continue without discard-secure? Is this safe?
> The frontend can not know that the backend advertised discard-secure
> because the frontend just failed to read the property which indicates
> discard-secure should be enabled.

And is it OK for the frontend not to know about this?

I don't understand what the use model for this feature is. Is it just 
that the backend advertises its capability and it's up to the frontend 
to use it or not -or- is it that the user/admin created the storage with 
expectations that it will be used in "secure" manner.

I think if it's the former then losing information about storage 
features is OK but if it's the latter then I am not so sure.

Or perhaps it's neither of these two and I am completely missing the 
point of this feature.

-boris


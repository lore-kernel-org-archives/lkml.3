Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaANKqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:46:36 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:35380 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaANKqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:46:32 -0500
X-IronPort-AV: E=Sophos;i="4.95,658,1384300800"; 
   d="scan'208";a="90497470"
Message-ID: <52D51586.3020508@citrix.com>
Date: Tue, 14 Jan 2014 10:46:30 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: Olaf Hering <olaf@aepfle.de>, <konrad.wilk@oracle.com>,
        <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-blkfront: remove type check from blkfront_setup_discard
References: <1389371301-29532-1-git-send-email-olaf@aepfle.de> <52D036FC.6000308@oracle.com> <20140110213746.GA933@aepfle.de> <52D073F0.5020400@oracle.com> <20140113093032.GA13919@aepfle.de> <52D3FD67.2060708@oracle.com> <20140113230740.GA23544@aepfle.de> <52D49CD5.20805@oracle.com>
In-Reply-To: <52D49CD5.20805@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/14 02:11, Boris Ostrovsky wrote:
> On 01/13/2014 06:07 PM, Olaf Hering wrote:
>> On Mon, Jan 13, Boris Ostrovsky wrote:
>>
>>> On 01/13/2014 04:30 AM, Olaf Hering wrote:
>>>>> Similarly, if xenbug_gather("discard-secure") fails, I think the
>>>>> code will
>>>>> assume that secure discard has not been requested. I don't know what
>>>>> security implications this will have but it sounds bad to me.
>>>> There are no security implications, if the backend does not
>>>> advertise it
>>>> then its not present.
>>> Right. But my questions was what if the backend does advertise it and
>>> wants
>>> the frontent to use it but xenbus_gather() in the frontend fails. Do
>>> we want
>>> to silently continue without discard-secure? Is this safe?
>> The frontend can not know that the backend advertised discard-secure
>> because the frontend just failed to read the property which indicates
>> discard-secure should be enabled.
> 
> And is it OK for the frontend not to know about this?

Yes.

> I don't understand what the use model for this feature is. Is it just
> that the backend advertises its capability and it's up to the frontend
> to use it or not -or- is it that the user/admin created the storage with
> expectations that it will be used in "secure" manner.

The creator of the data (i.e., the guest) is the one who knows whether
the data is security sensitive.  The backend is simply providing the
facility which the guest may or may not make use of.

David

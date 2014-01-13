Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaAWAoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:44:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38512 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbaAWAoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:44:09 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <52D3FF0E02000078001131A5@nat28.tlf.novell.com>
References: <1389608052-7139-1-git-send-email-olaf@aepfle.de> <52D3DAEE0200007800112FD4@nat28.tlf.novell.com> <20140113120131.GA15623@aepfle.de> <52D3EB5F02000078001130B5@nat28.tlf.novell.com> <1389618054.13654.57.camel@kazak.uk.xensource.com> <52D3F535020000780011311B@nat28.tlf.novell.com> <52D3EE14.3080609@citrix.com> <52D3FF0E02000078001131A5@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [Xen-devel] [PATCH v2] xen-blkfront: remove type check from blkfront_setup_discard
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 13 Jan 2014 10:57:54 -0500
To: Jan Beulich <JBeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>
CC: boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>, Ian Campbell <Ian.Campbell@citrix.com>,
        xen-devel@lists.xen.org
Message-ID: <9498309b-dd60-413f-9ab7-8e6ec6c9bcfa@email.android.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 13.01.14 at 14:45, David Vrabel <david.vrabel@citrix.com> wrote:
>> On 13/01/14 13:16, Jan Beulich wrote:
>>>>>> On 13.01.14 at 14:00, Ian Campbell <Ian.Campbell@citrix.com>
>wrote:
>>>> On Mon, 2014-01-13 at 12:34 +0000, Jan Beulich wrote:
>>>>>>>> On 13.01.14 at 13:01, Olaf Hering <olaf@aepfle.de> wrote:
>>>>>> On Mon, Jan 13, Jan Beulich wrote:
>>>>>>
>>>>>>> You can't do this in one go - the first two and the last one may
>be
>>>>>>> set independently (and are independent in their meaning), and
>>>>>>> hence need to be queried independently (xenbus_gather() fails
>>>>>>> on the first absent value).
>>>>>>
>>>>>> Yes, thats the purpose. Since the properties are required its an
>all or
>>>>>> nothing thing. If they are truly optional then blkif.h should be
>updated
>>>>>> to say that.
>>>>>
>>>>> They _are_ optional.
>>>>
>>>> But is it true that either they are all present or they are all
>absent?
>>> 
>>> No, it's not. discard-secure is independent of the other two (but
>>> those other two are tied together).
>> 
>> Can we have a patch to blkif.h that clarifies this?
>> 
>> e.g.,
>> 
>> feature-discard
>> 
>>    ...
>> 
>>    discard-granularity and discard-offset must also be present if
>>    feature-discard is enabled
>
>It would be "may" here too afaict. But I'll defer to Konrad, who
>has done more work in this area...
>
>Jan
>
>>    discard-secure may also be present if feature-discard is enabled.
>> 
>> David
>
>
>
>
>_______________________________________________
>Xen-devel mailing list
>Xen-devel@lists.xen.org
>http://lists.xen.org/xen-devel

It is all 'may'. If there is just 'feature-discard' without any other options that is OK.


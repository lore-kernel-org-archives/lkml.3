Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaAMNqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 08:46:00 -0500
Received: from smtp.citrix.com ([66.165.176.89]:3055 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaAMNp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 08:45:58 -0500
X-IronPort-AV: E=Sophos;i="4.95,653,1384300800"; 
   d="scan'208";a="92298949"
Message-ID: <52D3EE14.3080609@citrix.com>
Date: Mon, 13 Jan 2014 13:45:56 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>, Olaf Hering <olaf@aepfle.de>,
        <xen-devel@lists.xen.org>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v2] xen-blkfront: remove type check from blkfront_setup_discard
References: <1389608052-7139-1-git-send-email-olaf@aepfle.de> <52D3DAEE0200007800112FD4@nat28.tlf.novell.com> <20140113120131.GA15623@aepfle.de> <52D3EB5F02000078001130B5@nat28.tlf.novell.com> <1389618054.13654.57.camel@kazak.uk.xensource.com> <52D3F535020000780011311B@nat28.tlf.novell.com>
In-Reply-To: <52D3F535020000780011311B@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/14 13:16, Jan Beulich wrote:
>>>> On 13.01.14 at 14:00, Ian Campbell <Ian.Campbell@citrix.com> wrote:
>> On Mon, 2014-01-13 at 12:34 +0000, Jan Beulich wrote:
>>>>>> On 13.01.14 at 13:01, Olaf Hering <olaf@aepfle.de> wrote:
>>>> On Mon, Jan 13, Jan Beulich wrote:
>>>>
>>>>> You can't do this in one go - the first two and the last one may be
>>>>> set independently (and are independent in their meaning), and
>>>>> hence need to be queried independently (xenbus_gather() fails
>>>>> on the first absent value).
>>>>
>>>> Yes, thats the purpose. Since the properties are required its an all or
>>>> nothing thing. If they are truly optional then blkif.h should be updated
>>>> to say that.
>>>
>>> They _are_ optional.
>>
>> But is it true that either they are all present or they are all absent?
> 
> No, it's not. discard-secure is independent of the other two (but
> those other two are tied together).

Can we have a patch to blkif.h that clarifies this?

e.g.,

feature-discard

   ...

   discard-granularity and discard-offset must also be present if
   feature-discard is enabled

   discard-secure may also be present if feature-discard is enabled.

David

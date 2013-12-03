Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3LCPLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:11:39 -0500
Received: from smtp.citrix.com ([66.165.176.89]:19831 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab3LCPLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:11:38 -0500
X-IronPort-AV: E=Sophos;i="4.93,818,1378857600"; 
   d="scan'208";a="80124264"
Message-ID: <529DF4A0.50103@citrix.com>
Date: Tue, 3 Dec 2013 15:11:28 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>		 <529DBA07.6090108@citrix.com>	 <1386068884.13256.9.camel@kazak.uk.xensource.com>	 <529DC7BA.7080506@citrix.com> <1386078108.13256.30.camel@kazak.uk.xensource.com>
In-Reply-To: <1386078108.13256.30.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/13 13:41, Ian Campbell wrote:
> On Tue, 2013-12-03 at 11:59 +0000, David Vrabel wrote:
>> On 03/12/13 11:08, Ian Campbell wrote:
>>> On Tue, 2013-12-03 at 11:01 +0000, David Vrabel wrote:
>>>> On 03/12/13 10:57, Roger Pau Monne wrote:
>>>>> Using __packed__ on the public interface is not correct, this
>>>>> structures should be compiled using the native ABI, and __packed__
>>>>> should only be used in the backend counterpart of those structures
>>>>> (which needs to handle different ABIs).
>>>>>
>>>>> This was even worse in the ARM case, where the Linux kernel was
>>>>> incorrectly using the X86_32 protocol ABI. This patch fixes it, but
>>>>> also breaks compatibility, so an ARM DomU kernel compiled with
>>>>> this patch will fail to communicate with PV disk devices unless the
>>>>> Dom0 also has this patch.
>>>>
>>>> This ABI change needs to be justified.  Why do you think it is
>>>> acceptable to break existing Linux guests?  Because I don't think it is.
>>>
>>> As I explained in my reply those guests are buggy.
>>
>> The kernel has a strong policy on not changing ABIs, even to fix bugs.
>> I don't think a bug fix alone is sufficient justification for ABI breakage.
> 
> This is not the kernels ABI to fix in stone. The ABI is defined by the
> upstream Xen project and Linux has failed to follow the specified ABI
> correctly.

I disagree. The working back and front end implementations have created
a new, different ABI.

> There is no deployed legacy of guests to support here.

I not sure I agree. It does seem to be widely used and I'm not sure we
have sufficient visibility on how Xen on Arm is being used to know if
this change will cause other people problems.

If Konrad and Boris agree that breaking the kernel's ABI in this way is
acceptable in this specific case, I'll defer to them.

David

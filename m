Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab3GaNbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:31:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60427 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759710Ab3GaNbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:31:08 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-bf-51f9119a9f8b
Message-id: <51F91195.1020904@partner.samsung.com>
Date: Wed, 31 Jul 2013 15:31:01 +0200
From: Piotr Sarna <p.sarna@partner.samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, ngupta@vflare.org,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH 1/2] staging: zram: add Crypto API support
References: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
 <20130730135333.GB27962@kroah.com> <51F8E404.6070507@partner.samsung.com>
 <20130731124950.GB30635@kroah.com>
In-reply-to: <20130731124950.GB30635@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQd1Zgj8DDRrfq1tsnLGe1WLPmV/s
	Fs2L17NZnG16w25xedccNosNLbPYHdg87u07zOKxf+4ado++LasYPXZ+2szq8XmTXABrFJdN
	SmpOZllqkb5dAldGy+k3TAX7hCqaPjQxNzDu4+ti5OSQEDCRaFq2nRXCFpO4cG89WxcjF4eQ
	wHRGidn7r7JCOK8ZJXY8XQpWxStgJHGm/T4ziM0ioCrxp70PLM4moC/x5foali5GDg5RgQiJ
	o8s1IcoFJX5MvscCYosIaEi8PHqLBWQms8A0RonpDz+CzREWsJNYc3AjM8Sy3YwS/UevgQ3l
	BBp6dOotMJtZQEdif+s0NghbXmLzmrfMExgFZiFZMgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525iBIf3M+kdjKsaLA4xCnAwKvHwzrj0PVCINbGsuDL3EKMEB7OSCO8e1p+B
	QrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhh93GdeqLW5
	tLrwwomteT/ZSqv3Od+Ourv60UeZ5wLXFPK3/O944rJvd+bR0oXCOlfmrHuyIq424cWPO9pJ
	greMJRzltkXcz8lw2/qcx86yjIdX5TLnjGC9e3b/GUMs+fJk7jze/e2UcakRn5vr/X0Kj//L
	bHBZYX+N68GDlUIu5f/aZ37/o39AiaU4I9FQi7moOBEA20pdimsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 02:49 PM, Greg KH wrote:
> On Wed, Jul 31, 2013 at 12:16:36PM +0200, Piotr Sarna wrote:
>> Hi,
>>
>> On 07/30/2013 03:53 PM, Greg KH wrote:
>>> On Tue, Jul 30, 2013 at 02:30:48PM +0200, Piotr Sarna wrote:
>>>> Current version of zram does not allow any substitution of a default
>>>> compression algorithm. Therefore, I decided to change the existing
>>>> implementation of page compression by adding Crypto API compability.
>>>
>>> As I have stated before, I want this code to get merged out of the
>>> drivers/staging/ area _before_ any new features get added to it.  People
>>> are taking too much time adding new stuff, like this, and no one seems
>>> to be working to get it merged to the proper place anymore.
>>>
>>
>> OK, but we actually need those features in order to test zram
>> against other, competitive solutions - and then decide whether
>> and how to merge it out of /drivers/staging.
> 
> Where is another "competitive solution" in the kernel?
> 
> And you are implying that as-is, zram isn't acceptable, right?  If so, I
> should just delete it now as I was originally told otherwise, that's why
> I merged it :(
> 
>>> So again, I'm going to have to say no to a new feature here, sorry.
>>> zcache, zram, and zsmalloc need to get cleaned up and merged out of
>>> staging before anything new can be added to them.
>>>
>>> Or, if no one is working on that, I guess I can just delete them,
>>> right?...
>>>
>>
>> Is there any official TODO list of cleaning up and merging out zram?
> 
> As it came from the "zswap" code, there doesn't seem to be one :(
> 
> The code is over 2 years old now, with no percieved movement out of
> staging.  If it doesn't get fixed up in the next kernel version or so, I
> will have to remove it entirely.
> 
> sorry,
> 
> greg k-h
> 

"Another competitive solutions" I thought of were zswap and zcache.

On one hand, during my tests (of compressed swap feature), zram
turned out to be no faster than zswap/zcache (but no slower either).

On the other, zram happens to have some more, perhaps reasonable
use cases (described in zram.txt), e.g. mounting it as /tmp.

So far, I haven't tested those other features of zram,
so I can't possibly say whether it should be considered for a merge-out
or kept in staging for now.

Regards,
Piotr Sarna

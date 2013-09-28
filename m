Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3I1Hou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 03:44:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55200 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3I1Hos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 03:44:48 -0400
Message-ID: <524688CB.9000400@vlnb.net>
Date: Sat, 28 Sep 2013 00:44:11 -0700
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Zuckerman, Boris" <borisz@hp.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        "rob.gittins@linux.intel.com" <rob.gittins@linux.intel.com>,
        "linux-pmfs@lists.infradead.org" <linux-pmfs@lists.infradead.org>,
        "linux-fsdevel@veger.org" <linux-fsdevel@veger.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com> <522AB5AD.6070206@vlnb.net> <1379976688.5886.12.camel@Virt-Centos-6.lm.intel.com> <5243DB2A.7090609@vlnb.net> <4C30833E5CDF444D84D942543DF65BDA58066A30@G9W0739.americas.hpqcorp.net> <20130926175624.GA7422@linux.intel.com> <4C30833E5CDF444D84D942543DF65BDA580690B7@G9W0739.americas.hpqcorp.net>
In-Reply-To: <4C30833E5CDF444D84D942543DF65BDA580690B7@G9W0739.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:DXIOW1MX9CU/ywi4AQcT99pzEm3cqD2q1suN2kQ+oLM
 QfNaSDMjQ1MaDgHXsqweyzh+Tl69wel1E5ed1JuYYgJ+PymikG
 U+3npNpGLiatualWWhHLsOhI7B6GBVYtEMjxo2r8nUOvfiWKfF
 oUxxbMQa0IxLOojhmvuEF6gFBGg6bhAezAAWcw11tGixeljTW1
 0bO/Lsau/ytUXtywRibxDl4Wrsoo40f6NzYx4Fd0tCu/qUEEGK
 mPFZ5IaLW8deumHt62pqVGQp4tpTWro7zfo3diEFhjLtU5hnDH
 CVlCIXzxuDosm8SeQNbSyrY4DV9aqJj9QMhWErikQtmmDvTfA=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zuckerman, Boris, on 09/26/2013 12:36 PM wrote:
> I assume that we may have both: CPUs that may have ability to support multiple transactions, CPUs that support only one, CPUs that support none (as today), as well as different devices - transaction capable and not.
> So, it seems there is a room for compilers to do their work and for class drivers to do their, right?

Yes, correct.

Conceptually NVDIMMs are not block devices. They may be used as block devices, but may
not be as well. So, nailing them into the block abstraction by big hammer is simply a
bad design.

Vlad

> boris
> 
>> -----Original Message-----
>> From: Matthew Wilcox [mailto:willy@linux.intel.com]
>> Sent: Thursday, September 26, 2013 1:56 PM
>> To: Zuckerman, Boris
>> Cc: Vladislav Bolkhovitin; rob.gittins@linux.intel.com; linux-pmfs@lists.infradead.org;
>> linux-fsdevel@veger.org; linux-kernel@vger.kernel.org
>> Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
>>
>> On Thu, Sep 26, 2013 at 02:56:17PM +0000, Zuckerman, Boris wrote:
>>> To work with persistent memory as efficiently as we can work with RAM we need a
>> bit more than "commit". It's reasonable to expect that we get some additional
>> support from CPUs that goes beyond mfence and mflush. That may include discovery,
>> transactional support, etc. Encapsulating that in a special class sooner than later
>> seams a right thing to do...
>>
>> If it's something CPU-specific, then we wouldn't handle it as part of the "class", we'd
>> handle it as an architecture abstraction.  It's only operations which are device-specific
>> which would need to be exposed through an operations vector.  For example, suppose
>> you buy one device from IBM and another device from HP, and plug them both into
>> your SPARC system.  The code you compile needs to run on SPARC, doing whatever
>> CPU operations are supported, but if HP and IBM have different ways of handling a
>> "commit" operation, we need that operation to be part of an operations vector.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3A1PU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:20:27 -0500
Received: from mga07.intel.com ([143.182.124.22]:40159 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751720Ab3A1PUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:20:23 -0500
MIME-Version: 1.0
In-Reply-To: <20130128151527.GA5868@redhat.com>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
	<53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com>
	<1358895228.2408.14.camel@falcor1>
	<CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
	<20130125210157.GA13152@redhat.com>
	<CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
	<20130128151527.GA5868@redhat.com>
Date: Mon, 28 Jan 2013 17:20:20 +0200
Message-ID: <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric keys
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, dhowells@redhat.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 5:15 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Jan 28, 2013 at 04:54:06PM +0200, Kasatkin, Dmitry wrote:
>> On Fri, Jan 25, 2013 at 11:01 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Hi,
>> >
>> > I am trying to read and understand IMA code. How does digital signature
>> > mechanism work.
>> >
>> > IIUC, evmctl will install a file's signature in security.ima. And later
>> > process_measurement() will do following.
>> >
>> > Calculate digest of file in ima_collect_measurement() and then
>> > ima_appraise_measurement() actually compares signatuer against the
>> > digest.
>> >
>> > If yes, ima_collect_measurement() always calculates digest either using
>> > md5/sha1 but signatures might have used sha256 or something else. So
>> > how does it work. What am I missing.
>>
>> Hi,
>>
>> Yes, currently it is possible to use only single configured algorithm, which is
>> in generally enough. Consider it like a policy.
>> Soon it will be a patch which allows to use any hash algorithms, supported by
>> asymmetric key verification API.
>
> Ok. I am hoping that it will be more than the kernel command line we
> support. In the sense that for digital signatures one needs to parse
> the signature, look at what hash algorithm has been used  and then
> collect the hash accordingly. It is little different then IMA requirement
> of calculating one pre-determine hash for all files.

Yes... It is obvious. It's coming.
But in general, signer should be aware of requirements and limitation
of the platform.
It is not really a problem...

- Dmitry

>
> Thanks
> Vivek

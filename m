Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161122AbaJ3T4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:56:55 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25308 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072AbaJ3T4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:56:53 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-32-5452980126de
Message-id: <545297CC.6020306@samsung.com>
Date: Thu, 30 Oct 2014 20:55:56 +0100
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Organization: Samsung Poland R&D Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Icedove/31.1.2
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org,
        David Herrmann <dh.herrmann@gmail.com>, Paul Moore <pmoore@redhat.com>,
        "casey.schaufler@intel.com" <casey.schaufler@intel.com>,
        marcel@holtmann.org, tixxdz@opendz.org,
        javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk
Subject: Re: [PATCH 00/12] Add kdbus implementation
References: <54520A21.20404@samsung.com> <54521697.1030900@samsung.com>
 <20141030144709.GA19721@kroah.com>
In-reply-to: <20141030144709.GA19721@kroah.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t/xa7qMM4JCDPassrC4svUIk8XfScfY
	LW6sWMBk0fT3FYtF9zUWi3mtR1ksmhevZ7M4+rvAYvecxSwWZ37rWmz+3sFmcXnXHDaLb59+
	MVp8vvaL3aJ9xW1Gi5W/t7NZ/Fp+lNFB0OP3r0mMHn+fX2fxuDGrg9Vj56y77B7rdy9n91i8
	5yWTx6ZVnWwed67tYfPYP3cNu8eKX0fYPd7vu8rmcWYBkPV5k5zH9t3LWQL4orhsUlJzMstS
	i/TtErgyvp06yVbQI1zRNKeFsYFxJ38XIyeHhICJxLVDd9khbDGJC/fWs3UxcnEICSxllDj9
	/D4rSEJI4BOjxOoFHCA2r4CWxKTOn0wgNouAqsSGCV1gzWwCRhLfDm1gBrH5BdQl3m17ClYj
	KhAi0XqlhQ2iV1Dix+R7LCC2iICxRP/ZWewgy5gFFrBIHPx9EKxBGCgx6cQbRojFORJn1/4H
	szkF9CUmfl0MdBAHUIO6xJQpuSBhZgF5ic1r3jJPYBSchWTFLISqWUiqFjAyr2IUTS1NLihO
	Ss810itOzC0uzUvXS87P3cQIidmvOxiXHrM6xCjAwajEwxtxLCBEiDWxrLgy9xCjBAezkgiv
	V3dQiBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGfZ7Lz7vzYucsWRCfsuSSzjNn+9TEhVfszxYw
	llvfXW7poZW++CNTioTGl1QdXgvpsmbdxS1zHPbdvGW9+wJ3RJKpDE/V/mmbE0LTT739q3pw
	994H4WWWMy7UHbRYt1RPL+HugrIrdbsDdCRXfyl7fmPRoRSNU9WfBVcvejldatqz8FvzZhnq
	KLEUZyQaajEXFScCAGgUfu63AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-30 15:47, Greg Kroah-Hartman wrote:
> On Thu, Oct 30, 2014 at 11:44:39AM +0100, Karol Lewandowski wrote:
>> [ Sorry for breaking thread and resend - gmane rejected my original message
>>   due to too long list of recipients... ]
>>
>> On 2014-10-30 00:40, Greg Kroah-Hartman wrote:
>>
>>> There is a 1815 line documentation file in this series, so we aren't
>>> trying to not provide this type of information here at all.  But yes,
>>> more background, about why this can't be done in userspace (zero copy,
>>> less context switches, proper credential passing, timestamping, availble
>>> at early-boot, LSM hooks for security models to tie into
>>
>> While you're at it... I did some work on proof-of-concept LSM patches for
>> kdbus some time ago, see [1][2].  Currently, these are completely of date.
>>
>>  [1] https://github.com/lmctl/linux/commits/kdbus-lsm-v4.for-systemd-v212
>>  [2] https://github.com/lmctl/kdbus/commit/aa0885489d19be92fa41c6f0a71df28763228a40
>>
>> May I ask if you guys have your own plan for LSM or maybe it would be
>> worth to resurrect [1]?
> 
> The core calls are already mediated by LSM today, right?  We don't want
> anyone to be parsing the data stream through an LSM, that idea got
> rejected a long time ago as something that is really not a good idea.

Parsing data is out of question, of course, but this is not what we were
proposing.

> Other than that, I don't know exactly what your patches do, or why they
> are needed, care to go into details?

Patches in question were supposed to add few hooks for kdbus-specific
operations that doesn't seem to have compatible semantics with hooks
currently available in LSM.

kdbus' bus introduces quite a few new concepts that we wanted to be able
to limit based on MAC label/context, eg.

 - check flags at HELO stage (say disallow fd passing),

 - restrict ability to acquire name to certain subjects (for system bus),

 - disallow creation of new buses,

 - limit scope of broadcasts,

 - etc.

Please take a look at hook list - I think most of names are self-explanatory:

  https://github.com/lmctl/linux/blob/a9fe4c33b6e5ab25a243e0590df406aabb6add12/include/linux/security.h#L1874

kdbus modifications were pretty light - with most visible change being
addition of opaque security pointer to kdbus_bus and similar structs.

Thanks!
-- 
Karol Lewandowski, Samsung R&D Institute Poland

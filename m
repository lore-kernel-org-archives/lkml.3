Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab3EQCwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:52:42 -0400
Received: from intranet.asianux.com ([58.214.24.6]:44848 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3EQCwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:52:41 -0400
X-Spam-Score: -100.8
Message-ID: <51959B45.30207@asianux.com>
Date: Fri, 17 May 2013 10:51:49 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/workqueue.c: need call device_remove_file() when
 failure occurs after called device_create_file()
References: <51922D30.8000809@asianux.com> <20130514151752.GB6795@mtj.dyndns.org> <5192EFE0.4040903@asianux.com> <5193277A.3040506@asianux.com> <20130515212228.GE26222@htj.dyndns.org> <51945384.9060308@asianux.com> <51945D90.8010600@asianux.com> <5194652B.4010209@asianux.com> <20130516175017.GA7171@mtj.dyndns.org>
In-Reply-To: <20130516175017.GA7171@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 01:50 AM, Tejun Heo wrote:
> Hey,
> 
> On Thu, May 16, 2013 at 12:48:43PM +0800, Chen Gang wrote:
>> __sysfs_remove_dir() remove all related things, but not deref the count.
>>
>> For __sysfs_remove_dir() ->
>>   ...
>>   sysfs_addrm_start()
>>   ...
>>   while() {
>>     ...
>>     sysfs_remove_one()  (not deref the related file)
>>   }
>>   sysfs_addrm_finish()  (will deref current dir)
>>
>> For device_remove_file() ->
>>   sysfs_remove_file() ->
>>     sysfs_hash_and_remove() ->
>>       ...
>>       sysfs_addrm_start()
>>       ...
>>       sysfs_remove_one() (not deref the current file)
>>       sysfs_addrm_finish()  (will deref current file)
>>
>>
>> So if not call device_remove_file() firstly, the all files under the
>> directory are removed, but the related resources are not released which
>> will cause resource leak.
> 
> Can you please be more specific on what gets leaked and if possible
> fix it from sysfs side?
> 

Oh, it is my fault. It is not the correct reason.

But I will continue to analyse why it should be add device_remove_file()
before device_unregister() in all 'drivers/*' and 'arch/*' source files.


Thanks.
-- 
Chen Gang

Asianux Corporation

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3EPRu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:50:26 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:62246 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3EPRuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:50:23 -0400
Date: Thu, 16 May 2013 10:50:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/workqueue.c: need call device_remove_file() when
 failure occurs after called device_create_file()
Message-ID: <20130516175017.GA7171@mtj.dyndns.org>
References: <51922D30.8000809@asianux.com>
 <20130514151752.GB6795@mtj.dyndns.org>
 <5192EFE0.4040903@asianux.com>
 <5193277A.3040506@asianux.com>
 <20130515212228.GE26222@htj.dyndns.org>
 <51945384.9060308@asianux.com>
 <51945D90.8010600@asianux.com>
 <5194652B.4010209@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5194652B.4010209@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, May 16, 2013 at 12:48:43PM +0800, Chen Gang wrote:
> __sysfs_remove_dir() remove all related things, but not deref the count.
> 
> For __sysfs_remove_dir() ->
>   ...
>   sysfs_addrm_start()
>   ...
>   while() {
>     ...
>     sysfs_remove_one()  (not deref the related file)
>   }
>   sysfs_addrm_finish()  (will deref current dir)
> 
> For device_remove_file() ->
>   sysfs_remove_file() ->
>     sysfs_hash_and_remove() ->
>       ...
>       sysfs_addrm_start()
>       ...
>       sysfs_remove_one() (not deref the current file)
>       sysfs_addrm_finish()  (will deref current file)
> 
> 
> So if not call device_remove_file() firstly, the all files under the
> directory are removed, but the related resources are not released which
> will cause resource leak.

Can you please be more specific on what gets leaked and if possible
fix it from sysfs side?

Thanks.

-- 
tejun

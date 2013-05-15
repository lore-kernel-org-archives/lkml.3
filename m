Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab3EOVWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:22:33 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:54487 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab3EOVWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:22:32 -0400
Date: Wed, 15 May 2013 14:22:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/workqueue.c: need call device_remove_file() when
 failure occurs after called device_create_file()
Message-ID: <20130515212228.GE26222@htj.dyndns.org>
References: <51922D30.8000809@asianux.com>
 <20130514151752.GB6795@mtj.dyndns.org>
 <5192EFE0.4040903@asianux.com>
 <5193277A.3040506@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5193277A.3040506@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 02:13:14PM +0800, Chen Gang wrote:
> 
> In workqueue_sysfs_register(), when failure occurs after called
> device_create_file(), need call device_remove_file() to release the
> related resources, then call device_unregister().
> 
> Or it will cause issue.
> 
> For individual 'device_attributs' (just like our case), need call
> device_remove_file() explictly and then call device_unregister(),
> please reference drivers/base/*.c (e.g node.c or cpu.c).

Hmm... isn't this already taken care of by __sysfs_remove_dir() which
device_unregister() calls?  That function removes all non-directory
files under the directory being removed.

Thanks.

-- 
tejun

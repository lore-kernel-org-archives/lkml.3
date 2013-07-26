Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab3GZNl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:41:56 -0400
Received: from mail-gh0-f170.google.com ([209.85.160.170]:43756 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab3GZNly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:41:54 -0400
Date: Fri, 26 Jul 2013 09:41:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Dennis Chen <xschen@tnsoft.com.cn>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH] race condition fixing in sysfs_create_dir
Message-ID: <20130726134150.GE3013@htj.dyndns.org>
References: <51F24612.6030509@tnsoft.com.cn>
 <51F24864.7070306@tnsoft.com.cn>
 <20130726133856.GD3013@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726133856.GD3013@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 09:38:56AM -0400, Tejun Heo wrote:
> I don't think sysfs is supposed to handle multiple actors trying to
> populate and destroy the directory at the same time at all, so this

e.g. kobj->sd assignment in sysfs_create_dir() isn't synchronized and
doesn't have memory barrier either.  Nothing prevents subdirectory
creation from accessing half-initialized sysfs_dirent on architectures
which require read dependency barriers.  The caller is responsible for
synchronizing these operations.

Thanks.

-- 
tejun

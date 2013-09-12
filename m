Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab3ILDts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:49:48 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:57178 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3ILDtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:49:47 -0400
Date: Wed, 11 Sep 2013 23:49:43 -0400
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kay@vrfy.org,
        netdev@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 7/7] sysfs: @name comes before @ns
Message-ID: <20130912034943.GB4723@mtj.dyndns.org>
References: <1378952949-7900-1-git-send-email-tj@kernel.org>
 <1378952949-7900-8-git-send-email-tj@kernel.org>
 <87a9ji4sk0.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9ji4sk0.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On Wed, Sep 11, 2013 at 08:39:27PM -0700, Eric W. Biederman wrote:
> @ns is more significant so it should come first.
> 
> Where do we have the backwards convention of putting @name first?

Because @ns is optional and you end up with stupid stuff like

	sysfs_xxx_ns(@param, @ns, @name)
	sysfs_xxx(@param, @name)

You put optional params after the mandatory ones.  It may be difficult
to accept for you but @ns is a *clearly* optional thing for sysfs.

-- 
tejun

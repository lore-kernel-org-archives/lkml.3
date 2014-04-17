Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaDQUKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:10:55 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48993 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDQUKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:10:46 -0400
Date: Thu, 17 Apr 2014 16:10:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [RFC PATCH 2/2] drivers/base: add managed token devres interfaces
Message-ID: <20140417201034.GT15326@htj.dyndns.org>
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <5f21c7e53811aba63f86bcf3e3bfdfdd5aeedf59.1397050852.git.shuah.kh@samsung.com>
 <20140416215821.GG26632@htj.dyndns.org>
 <5350331C.7010602@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5350331C.7010602@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 02:01:32PM -0600, Shuah Khan wrote:
> Operating on the lock should be atomic, which is what devres_update()
> is doing. It can be simplified as follows by holding devres_lock
> in devm_token_lock().
> 
> spin_lock_irqsave(&dev->devres_lock, flags);
> if (tkn_ptr->status == TOKEN_DEVRES_FREE)
> 	tkn_ptr->status = TOKEN_DEVRES_BUSY;
> spin_unlock_irqrestore(&dev->devres_lock, flags);
> 
> Is this in-line with what you have in mind?

How is that different from tkn_ptr->status = TOKEN_DEVRES_BUSY?

-- 
tejun

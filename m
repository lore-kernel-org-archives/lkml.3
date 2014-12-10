Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbaLJHKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:10:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39155 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbaLJHKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:10:10 -0500
Date: Wed, 10 Dec 2014 07:09:59 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Shalin Mehta <shalinmehta85@gmail.com>
Cc: andreas.dilger@intel.com, gregkh@linuxfoundation.org, bergwolf@gmail.com,
        gdonald@gmail.com, peterz@infradead.org, tranmanphong@gmail.com,
        massa.nomura@gmail.com, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        majordomo@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: Fix the warning messages about casting
 without __user macro
Message-ID: <20141210070957.GN22149@ZenIV.linux.org.uk>
References: <1418194573-1271-1-git-send-email-shalinmehta85@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418194573-1271-1-git-send-email-shalinmehta85@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 10:56:12PM -0800, Shalin Mehta wrote:
> From: Shalin Mehta <shalinmehta85@gmail.com>
> 
> This issue is showed up while compiling with sparse. The iov_base in struct iovec struct explicitly declares that the assigned value should be user space pointer with __user macro. Where as here, the __user macro isn't used while casting.

... and pointers are not user space ones at all.  Which is to say, quit
messing with casts; it's not struct iovec.  Proper fix is to replace
it here (and in almost all places throughout drivers/staging/lustre) with
struct kvec.  And yes, such a patch had been sent.  Still not applied,
AFAICS...

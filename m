Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3IKR2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:28:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33031 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3IKR2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:28:18 -0400
Date: Wed, 11 Sep 2013 18:28:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Greg KH <gregkh@linux.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kobject: introduce kobj_completion
Message-ID: <20130911172813.GL13318@ZenIV.linux.org.uk>
References: <5230A1AE.401@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5230A1AE.401@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 01:00:30PM -0400, Jeff Mahoney wrote:
> A common way to handle kobject lifetimes in embedded in objects with
> different lifetime rules is to pair the kobject with a struct completion.
> 
> This introduces a kobj_completion structure that can be used in place
> of the pairing, along with several convenience functions for
> initialization, release, and put-and-wait.

That's very easy to misuse, leading to deadlocks...

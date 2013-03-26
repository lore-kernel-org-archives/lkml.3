Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab3CZUvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:51:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52719 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3CZUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:51:44 -0400
Date: Tue, 26 Mar 2013 14:51:28 -0600
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com
Subject: Re: [PATCHv2 01/02] block: removes dynamic allocation on stack
Message-ID: <20130326205128.GV19488@kernel.dk>
References: <20130326160307.GD7136@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326160307.GD7136@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26 2013, Philip J. Kelleher wrote:
> From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> Removing the dynamic allocation on the stack.
> 
> Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> -------------------------------------------------------------------------------
> o Version 2 consists of the error checking that was foolishly left out.
> o Added error checking to multiple functions to support the dynamically
>   allocated list_head array.

I've been fixing up your patch formats for a while now, lets please just
improve on it a little bit. First of all, your subject line should be
prefixed with the driver name. So just use rsxx or similar. Secondly,
for this patch, you are using the same subject line as the original
patch. This is a fixup patch, it should be labelled as such. A proper
subject line for this patch would be:

rsxx: enable error return of rsxx_eeh_save_issued_dmas()

and the body could be:

Commit d8d595df introduced a bug where we did not check for a NULL
return from kmalloc(). Make rsxx_eeh_save_issued_dmas() return an
error for that case, and make the callers handle that.

You appear to put the description of the patch in a section below your
signed-off-by, which doesn't really work. Your --- divider gets broken
with git am as well.


-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbaLJVpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 16:45:50 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50774 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbaLJVpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:45:49 -0500
Date: Wed, 10 Dec 2014 13:45:45 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/1] Drivers: hv: vmbus: Fix a bug in
 vmbus_establish_gpadl()
Message-ID: <20141210214545.GA2699@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org
References: <1418243359-6887-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418243359-6887-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K. Y. Srinivasan,

On Wed, Dec 10, 2014 at 12:29:19PM -0800, K. Y. Srinivasan wrote:
> Fix a bug in vmbus_establish_gpadl(). I would like to
> thank Michael Brown <mcb30@ipxe.org> for seeing this bug.
> In this version, I have added the Reported-by tag.

The log message should be more specific.  "Fix a bug" is too vague.
Why is this patch necessary? What bug does it fix?  What changes did you
make?

Saying you have "added the Reported-by tag" is not helpful in a log
message.  Although you can add notes for the patch reviewer under '---'.

> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reported-by: Michael Brown <mcb30@ipxe.org>
You followed Gregs advice [1], good :-)

  [1]: https://lkml.org/lkml/2014/12/10/495

> ---
I like to list the changes I make in patch revisions here:

Changes in V2:
  Added Reported-by tag for Michael Brown <mcb30@ipxe.org>

>  drivers/hv/channel.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index 433f72a..c76ffbe 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -366,8 +366,8 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
>  	unsigned long flags;
>  	int ret = 0;
>  
> -	next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
> -	atomic_inc(&vmbus_connection.next_gpadl_handle);
> +	next_gpadl_handle =
> +		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
>  
>  	ret = create_gpadl_header(kbuffer, size, &msginfo, &msgcount);
>  	if (ret)
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler

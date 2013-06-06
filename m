Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074Ab3FFLuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:50:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42587 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932857Ab3FFLrj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 6 Jun 2013 07:47:39 -0400
Message-Id: <51B092F702000078000DBDA8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 06 Jun 2013 12:47:35 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@citrix.com>, <roger.pau@citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] xen/blkback: Check for insane amounts of request
 on the ring.
References: <1370375826-7311-1-git-send-email-konrad.wilk@oracle.com>
 <51AF7A7502000078000DB95C@nat28.tlf.novell.com>
 <20130605173541.GA12812@phenom.dumpdata.com>
In-Reply-To: <20130605173541.GA12812@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.06.13 at 19:35, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> @@ -230,6 +231,7 @@ static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
>  static void xen_blkif_disconnect(struct xen_blkif *blkif)
>  {
>  	if (blkif->xenblkd) {
> +		wake_up(&blkif->shutdown_wq);
>  		kthread_stop(blkif->xenblkd);
>  		blkif->xenblkd = NULL;
>  	}

Btw., wouldn't the wake_up() better be done after the kthread_stop(),
so that when the corresponding wait_event_interruptible() checks
whether to exit the terminating kthread_should_stop() is guaranteed
to evaluate to true (otherwise I think there's potential for it to never
exit)?

Jan


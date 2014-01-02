Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaABO6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 09:58:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37381 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaABO6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 09:58:14 -0500
Date: Thu, 2 Jan 2014 17:57:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        Martin Hofmann <martin.hofmann@studium.uni-erlange.de>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlange.de>,
        martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net
Subject: Re: [PATCH 7/7] vt6655: Fixed most of the checkpatch warnings in wmgr
Message-ID: <20140102145701.GA30164@mwanda>
References: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
 <1388415157-17615-8-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388415157-17615-8-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 03:52:37PM +0100, Michael Gunselmann wrote:
> wmgr.h: Fixed checkpatch errors.
> 	Four typedef warnings remain.
> 		line 85: This typedef increases understandability
> 			 so this warning is not touched.
> 		line 196, 203 and 214:
> 			 These typedef-errors might be fixed in a
> 			 later commit. Fixing them makes it necessary
> 			 to touch many other files of the driver
> 			 using this typedef.
> 
> wmgr.c: Fixed checkpatch errors (mostly comments and braces)
> 	Long lines were ignored and will be fixed in a later commit.
> 	Seven warnings remain:
> 		line 562, 770 and 921:
> 			When removing the braces checkpatch complains
> 			about the compiler is running into trouble.
> 			So these lines are not touched.
> 		line 713, 865, 1618 and 2163:
> 			Checkpatch complains about not using netdev_dbg
> 			instead of printk.
> 			These warnings will be fixed in a later commit.
> 

Don't list the things which you don't change.  We're not interested in
that.

This patch does too many changes at once.  If you want to fix all all
the "checkpatch warnings" and your diff is around 20 lines long then
that counts as doing one thing per patch.  If the diffstat is over a
thousand lines long like in this patch then it can't be a grab bag of
random things all munged together in one gigantor patch.

This patch mindlessly updates comment style.  If we wanted that we
could script it.

> -//2008-8-4 <add> by chester
> +/* 2008-8-4 <add> by chester */

Delete these.  We have proper version control now.

> -		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d \n",
> +		DBG_PRT(MSG_LEVEL_INFO, KERN_INFO "Max Support rate = %d\n",
>  			pMgmt->sNodeDBTable[uNodeIndex].wMaxSuppRate);
> -	}//else { TODO: received STA under state1 handle }
> -	else {
> -		return;
>  	}
> +	/* else { TODO: received STA under state1 handle } */
> +	else
> +		return;

This isn't right.  The correct style is:

	} else {
		return;
	}

But even better would be to reverse the condition and pull everything
in one indent level.

	if (pMgmt->sNodeDBTable[uNodeIndex].eNodeState < NODE_AUTH)
		return;

	pMgmt->sNodeDBTable[uNodeIndex].eNodeState = NODE_ASSOC;
	pMgmt->sNodeDBTable[uNodeIndex].wCapInfo = cpu_to_le16(*sFrame.pwCapInfo);

	etc...


> @@ -1384,11 +1369,12 @@ s_vMgrRxAuthenSequence_2(
>  			s_vMgrLogStatus(pMgmt, cpu_to_le16((*(pFrame->pwStatus))));
>  			pMgmt->eCurrState = WMAC_STATE_IDLE;
>  		}
> -		if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
> -//                spin_unlock_irq(&pDevice->lock);
> -//                vCommandTimerWait((void *)pDevice, 0);
> -//                spin_lock_irq(&pDevice->lock);
> -		}
> +/*		if (pDevice->eCommandState == WLAN_AUTHENTICATE_WAIT) {
> + *                spin_unlock_irq(&pDevice->lock);
> + *                vCommandTimerWait((void *)pDevice, 0);
> + *                spin_lock_irq(&pDevice->lock);
> + *		}
> + */
>  

Just delete this sort of thing instead of updating the comment style.
There are a couple other examples of this as well.  Please redo this
patch.

regards,
dan carpenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbaKGCuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 21:50:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKGCuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 21:50:01 -0500
Date: Thu, 6 Nov 2014 18:48:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jaime Arrocha <jarrocha27@gmail.com>
Cc: liodot@gmail.com, charrer@alacritech.com, matlackdavid@gmail.com,
        monamagarwal123@gmail.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: slicoss.c: checkpatch warnings
Message-ID: <20141107024850.GA24200@kroah.com>
References: <20141107005727.GA21923@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107005727.GA21923@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 06:57:27PM -0600, Jaime Arrocha wrote:
> Correction of warnings of lines with 80 plus character.
> The rest were left for better code readability
> 
> Signed-off-by: Jaime Arrocha <jarrocha27@gmail.com>
> ---
>  drivers/staging/slicoss/slicoss.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> index cff7cbe..d65fa92 100644
> --- a/drivers/staging/slicoss/slicoss.c
> +++ b/drivers/staging/slicoss/slicoss.c
> @@ -99,8 +99,8 @@
>  #include "slic.h"
>  
>  static uint slic_first_init = 1;
> -static char *slic_banner = "Alacritech SLIC Technology(tm) Server "
> -		"and Storage Accelerator (Non-Accelerated)";
> +char *slic_banner = "Alacritech SLIC Technology(tm) Server and "
> +			"Storage Accelerator (Non-Accelerated)";

Why did you take away the 'static' marking here?  And make this one full
line please.



>  
>  static char *slic_proc_version = "2.0.351  2006/07/14 12:26:00";
>  
> @@ -498,12 +498,14 @@ static int slic_card_download(struct adapter *adapter)
>  			slic_reg32_write(&slic_regs->slic_wcs,
>  					 baseaddress + codeaddr, FLUSH);
>  			/* Write out instruction to low addr */
> -			slic_reg32_write(&slic_regs->slic_wcs, instruction, FLUSH);
> +			slic_reg32_write(&slic_regs->slic_wcs,
> +					 instruction, FLUSH);
>  			instruction = *(u32 *)(fw->data + index);
>  			index += 4;
>  
>  			/* Write out instruction to high addr */
> -			slic_reg32_write(&slic_regs->slic_wcs, instruction, FLUSH);
> +			slic_reg32_write(&slic_regs->slic_wcs,
> +					 instruction, FLUSH);
>  			instruction = *(u32 *)(fw->data + index);
>  			index += 4;
>  		}
> @@ -1884,7 +1886,8 @@ static void slic_xmit_fail(struct adapter *adapter,
>  			break;
>  		case XMIT_FAIL_HOSTCMD_FAIL:
>  			dev_err(&adapter->netdev->dev,
> -				"xmit_start skb[%p] type[%x] No host commands available\n", skb, skb->pkt_type);
> +				"xmit_start skb[%p] type[%x] No host commands available\n",
> +				skb, skb->pkt_type);
>  			break;
>  		}
>  	}
> @@ -2096,11 +2099,10 @@ static void slic_interrupt_card_up(u32 isr, struct adapter *adapter,
>  				}
>  			} else if (isr & ISR_XDROP) {
>  				dev_err(&dev->dev,
> -						"isr & ISR_ERR [%x] ISR_XDROP\n", isr);
> +					"isr & ISR_ERR [%x] ISR_XDROP\n", isr);
>  			} else {
>  				dev_err(&dev->dev,
> -						"isr & ISR_ERR [%x]\n",
> -						isr);
> +					"isr & ISR_ERR [%x]\n",	isr);
>  			}
>  		}
>  
> @@ -2340,7 +2342,8 @@ static int slic_if_init(struct adapter *adapter)
>  				 SLIC_GET_ADDR_LOW(&pshmem->isr), FLUSH);
>  #else
>  		slic_reg32_write(&slic_regs->slic_addr_upper, 0, DONT_FLUSH);
> -		slic_reg32_write(&slic_regs->slic_isp, (u32)&pshmem->isr, FLUSH);
> +		slic_reg32_write(&slic_regs->slic_isp,
> +				 (u32)&pshmem->isr, FLUSH);
>  #endif
>  		spin_unlock_irqrestore(&adapter->bit64reglock.lock,
>  					adapter->bit64reglock.flags);
> @@ -2555,7 +2558,8 @@ static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>  
>  			if (copy_from_user(data, rq->ifr_data, 28)) {
>  				PRINT_ERROR
> -				    ("slic: copy_from_user FAILED getting initial simba param\n");
> +				    ("slic: copy_from_user FAILED getting"
> +				     " initial simba param\n");

Never break a string across a line.

>  				return -EFAULT;
>  			}
>  
> @@ -2570,7 +2574,8 @@ static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>  				   (tracemon_request ==
>  				    SLIC_DUMP_IN_PROGRESS)) {
>  				PRINT_ERROR
> -				    ("ATK Diagnostic Trace Dump Requested but already in progress... ignore\n");
> +				    ("ATK Diagnostic Trace Dump Requested"
> +				     " but already in progress... ignore\n");

Same here, never do this.

If you fix up the PRINT_ERROR() macros, you will not get checkpatch
warnings.  But that's not a real issue, this driver has so many other
problems...

thanks,

greg k-h

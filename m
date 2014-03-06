Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055AbaCFFLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:11:37 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51395 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbaCFFLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:11:35 -0500
X-Sasl-enc: RYC+TdDPhz6jizbof/iX7ZMm1r20mmQvAFHbfqUgYYp9 1394082692
Date: Wed, 5 Mar 2014 21:11:58 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?=22Salva_Peir=F3=22?= <speiro@ai2.upv.es>,
        Daeseok Youn <daeseok.youn@gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20140306051158.GA11456@kroah.com>
References: <20140306160649.9564c40b8deaaf3b1e261a5b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306160649.9564c40b8deaaf3b1e261a5b@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 04:06:49PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/cxt1e1/linux.c between commit 084b6e7765b9
> ("staging/cxt1e1/linux.c: Correct arbitrary memory write in c4_ioctl()")
> from the staging.current tree and commit 922b81b835c4 ("staging: cxt1e1:
> remove space between function name and parenthesis") and a couple of
> others from the staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks, that looks good.

greg k-h

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/staging/cxt1e1/linux.c
> index 79206cb3fb94,579e68e3dece..000000000000
> --- a/drivers/staging/cxt1e1/linux.c
> +++ b/drivers/staging/cxt1e1/linux.c
> @@@ -861,79 -876,78 +876,80 @@@ c4_ioctl(struct net_device *ndev, struc
>   #endif
>   
>   #if 0
> -     pr_info("c4_ioctl: iocmd %x, dir %x type %x nr %x iolen %d.\n", iocmd,
> -             _IOC_DIR (iocmd), _IOC_TYPE (iocmd), _IOC_NR (iocmd),
> -             _IOC_SIZE (iocmd));
> + 	pr_info("c4_ioctl: iocmd %x, dir %x type %x nr %x iolen %d.\n", iocmd,
> + 		_IOC_DIR(iocmd), _IOC_TYPE(iocmd), _IOC_NR(iocmd),
> + 		_IOC_SIZE(iocmd));
>   #endif
> -     iolen = _IOC_SIZE (iocmd);
> -     if (iolen > sizeof(arg))
> -         return -EFAULT;
> -     data = ifr->ifr_data + sizeof (iocmd);
> -     if (copy_from_user (&arg, data, iolen))
> -         return -EFAULT;
> - 
> -     ret = 0;
> -     switch (iocmd)
> -     {
> -     case SBE_IOC_PORT_GET:
> -         //pr_info(">> SBE_IOC_PORT_GET Ioctl...\n");
> -         ret = do_get_port (ndev, data);
> -         break;
> -     case SBE_IOC_PORT_SET:
> -         //pr_info(">> SBE_IOC_PORT_SET Ioctl...\n");
> -         ret = do_set_port (ndev, data);
> -         break;
> -     case SBE_IOC_CHAN_GET:
> -         //pr_info(">> SBE_IOC_CHAN_GET Ioctl...\n");
> -         ret = do_get_chan (ndev, data);
> -         break;
> -     case SBE_IOC_CHAN_SET:
> -         //pr_info(">> SBE_IOC_CHAN_SET Ioctl...\n");
> -         ret = do_set_chan (ndev, data);
> -         break;
> -     case C4_DEL_CHAN:
> -         //pr_info(">> C4_DEL_CHAN Ioctl...\n");
> -         ret = do_del_chan (ndev, data);
> -         break;
> -     case SBE_IOC_CHAN_NEW:
> -         ret = do_create_chan (ndev, data);
> -         break;
> -     case SBE_IOC_CHAN_GET_STAT:
> -         ret = do_get_chan_stats (ndev, data);
> -         break;
> -     case SBE_IOC_LOGLEVEL:
> -         ret = do_set_loglevel (ndev, data);
> -         break;
> -     case SBE_IOC_RESET_DEV:
> -         ret = do_reset (ndev, data);
> -         break;
> -     case SBE_IOC_CHAN_DEL_STAT:
> -         ret = do_reset_chan_stats (ndev, data);
> -         break;
> -     case C4_LOOP_PORT:
> -         ret = do_port_loop (ndev, data);
> -         break;
> -     case C4_RW_FRMR:
> -         ret = do_framer_rw (ndev, data);
> -         break;
> -     case C4_RW_MSYC:
> -         ret = do_musycc_rw (ndev, data);
> -         break;
> -     case C4_RW_PLD:
> -         ret = do_pld_rw (ndev, data);
> -         break;
> -     case SBE_IOC_IID_GET:
> -         ret = (iolen == sizeof (struct sbe_iid_info)) ? c4_get_iidinfo (ci, &arg.u.iip) : -EFAULT;
> -         if (ret == 0)               /* no error, copy data */
> -             if (copy_to_user (data, &arg, iolen))
> -                 return -EFAULT;
> -         break;
> -     default:
> -         //pr_info(">> c4_ioctl: EINVAL - unknown iocmd <%x>\n", iocmd);
> -         ret = -EINVAL;
> -         break;
> -     }
> -     return mkret (ret);
> + 	iolen = _IOC_SIZE(iocmd);
> ++	if (iolen > sizeof(arg))
> ++		return -EFAULT;
> + 	data = ifr->ifr_data + sizeof(iocmd);
> + 	if (copy_from_user(&arg, data, iolen))
> + 		return -EFAULT;
> + 
> + 	ret = 0;
> + 	switch (iocmd)
> + 	{
> + 	case SBE_IOC_PORT_GET:
> + 		//pr_info(">> SBE_IOC_PORT_GET Ioctl...\n");
> + 		ret = do_get_port(ndev, data);
> + 		break;
> + 	case SBE_IOC_PORT_SET:
> + 		//pr_info(">> SBE_IOC_PORT_SET Ioctl...\n");
> + 		ret = do_set_port(ndev, data);
> + 		break;
> + 	case SBE_IOC_CHAN_GET:
> + 		//pr_info(">> SBE_IOC_CHAN_GET Ioctl...\n");
> + 		ret = do_get_chan(ndev, data);
> + 		break;
> + 	case SBE_IOC_CHAN_SET:
> + 		//pr_info(">> SBE_IOC_CHAN_SET Ioctl...\n");
> + 		ret = do_set_chan(ndev, data);
> + 		break;
> + 	case C4_DEL_CHAN:
> + 		//pr_info(">> C4_DEL_CHAN Ioctl...\n");
> + 		ret = do_del_chan(ndev, data);
> + 		break;
> + 	case SBE_IOC_CHAN_NEW:
> + 		ret = do_create_chan(ndev, data);
> + 		break;
> + 	case SBE_IOC_CHAN_GET_STAT:
> + 		ret = do_get_chan_stats(ndev, data);
> + 		break;
> + 	case SBE_IOC_LOGLEVEL:
> + 		ret = do_set_loglevel(ndev, data);
> + 		break;
> + 	case SBE_IOC_RESET_DEV:
> + 		ret = do_reset(ndev, data);
> + 		break;
> + 	case SBE_IOC_CHAN_DEL_STAT:
> + 		ret = do_reset_chan_stats(ndev, data);
> + 		break;
> + 	case C4_LOOP_PORT:
> + 		ret = do_port_loop(ndev, data);
> + 		break;
> + 	case C4_RW_FRMR:
> + 		ret = do_framer_rw(ndev, data);
> + 		break;
> + 	case C4_RW_MSYC:
> + 		ret = do_musycc_rw(ndev, data);
> + 		break;
> + 	case C4_RW_PLD:
> + 		ret = do_pld_rw(ndev, data);
> + 		break;
> + 	case SBE_IOC_IID_GET:
> + 		ret = (iolen == sizeof(struct sbe_iid_info)) ?
> + 		       c4_get_iidinfo(ci, &arg.u.iip) : -EFAULT;
> + 		if (ret == 0)               /* no error, copy data */
> + 			if (copy_to_user(data, &arg, iolen))
> + 				return -EFAULT;
> + 		break;
> + 	default:
> + 		//pr_info(">> c4_ioctl: EINVAL - unknown iocmd <%x>\n", iocmd);
> + 		ret = -EINVAL;
> + 		break;
> + 	}
> + 	return mkret(ret);
>   }
>   
>   static const struct net_device_ops c4_ops = {



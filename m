Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaKFEvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:51:24 -0500
Received: from ozlabs.org ([103.22.144.67]:60628 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaKFEvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:51:21 -0500
Date: Thu, 6 Nov 2014 15:51:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the y2038 tree with the staging
 tree
Message-ID: <20141106155112.47bf4988@canb.auug.org.au>
In-Reply-To: <20141106154815.27f53970@canb.auug.org.au>
References: <20141106154815.27f53970@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/gF1Z3S4y4CPHV3U_k2.YlRG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gF1Z3S4y4CPHV3U_k2.YlRG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Thu, 6 Nov 2014 15:48:15 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the y2038 tree got a conflict in
> drivers/staging/ft1000/ft1000-usb/ft1000_debug.c between commit
> ecdd21c7b982 ("staging: ft1000: Whitespace neatening") from the staging
> tree and commit 4115d2b27a50 ("staging: ft1000: Replace timeval and
> time_t with time64_t") from the y2038 tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Sorry, see below for proper diff.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index c8d278229940,287c8b3c18fc..000000000000
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@@ -391,339 -394,344 +391,339 @@@ static unsigned int ft1000_poll_dev(str
  }
 =20
  /*
 -*------------------------------------------------------------------------=
---
 -* Function:    ft1000_ioctl
 -*
 -* Parameters:
 -*
 -* Description:
 -*
 -* Notes:
 -*
 -*------------------------------------------------------------------------=
---
 -*/
 + *-----------------------------------------------------------------------=
----
 + * Function:    ft1000_ioctl
 + *
 + * Parameters:
 + *
 + * Description:
 + *
 + * Notes:
 + *
 + *-----------------------------------------------------------------------=
----
 + */
  static long ft1000_ioctl(struct file *file, unsigned int command,
 -                           unsigned long argument)
 +			 unsigned long argument)
  {
 -    void __user *argp =3D (void __user *)argument;
 +	void __user *argp =3D (void __user *)argument;
  	struct ft1000_info *info;
 -    struct ft1000_usb *ft1000dev;
 -    int result=3D0;
 -    int cmd;
 -    int i;
 -    u16 tempword;
 -    unsigned long flags;
 +	struct ft1000_usb *ft1000dev;
 +	int result =3D 0;
 +	int cmd;
 +	int i;
 +	u16 tempword;
 +	unsigned long flags;
- 	struct timeval tv;
+ 	time64_t time;
  	struct IOCTL_GET_VER get_ver_data;
  	struct IOCTL_GET_DSP_STAT get_stat_data;
 -    u8 ConnectionMsg[] =3D {0x00,0x44,0x10,0x20,0x80,0x00,0x00,0x00,0x00,=
0x00,0x03,0x00,0x00,0x00,0x93,0x64,
 -                          0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x=
00,0x00,0x05,0x00,0x00,0x00,0x0a,
 -                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x=
00,0x00,0x00,0x00,0x00,0x00,0x00,
 -                          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x12,0x00,0x=
00,0x00,0x00,0x00,0x00,0x00,0x00,
 -                          0x00,0x00,0x02,0x37,0x00,0x00,0x00,0x08,0x00,0x=
00,0x00,0x01,0x00,0x01,0x7f,0x00,
 -                          0x00,0x01,0x00,0x00};
 +	u8 ConnectionMsg[] =3D {0x00, 0x44, 0x10, 0x20, 0x80, 0x00, 0x00, 0x00, =
0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x93, 0x64,
 +			      0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00=
, 0x05, 0x00, 0x00, 0x00, 0x0a,
 +			      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00=
, 0x00, 0x00, 0x00, 0x00, 0x00,
 +			      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00=
, 0x00, 0x00, 0x00, 0x00, 0x00,
 +			      0x00, 0x00, 0x02, 0x37, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00=
, 0x01, 0x00, 0x01, 0x7f, 0x00,
 +			      0x00, 0x01, 0x00, 0x00};
 +
 +	unsigned short ledStat =3D 0;
 +	unsigned short conStat =3D 0;
 +
 +	if (ft1000_flarion_cnt =3D=3D 0) {
 +		pr_debug("called with ft1000_flarion_cnt of zero\n");
 +		return -EBADF;
 +	}
 =20
 -    unsigned short ledStat=3D0;
 -    unsigned short conStat=3D0;
 +	/* pr_debug("command =3D 0x%x argument =3D 0x%8x\n", command, (u32)argum=
ent); */
 =20
 -    /* DEBUG("ft1000_ioctl called\n"); */
 +	info =3D file->private_data;
 +	ft1000dev =3D info->priv;
 +	cmd =3D _IOC_NR(command);
 +	/* pr_debug("cmd =3D 0x%x\n", cmd); */
 +
 +	/* process the command */
 +	switch (cmd) {
 +	case IOCTL_REGISTER_CMD:
 +		pr_debug("IOCTL_FT1000_REGISTER called\n");
 +		result =3D get_user(tempword, (__u16 __user *)argp);
 +		if (result) {
 +			pr_debug("result =3D %d failed to get_user\n", result);
 +			break;
 +		}
 +		if (tempword =3D=3D DSPBCMSGID) {
 +			/* Search for matching file object */
 +			for (i =3D 0; i < MAX_NUM_APP; i++) {
 +				if (ft1000dev->app_info[i].fileobject =3D=3D &file->f_owner) {
 +					ft1000dev->app_info[i].DspBCMsgFlag =3D 1;
 +					pr_debug("Registered for broadcast messages\n");
 +					break;
 +				}
 +			}
 +		}
 +		break;
 =20
 -    if (ft1000_flarion_cnt =3D=3D 0) {
 -        DEBUG("FT1000:ft1000_ioctl called when ft1000_flarion_cnt is zero=
\n");
 -        return (-EBADF);
 -    }
 +	case IOCTL_GET_VER_CMD:
 +		pr_debug("IOCTL_FT1000_GET_VER called\n");
 =20
 -    /* DEBUG("FT1000:ft1000_ioctl:command =3D 0x%x argument =3D 0x%8x\n",=
 command, (u32)argument); */
 +		get_ver_data.drv_ver =3D FT1000_DRV_VER;
 =20
 -	info =3D file->private_data;
 -	ft1000dev =3D info->priv;
 -    cmd =3D _IOC_NR(command);
 -    /* DEBUG("FT1000:ft1000_ioctl:cmd =3D 0x%x\n", cmd); */
 -
 -    /* process the command */
 -    switch (cmd) {
 -    case IOCTL_REGISTER_CMD:
 -            DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_REGISTER called\n");
 -            result =3D get_user(tempword, (__u16 __user*)argp);
 -            if (result) {
 -                DEBUG("result =3D %d failed to get_user\n", result);
 -                break;
 -            }
 -            if (tempword =3D=3D DSPBCMSGID) {
 -                /* Search for matching file object */
 -                for (i=3D0; i<MAX_NUM_APP; i++) {
 -                    if (ft1000dev->app_info[i].fileobject =3D=3D &file->f=
_owner) {
 -                        ft1000dev->app_info[i].DspBCMsgFlag =3D 1;
 -                        DEBUG("FT1000:ft1000_ioctl:Registered for broadca=
st messages\n");
 -                        break;
 -                    }
 -                }
 -            }
 -            break;
 -
 -    case IOCTL_GET_VER_CMD:
 -        DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_VER called\n");
 -
 -        get_ver_data.drv_ver =3D FT1000_DRV_VER;
 -
 -        if (copy_to_user(argp, &get_ver_data, sizeof(get_ver_data))) {
 -            DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
 -            result =3D -EFAULT;
 -            break;
 -        }
 -
 -        DEBUG("FT1000:ft1000_ioctl:driver version =3D 0x%x\n",(unsigned i=
nt)get_ver_data.drv_ver);
 -
 -        break;
 -    case IOCTL_CONNECT:
 -        /* Connect Message */
 -        DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_CONNECT\n");
 -        ConnectionMsg[79] =3D 0xfc;
 -			   result =3D card_send_command(ft1000dev, (unsigned short *)Connectio=
nMsg, 0x4c);
 -
 -        break;
 -    case IOCTL_DISCONNECT:
 -        /* Disconnect Message */
 -        DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_DISCONNECT\n");
 -        ConnectionMsg[79] =3D 0xfd;
 -			   result =3D card_send_command(ft1000dev, (unsigned short *)Connectio=
nMsg, 0x4c);
 -        break;
 -    case IOCTL_GET_DSP_STAT_CMD:
 -        /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DSP_STAT called\n=
"); */
 -	memset(&get_stat_data, 0, sizeof(get_stat_data));
 -        memcpy(get_stat_data.DspVer, info->DspVer, DSPVERSZ);
 -        memcpy(get_stat_data.HwSerNum, info->HwSerNum, HWSERNUMSZ);
 -        memcpy(get_stat_data.Sku, info->Sku, SKUSZ);
 -        memcpy(get_stat_data.eui64, info->eui64, EUISZ);
 -
 -            if (info->ProgConStat !=3D 0xFF) {
 -                ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_LED, (u8 *)=
&ledStat, FT1000_MAG_DSP_LED_INDX);
 -                get_stat_data.LedStat =3D ntohs(ledStat);
 -                DEBUG("FT1000:ft1000_ioctl: LedStat =3D 0x%x\n", get_stat=
_data.LedStat);
 -                ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_CON_STATE, =
(u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
 -                get_stat_data.ConStat =3D ntohs(conStat);
 -                DEBUG("FT1000:ft1000_ioctl: ConStat =3D 0x%x\n", get_stat=
_data.ConStat);
 -            } else {
 -                get_stat_data.ConStat =3D 0x0f;
 -            }
 -
 -
 -        get_stat_data.nTxPkts =3D info->stats.tx_packets;
 -        get_stat_data.nRxPkts =3D info->stats.rx_packets;
 -        get_stat_data.nTxBytes =3D info->stats.tx_bytes;
 -        get_stat_data.nRxBytes =3D info->stats.rx_bytes;
 -	time =3D get_seconds();
 -	get_stat_data.ConTm =3D time - info->ConTm;
 -        DEBUG("Connection Time =3D %d\n", (int)get_stat_data.ConTm);
 -        if (copy_to_user(argp, &get_stat_data, sizeof(get_stat_data))) {
 -            DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
 -            result =3D -EFAULT;
 -            break;
 -        }
 -        DEBUG("ft1000_chioctl: GET_DSP_STAT succeed\n");
 -        break;
 -    case IOCTL_SET_DPRAM_CMD:
 -        {
 +		if (copy_to_user(argp, &get_ver_data, sizeof(get_ver_data))) {
 +			pr_debug("copy fault occurred\n");
 +			result =3D -EFAULT;
 +			break;
 +		}
 +
 +		pr_debug("driver version =3D 0x%x\n",
 +			 (unsigned int)get_ver_data.drv_ver);
 +
 +		break;
 +	case IOCTL_CONNECT:
 +		/* Connect Message */
 +		pr_debug("IOCTL_FT1000_CONNECT\n");
 +		ConnectionMsg[79] =3D 0xfc;
 +		result =3D card_send_command(ft1000dev, (unsigned short *)ConnectionMsg=
, 0x4c);
 +
 +		break;
 +	case IOCTL_DISCONNECT:
 +		/* Disconnect Message */
 +		pr_debug("IOCTL_FT1000_DISCONNECT\n");
 +		ConnectionMsg[79] =3D 0xfd;
 +		result =3D card_send_command(ft1000dev, (unsigned short *)ConnectionMsg=
, 0x4c);
 +		break;
 +	case IOCTL_GET_DSP_STAT_CMD:
 +		/* pr_debug("IOCTL_FT1000_GET_DSP_STAT\n"); */
 +		memset(&get_stat_data, 0, sizeof(get_stat_data));
 +		memcpy(get_stat_data.DspVer, info->DspVer, DSPVERSZ);
 +		memcpy(get_stat_data.HwSerNum, info->HwSerNum, HWSERNUMSZ);
 +		memcpy(get_stat_data.Sku, info->Sku, SKUSZ);
 +		memcpy(get_stat_data.eui64, info->eui64, EUISZ);
 +
 +		if (info->ProgConStat !=3D 0xFF) {
 +			ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_LED, (u8 *)&ledStat, FT1=
000_MAG_DSP_LED_INDX);
 +			get_stat_data.LedStat =3D ntohs(ledStat);
 +			pr_debug("LedStat =3D 0x%x\n", get_stat_data.LedStat);
 +			ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_CON_STATE, (u8 *)&conSta=
t, FT1000_MAG_DSP_CON_STATE_INDX);
 +			get_stat_data.ConStat =3D ntohs(conStat);
 +			pr_debug("ConStat =3D 0x%x\n", get_stat_data.ConStat);
 +		} else {
 +			get_stat_data.ConStat =3D 0x0f;
 +		}
 +
 +
 +		get_stat_data.nTxPkts =3D info->stats.tx_packets;
 +		get_stat_data.nRxPkts =3D info->stats.rx_packets;
 +		get_stat_data.nTxBytes =3D info->stats.tx_bytes;
 +		get_stat_data.nRxBytes =3D info->stats.rx_bytes;
- 		do_gettimeofday(&tv);
- 		get_stat_data.ConTm =3D (u32)(tv.tv_sec - info->ConTm);
++		time =3D get_seconds();
++		get_stat_data.ConTm =3D time - info->ConTm;
 +		pr_debug("Connection Time =3D %d\n", (int)get_stat_data.ConTm);
 +		if (copy_to_user(argp, &get_stat_data, sizeof(get_stat_data))) {
 +			pr_debug("copy fault occurred\n");
 +			result =3D -EFAULT;
 +			break;
 +		}
 +		pr_debug("GET_DSP_STAT succeed\n");
 +		break;
 +	case IOCTL_SET_DPRAM_CMD:
 +	{
  		struct IOCTL_DPRAM_BLK *dpram_data =3D NULL;
  		/* struct IOCTL_DPRAM_COMMAND dpram_command; */
 -            u16 qtype;
 -            u16 msgsz;
 +		u16 qtype;
 +		u16 msgsz;
  		struct pseudo_hdr *ppseudo_hdr;
 -            u16 *pmsg;
 -            u16 total_len;
 -            u16 app_index;
 -            u16 status;
 +		u16 *pmsg;
 +		u16 total_len;
 +		u16 app_index;
 +		u16 status;
 =20
 -            /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_SET_DPRAM called\=
n");*/
 +		/* pr_debug("IOCTL_FT1000_SET_DPRAM called\n");*/
 =20
 =20
 -            if (ft1000_flarion_cnt =3D=3D 0) {
 -                return (-EBADF);
 -            }
 +		if (ft1000_flarion_cnt =3D=3D 0)
 +			return -EBADF;
 =20
 -            if (ft1000dev->DrvMsgPend) {
 -                return (-ENOTTY);
 -            }
 +		if (ft1000dev->DrvMsgPend)
 +			return -ENOTTY;
 =20
 -            if (ft1000dev->fProvComplete =3D=3D 0) {
 -                return (-EACCES);
 -            }
 +		if (ft1000dev->fProvComplete =3D=3D 0)
 +			return -EACCES;
 =20
 -            ft1000dev->fAppMsgPend =3D 1;
 +		ft1000dev->fAppMsgPend =3D 1;
 =20
 -            if (info->CardReady) {
 +		if (info->CardReady) {
 =20
 -               /* DEBUG("FT1000:ft1000_ioctl: try to SET_DPRAM \n"); */
 +			/* pr_debug("try to SET_DPRAM\n"); */
 =20
 -                /* Get the length field to see how many bytes to copy */
 -                result =3D get_user(msgsz, (__u16 __user *)argp);
 -		if (result)
 -			break;
 -                msgsz =3D ntohs(msgsz);
 -                /* DEBUG("FT1000:ft1000_ioctl: length of message =3D %d\n=
", msgsz); */
 -
 -                if (msgsz > MAX_CMD_SQSIZE) {
 -                    DEBUG("FT1000:ft1000_ioctl: bad message length =3D %d=
\n", msgsz);
 -                    result =3D -EINVAL;
 -                    break;
 -                }
 -
 -		result =3D -ENOMEM;
 -		dpram_data =3D kmalloc(msgsz + 2, GFP_KERNEL);
 -		if (!dpram_data)
 -			break;
 +			/* Get the length field to see how many bytes to copy */
 +			result =3D get_user(msgsz, (__u16 __user *)argp);
 +			if (result)
 +				break;
 +			msgsz =3D ntohs(msgsz);
 +			/* pr_debug("length of message =3D %d\n", msgsz); */
 +
 +			if (msgsz > MAX_CMD_SQSIZE) {
 +				pr_debug("bad message length =3D %d\n", msgsz);
 +				result =3D -EINVAL;
 +				break;
 +			}
 =20
 -                if (copy_from_user(dpram_data, argp, msgsz+2)) {
 -                    DEBUG("FT1000:ft1000_ChIoctl: copy fault occurred\n");
 -                    result =3D -EFAULT;
 -                } else {
 -                    /* Check if this message came from a registered appli=
cation */
 -                    for (i=3D0; i<MAX_NUM_APP; i++) {
 -                        if (ft1000dev->app_info[i].fileobject =3D=3D &fil=
e->f_owner) {
 -                            break;
 -                        }
 -                    }
 -                    if (i=3D=3DMAX_NUM_APP) {
 -                        DEBUG("FT1000:No matching application fileobject\=
n");
 -                        result =3D -EINVAL;
 -			kfree(dpram_data);
 -                        break;
 -                    }
 -                    app_index =3D i;
 -
 -                    /* Check message qtype type which is the lower byte w=
ithin qos_class */
 -                    qtype =3D ntohs(dpram_data->pseudohdr.qos_class) & 0x=
ff;
 -                    /* DEBUG("FT1000_ft1000_ioctl: qtype =3D %d\n", qtype=
); */
 -                    if (qtype) {
 -                    } else {
 -                        /* Put message into Slow Queue */
 -                        /* Only put a message into the DPRAM if msg doorb=
ell is available */
 -                        status =3D ft1000_read_register(ft1000dev, &tempw=
ord, FT1000_REG_DOORBELL);
 -                        /* DEBUG("FT1000_ft1000_ioctl: READ REGISTER temp=
word=3D%x\n", tempword); */
 -                        if (tempword & FT1000_DB_DPRAM_TX) {
 -                            /* Suspend for 2ms and try again due to DSP d=
oorbell busy */
 -                            mdelay(2);
 -                            status =3D ft1000_read_register(ft1000dev, &t=
empword, FT1000_REG_DOORBELL);
 -                            if (tempword & FT1000_DB_DPRAM_TX) {
 -                                /* Suspend for 1ms and try again due to D=
SP doorbell busy */
 -                                mdelay(1);
 -                                status =3D ft1000_read_register(ft1000dev=
, &tempword, FT1000_REG_DOORBELL);
 -                                if (tempword & FT1000_DB_DPRAM_TX) {
 -                                    status =3D ft1000_read_register(ft100=
0dev, &tempword, FT1000_REG_DOORBELL);
 -                                    if (tempword & FT1000_DB_DPRAM_TX) {
 -                                        /* Suspend for 3ms and try again =
due to DSP doorbell busy */
 -                                        mdelay(3);
 -                                        status =3D ft1000_read_register(f=
t1000dev, &tempword, FT1000_REG_DOORBELL);
 -                                        if (tempword & FT1000_DB_DPRAM_TX=
) {
 -                                            DEBUG("FT1000:ft1000_ioctl:Do=
orbell not available\n");
 -                                            result =3D -ENOTTY;
 -						kfree(dpram_data);
 -                                            break;
 -                                        }
 -                                    }
 -                                }
 -                            }
 -                        }
 -
 -                        /*DEBUG("FT1000_ft1000_ioctl: finished reading re=
gister\n"); */
 -
 -                        /* Make sure we are within the limits of the slow=
 queue memory limitation */
 -                        if ((msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ=
)) {
 -                            /* Need to put sequence number plus new check=
sum for message */
 -                            pmsg =3D (u16 *)&dpram_data->pseudohdr;
 -				ppseudo_hdr =3D (struct pseudo_hdr *)pmsg;
 -                            total_len =3D msgsz+2;
 -                            if (total_len & 0x1) {
 -                                total_len++;
 -                            }
 -
 -                            /* Insert slow queue sequence number */
 -                            ppseudo_hdr->seq_num =3D info->squeseqnum++;
 -                            ppseudo_hdr->portsrc =3D ft1000dev->app_info[=
app_index].app_id;
 -                            /* Calculate new checksum */
 -                            ppseudo_hdr->checksum =3D *pmsg++;
 -                            /* DEBUG("checksum =3D 0x%x\n", ppseudo_hdr->=
checksum); */
 -                            for (i=3D1; i<7; i++) {
 -                                ppseudo_hdr->checksum ^=3D *pmsg++;
 -                                /* DEBUG("checksum =3D 0x%x\n", ppseudo_h=
dr->checksum); */
 -                            }
 -                            pmsg++;
 -				ppseudo_hdr =3D (struct pseudo_hdr *)pmsg;
 -                           result =3D card_send_command(ft1000dev,(unsign=
ed short*)dpram_data,total_len+2);
 -
 -
 -                            ft1000dev->app_info[app_index].nTxMsg++;
 -                        } else {
 -                            result =3D -EINVAL;
 -                        }
 -                    }
 -                }
 -            } else {
 -                DEBUG("FT1000:ft1000_ioctl: Card not ready take messages\=
n");
 -                result =3D -EACCES;
 -            }
 -	    kfree(dpram_data);
 -
 -        }
 -        break;
 -    case IOCTL_GET_DPRAM_CMD:
 -        {
 +			result =3D -ENOMEM;
 +			dpram_data =3D kmalloc(msgsz + 2, GFP_KERNEL);
 +			if (!dpram_data)
 +				break;
 +
 +			if (copy_from_user(dpram_data, argp, msgsz+2)) {
 +				pr_debug("copy fault occurred\n");
 +				result =3D -EFAULT;
 +			} else {
 +				/* Check if this message came from a registered application */
 +				for (i =3D 0; i < MAX_NUM_APP; i++) {
 +					if (ft1000dev->app_info[i].fileobject =3D=3D &file->f_owner) {
 +						break;
 +					}
 +				}
 +				if (i =3D=3D MAX_NUM_APP) {
 +					pr_debug("No matching application fileobject\n");
 +					result =3D -EINVAL;
 +					kfree(dpram_data);
 +					break;
 +				}
 +				app_index =3D i;
 +
 +				/* Check message qtype type which is the lower byte within qos_class =
*/
 +				qtype =3D ntohs(dpram_data->pseudohdr.qos_class) & 0xff;
 +				/* pr_debug("qtype =3D %d\n", qtype); */
 +				if (qtype) {
 +				} else {
 +					/* Put message into Slow Queue */
 +					/* Only put a message into the DPRAM if msg doorbell is available */
 +					status =3D ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DOO=
RBELL);
 +					/* pr_debug("READ REGISTER tempword=3D%x\n", tempword); */
 +					if (tempword & FT1000_DB_DPRAM_TX) {
 +						/* Suspend for 2ms and try again due to DSP doorbell busy */
 +						mdelay(2);
 +						status =3D ft1000_read_register(ft1000dev, &tempword, FT1000_REG_DO=
ORBELL);
 +						if (tempword & FT1000_DB_DPRAM_TX) {
 +							/* Suspend for 1ms and try again due to DSP doorbell busy */
 +							mdelay(1);
 +							status =3D ft1000_read_register(ft1000dev, &tempword, FT1000_REG_D=
OORBELL);
 +							if (tempword & FT1000_DB_DPRAM_TX) {
 +								status =3D ft1000_read_register(ft1000dev, &tempword, FT1000_REG_=
DOORBELL);
 +								if (tempword & FT1000_DB_DPRAM_TX) {
 +									/* Suspend for 3ms and try again due to DSP doorbell busy */
 +									mdelay(3);
 +									status =3D ft1000_read_register(ft1000dev, &tempword, FT1000_REG=
_DOORBELL);
 +									if (tempword & FT1000_DB_DPRAM_TX) {
 +										pr_debug("Doorbell not available\n");
 +										result =3D -ENOTTY;
 +										kfree(dpram_data);
 +										break;
 +									}
 +								}
 +							}
 +						}
 +					}
 +
 +					/*pr_debug("finished reading register\n"); */
 +
 +					/* Make sure we are within the limits of the slow queue memory limit=
ation */
 +					if ((msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ)) {
 +						/* Need to put sequence number plus new checksum for message */
 +						pmsg =3D (u16 *)&dpram_data->pseudohdr;
 +						ppseudo_hdr =3D (struct pseudo_hdr *)pmsg;
 +						total_len =3D msgsz+2;
 +						if (total_len & 0x1) {
 +							total_len++;
 +						}
 +
 +						/* Insert slow queue sequence number */
 +						ppseudo_hdr->seq_num =3D info->squeseqnum++;
 +						ppseudo_hdr->portsrc =3D ft1000dev->app_info[app_index].app_id;
 +						/* Calculate new checksum */
 +						ppseudo_hdr->checksum =3D *pmsg++;
 +						/* pr_debug("checksum =3D 0x%x\n", ppseudo_hdr->checksum); */
 +						for (i =3D 1; i < 7; i++) {
 +							ppseudo_hdr->checksum ^=3D *pmsg++;
 +							/* pr_debug("checksum =3D 0x%x\n", ppseudo_hdr->checksum); */
 +						}
 +						pmsg++;
 +						ppseudo_hdr =3D (struct pseudo_hdr *)pmsg;
 +						result =3D card_send_command(ft1000dev, (unsigned short *)dpram_dat=
a, total_len+2);
 +
 +
 +						ft1000dev->app_info[app_index].nTxMsg++;
 +					} else {
 +						result =3D -EINVAL;
 +					}
 +				}
 +			}
 +		} else {
 +			pr_debug("Card not ready take messages\n");
 +			result =3D -EACCES;
 +		}
 +		kfree(dpram_data);
 +
 +	}
 +	break;
 +	case IOCTL_GET_DPRAM_CMD:
 +	{
  		struct dpram_blk *pdpram_blk;
  		struct IOCTL_DPRAM_BLK __user *pioctl_dpram;
 -            int msglen;
 -
 -            /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM called\=
n"); */
 -
 -            if (ft1000_flarion_cnt =3D=3D 0) {
 -                return (-EBADF);
 -            }
 -
 -            /* Search for matching file object */
 -            for (i=3D0; i<MAX_NUM_APP; i++) {
 -                if (ft1000dev->app_info[i].fileobject =3D=3D &file->f_own=
er) {
 -                    /*DEBUG("FT1000:ft1000_ioctl: Message is for AppId =
=3D %d\n", ft1000dev->app_info[i].app_id); */
 -                    break;
 -                }
 -            }
 -
 -            /* Could not find application info block */
 -            if (i =3D=3D MAX_NUM_APP) {
 -                DEBUG("FT1000:ft1000_ioctl:Could not find application inf=
o block\n");
 -                result =3D -EBADF;
 -                break;
 -            }
 -
 -            result =3D 0;
 -            pioctl_dpram =3D argp;
 -            if (list_empty(&ft1000dev->app_info[i].app_sqlist) =3D=3D 0) {
 -                /* DEBUG("FT1000:ft1000_ioctl:Message detected in slow qu=
eue\n"); */
 -                spin_lock_irqsave(&free_buff_lock, flags);
 -                pdpram_blk =3D list_entry(ft1000dev->app_info[i].app_sqli=
st.next, struct dpram_blk, list);
 -                list_del(&pdpram_blk->list);
 -                ft1000dev->app_info[i].NumOfMsg--;
 -                /* DEBUG("FT1000:ft1000_ioctl:NumOfMsg for app %d =3D %d\=
n", i, ft1000dev->app_info[i].NumOfMsg); */
 -                spin_unlock_irqrestore(&free_buff_lock, flags);
 -                msglen =3D ntohs(*(u16 *)pdpram_blk->pbuffer) + PSEUDOSZ;
 -                result =3D get_user(msglen, &pioctl_dpram->total_len);
 -		if (result)
 -			break;
 -		msglen =3D htons(msglen);
 -                /* DEBUG("FT1000:ft1000_ioctl:msg length =3D %x\n", msgle=
n); */
 -                if (copy_to_user (&pioctl_dpram->pseudohdr, pdpram_blk->p=
buffer, msglen)) {
 -					DEBUG("FT1000:ft1000_ioctl: copy fault occurred\n");
 -			result =3D -EFAULT;
 +		int msglen;
 +
 +		/* pr_debug("IOCTL_FT1000_GET_DPRAM called\n"); */
 +
 +		if (ft1000_flarion_cnt =3D=3D 0)
 +			return -EBADF;
 +
 +		/* Search for matching file object */
 +		for (i =3D 0; i < MAX_NUM_APP; i++) {
 +			if (ft1000dev->app_info[i].fileobject =3D=3D &file->f_owner) {
 +				/*pr_debug("Message is for AppId =3D %d\n", ft1000dev->app_info[i].ap=
p_id); */
 +				break;
 +			}
 +		}
 +
 +		/* Could not find application info block */
 +		if (i =3D=3D MAX_NUM_APP) {
 +			pr_debug("Could not find application info block\n");
 +			result =3D -EBADF;
  			break;
 -				}
 +		}
 +
 +		result =3D 0;
 +		pioctl_dpram =3D argp;
 +		if (list_empty(&ft1000dev->app_info[i].app_sqlist) =3D=3D 0) {
 +			/* pr_debug("Message detected in slow queue\n"); */
 +			spin_lock_irqsave(&free_buff_lock, flags);
 +			pdpram_blk =3D list_entry(ft1000dev->app_info[i].app_sqlist.next, stru=
ct dpram_blk, list);
 +			list_del(&pdpram_blk->list);
 +			ft1000dev->app_info[i].NumOfMsg--;
 +			/* pr_debug("NumOfMsg for app %d =3D %d\n", i, ft1000dev->app_info[i].=
NumOfMsg); */
 +			spin_unlock_irqrestore(&free_buff_lock, flags);
 +			msglen =3D ntohs(*(u16 *)pdpram_blk->pbuffer) + PSEUDOSZ;
 +			result =3D get_user(msglen, &pioctl_dpram->total_len);
 +			if (result)
 +				break;
 +			msglen =3D htons(msglen);
 +			/* pr_debug("msg length =3D %x\n", msglen); */
 +			if (copy_to_user(&pioctl_dpram->pseudohdr, pdpram_blk->pbuffer, msglen=
)) {
 +				pr_debug("copy fault occurred\n");
 +				result =3D -EFAULT;
 +				break;
 +			}
 +
 +			ft1000_free_buffer(pdpram_blk, &freercvpool);
 +			result =3D msglen;
 +		}
 +		/* pr_debug("IOCTL_FT1000_GET_DPRAM no message\n"); */
 +	}
 +	break;
 =20
 -                ft1000_free_buffer(pdpram_blk, &freercvpool);
 -                result =3D msglen;
 -            }
 -            /* DEBUG("FT1000:ft1000_ioctl: IOCTL_FT1000_GET_DPRAM no mess=
age\n"); */
 -        }
 -        break;
 -
 -    default:
 -        DEBUG("FT1000:ft1000_ioctl:unknown command: 0x%x\n", command);
 -        result =3D -ENOTTY;
 -        break;
 -    }
 -    ft1000dev->fAppMsgPend =3D 0;
 -    return result;
 +	default:
 +		pr_debug("unknown command: 0x%x\n", command);
 +		result =3D -ENOTTY;
 +		break;
 +	}
 +	ft1000dev->fAppMsgPend =3D 0;
 +	return result;
  }
 =20
  /*

--Sig_/gF1Z3S4y4CPHV3U_k2.YlRG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWv5EAAoJEMDTa8Ir7ZwVO1kP/jnBWROzqVB6vXTBkP7IZURY
te8X1L1OORWLmZbn3b8W7TY0vJoVNA8cA8eusuXi6+Dah6FBofwTKTrBITmNPjuT
rEHtI3Emj/QLnAaDIrFUF5JGl4YDyVRr9ILY3KhQrIH2q+gRsisTdM6eXFJxHwXn
r69OrsCNOoFOcfNHPjKj1U4qrGyF7XQLrHZOC/SWKW0Z7puKcjZ6ICJrWtYfI8FC
1A4fexARdkE9tsfbzKlGOY5HF0OAKY9Cv6uH2B+mIFp4NnAQx2vmfDtgauOOIjp2
OWKIOeitCgyELZaXcS6oqklOce8Nia7RRhPqUQ7M4rfJO60lpCecnYWREzd0OZ/s
3RM7DQHPpn4g3WgpsgaW9JcjpJv0KYatNPPaPRBLbp+7WMa/NbMMzrl7heUvD8B6
kI1hKWqZ0tzOw85fDtqdxc70YXEn+paXGDAIe6eYPX8a3JFxCRRTYy0jLZeUVl0W
MICTHskHeKQTMKMduyp6PIpEgW/gqBVLhyawVDRZrK3Y/EctUX1uXv1Ai6gDAx9f
dQ0DLCrl0yD61qSvuOyWyuDUZPeXhN2zDgSGMR8aRxKRWSOtL4nE//aAgewP97j0
QVqfkKox86bt7m/iHLws4eGwTj+MfeWVQ0hSZP2G7dGhoqgXStCzP+lmzlu3Cax1
/rdjDoQfAU0Z+TEflOzL
=43DM
-----END PGP SIGNATURE-----

--Sig_/gF1Z3S4y4CPHV3U_k2.YlRG--

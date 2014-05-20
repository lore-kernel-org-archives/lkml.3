Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaETLOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:14:23 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:32565 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaETLOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:14:21 -0400
Message-ID: <537B38FF.4050106@bfs.de>
Date: Tue, 20 May 2014 13:14:07 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>, kernel-janitors@vger.kernel.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] staging: r8712u: Remove useless return variables
References: <1400582028-24990-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1400582028-24990-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 20.05.2014 12:33, schrieb Peter Senna Tschudin:
> This patch remove variables that are initialized with a constant,
> are never updated, and are only used as parameter of return.
> Return the constant instead of using a variable.
> 
> Verified by compilation only.
> 
> The coccinelle script that find and fixes this issue is:
> // <smpl>
> @@
> type T;
> constant C;
> identifier ret;
> @@
> - T ret = C;
> ... when != ret
> - return ret;
> + return C;
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> ---
>  drivers/staging/rtl8712/ieee80211.c        |    8 ++--
>  drivers/staging/rtl8712/rtl8712_cmd.c      |    3 -
>  drivers/staging/rtl8712/rtl8712_recv.c     |    7 +---
>  drivers/staging/rtl8712/rtl871x_mlme.c     |    3 -
>  drivers/staging/rtl8712/rtl871x_mp.c       |    3 -
>  drivers/staging/rtl8712/rtl871x_mp_ioctl.c |   49 +++++++++--------------------
>  drivers/staging/rtl8712/rtl871x_recv.c     |    4 --
>  7 files changed, 26 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/staging/rtl8712/ieee80211.c b/drivers/staging/rtl8712/ieee80211.c
> index 57fef70..fe9459e 100644
> --- a/drivers/staging/rtl8712/ieee80211.c
> +++ b/drivers/staging/rtl8712/ieee80211.c
> @@ -289,7 +289,7 @@ static int r8712_get_wpa2_cipher_suite(u8 *s)
>  int r8712_parse_wpa_ie(u8 *wpa_ie, int wpa_ie_len, int *group_cipher,
>  		 int *pairwise_cipher)
>  {
> -	int i, ret = _SUCCESS;
> +	int i;
>  	int left, count;
>  	u8 *pos;
>  
> @@ -324,13 +324,13 @@ int r8712_parse_wpa_ie(u8 *wpa_ie, int wpa_ie_len, int *group_cipher,
>  		}
>  	} else if (left == 1)
>  		return _FAIL;
> -	return ret;
> +	return _SUCCESS;
>  }
>  
>  int r8712_parse_wpa2_ie(u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
>  		  int *pairwise_cipher)
>  {
> -	int i, ret = _SUCCESS;
> +	int i;
>  	int left, count;
>  	u8 *pos;
>  
> @@ -364,7 +364,7 @@ int r8712_parse_wpa2_ie(u8 *rsn_ie, int rsn_ie_len, int *group_cipher,
>  		}
>  	} else if (left == 1)
>  		return _FAIL;
> -	return ret;
> +	return _SUCCESS;
>  }
>  
>  int r8712_get_sec_ie(u8 *in_ie, uint in_len, u8 *rsn_ie, u16 *rsn_len,
> diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
> index 1a4b7a6..8ca7d7e 100644
> --- a/drivers/staging/rtl8712/rtl8712_cmd.c
> +++ b/drivers/staging/rtl8712/rtl8712_cmd.c
> @@ -290,8 +290,7 @@ static struct cmd_obj *cmd_hdl_filter(struct _adapter *padapter,
>  
>  static u8 check_cmd_fifo(struct _adapter *padapter, uint sz)
>  {
> -	u8 res = _SUCCESS;
> -	return res;
> +	return _SUCCESS;
>  }
>  

Is this function still needed ?


>  u8 r8712_fw_cmd(struct _adapter *pAdapter, u32 cmd)
> diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
> index 0723b2f..667398a 100644
> --- a/drivers/staging/rtl8712/rtl8712_recv.c
> +++ b/drivers/staging/rtl8712/rtl8712_recv.c
> @@ -123,8 +123,6 @@ void r8712_free_recv_priv(struct recv_priv *precvpriv)
>  
>  int r8712_init_recvbuf(struct _adapter *padapter, struct recv_buf *precvbuf)
>  {
> -	int res = _SUCCESS;
> -
>  	precvbuf->transfer_len = 0;
>  	precvbuf->len = 0;
>  	precvbuf->ref_cnt = 0;
> @@ -134,7 +132,7 @@ int r8712_init_recvbuf(struct _adapter *padapter, struct recv_buf *precvbuf)
>  		precvbuf->ptail = precvbuf->pbuf;
>  		precvbuf->pend = precvbuf->pdata + MAX_RECVBUF_SZ;
>  	}
> -	return res;
> +	return _SUCCESS;
>  }
>  
>  int r8712_free_recvframe(union recv_frame *precvframe,
> @@ -347,7 +345,6 @@ static int amsdu_to_msdu(struct _adapter *padapter, union recv_frame *prframe)
>  	_pkt *sub_skb, *subframes[MAX_SUBFRAME_COUNT];
>  	struct recv_priv *precvpriv = &padapter->recvpriv;
>  	struct  __queue *pfree_recv_queue = &(precvpriv->free_recv_queue);
> -	int	ret = _SUCCESS;
>  
>  	nr_subframes = 0;
>  	pattrib = &prframe->u.hdr.attrib;
> @@ -435,7 +432,7 @@ static int amsdu_to_msdu(struct _adapter *padapter, union recv_frame *prframe)
>  exit:
>  	prframe->u.hdr.len = 0;
>  	r8712_free_recvframe(prframe, pfree_recv_queue);
> -	return ret;
> +	return _SUCCESS;
>  }
>  
>  void r8712_rxcmd_event_hdl(struct _adapter *padapter, void *prxcmdbuf)
> diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
> index 3ea99ae..05d6e65 100644
> --- a/drivers/staging/rtl8712/rtl871x_mlme.c
> +++ b/drivers/staging/rtl8712/rtl871x_mlme.c
> @@ -1211,7 +1211,6 @@ sint r8712_set_auth(struct _adapter *adapter,
>  	struct cmd_priv	*pcmdpriv = &adapter->cmdpriv;
>  	struct cmd_obj *pcmd;
>  	struct setauth_parm *psetauthparm;
> -	sint ret = _SUCCESS;
>  
>  	pcmd = (struct cmd_obj *)_malloc(sizeof(struct cmd_obj));
>  	if (pcmd == NULL)
> @@ -1232,7 +1231,7 @@ sint r8712_set_auth(struct _adapter *adapter,
>  	pcmd->rspsz = 0;
>  	_init_listhead(&pcmd->list);
>  	r8712_enqueue_cmd(pcmdpriv, pcmd);
> -	return ret;
> +	return _SUCCESS;
>  }
>  
>  sint r8712_set_key(struct _adapter *adapter,
> diff --git a/drivers/staging/rtl8712/rtl871x_mp.c b/drivers/staging/rtl8712/rtl871x_mp.c
> index 0563318..5fd60cd 100644
> --- a/drivers/staging/rtl8712/rtl871x_mp.c
> +++ b/drivers/staging/rtl8712/rtl871x_mp.c
> @@ -80,9 +80,8 @@ _exit_init_mp_priv:
>  
>  static int free_mp_priv(struct mp_priv *pmp_priv)
>  {
> -	int res = 0;
>  	kfree(pmp_priv->pallocated_mp_xmitframe_buf);
> -	return res;
> +	return 0;
>  }


Is this function realy needed and why must it return int ?


>  void mp871xinit(struct _adapter *padapter)
> diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
> index 5bd4296..9827ff8 100644
> --- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
> +++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
> @@ -66,7 +66,6 @@ uint oid_rt_wireless_mode_hdl(struct oid_par_priv *poid_par_priv)
>  
>  uint oid_rt_pro_write_bb_reg_hdl(struct oid_par_priv *poid_par_priv)
>  {
> -	uint status = RNDIS_STATUS_SUCCESS;
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
>  	struct bb_reg_param *pbbreg;
> @@ -83,12 +82,11 @@ uint oid_rt_pro_write_bb_reg_hdl(struct oid_par_priv *poid_par_priv)
>  		offset |= BB_REG_BASE_ADDR;
>  	value = pbbreg->value;
>  	r8712_bb_reg_write(Adapter, offset, value);
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_pro_read_bb_reg_hdl(struct oid_par_priv *poid_par_priv)
>  {
> -	uint status = RNDIS_STATUS_SUCCESS;
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
>  	struct bb_reg_param *pbbreg;
> @@ -106,12 +104,11 @@ uint oid_rt_pro_read_bb_reg_hdl(struct oid_par_priv *poid_par_priv)
>  	value = r8712_bb_reg_read(Adapter, offset);
>  	pbbreg->value = value;
>  	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_pro_write_rf_reg_hdl(struct oid_par_priv *poid_par_priv)
>  {
> -	uint status = RNDIS_STATUS_SUCCESS;
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
>  	struct rf_reg_param *pbbreg;
> @@ -130,14 +127,13 @@ uint oid_rt_pro_write_rf_reg_hdl(struct oid_par_priv *poid_par_priv)
>  	offset = (u8)pbbreg->offset;
>  	value = pbbreg->value;
>  	r8712_rf_reg_write(Adapter, path, offset, value);
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_pro_read_rf_reg_hdl(struct oid_par_priv *poid_par_priv)
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  	struct rf_reg_param *pbbreg;
>  	u8 path;
>  	u8 offset;
> @@ -155,7 +151,7 @@ uint oid_rt_pro_read_rf_reg_hdl(struct oid_par_priv *poid_par_priv)
>  	value = r8712_rf_reg_read(Adapter, path, offset);
>  	pbbreg->value = value;
>  	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  /*This function initializes the DUT to the MP test mode*/
> @@ -266,7 +262,6 @@ uint oid_rt_pro_set_data_rate_hdl(struct oid_par_priv
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  	u32 ratevalue;
>  
>  	if (poid_par_priv->type_of_oid != SET_OID)
> @@ -278,7 +273,7 @@ uint oid_rt_pro_set_data_rate_hdl(struct oid_par_priv
>  		return RNDIS_STATUS_INVALID_DATA;
>  	Adapter->mppriv.curr_rateidx = ratevalue;
>  	r8712_SetDataRate(Adapter);
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_pro_start_test_hdl(struct oid_par_priv *poid_par_priv)
> @@ -328,7 +323,6 @@ uint oid_rt_pro_set_channel_direct_call_hdl(struct oid_par_priv
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  	u32		Channel;
>  
>  	if (poid_par_priv->type_of_oid != SET_OID)
> @@ -340,14 +334,13 @@ uint oid_rt_pro_set_channel_direct_call_hdl(struct oid_par_priv
>  		return RNDIS_STATUS_NOT_ACCEPTED;
>  	Adapter->mppriv.curr_ch = Channel;
>  	r8712_SetChannel(Adapter);
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_pro_set_antenna_bb_hdl(struct oid_par_priv *poid_par_priv)
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  	u32 antenna;
>  
>  	if (poid_par_priv->type_of_oid != SET_OID)
> @@ -358,7 +351,7 @@ uint oid_rt_pro_set_antenna_bb_hdl(struct oid_par_priv *poid_par_priv)
>  	Adapter->mppriv.antenna_tx = (u16)((antenna & 0xFFFF0000) >> 16);
>  	Adapter->mppriv.antenna_rx = (u16)(antenna & 0x0000FFFF);
>  	r8712_SwitchAntenna(Adapter);
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_pro_set_tx_power_control_hdl(
> @@ -366,7 +359,6 @@ uint oid_rt_pro_set_tx_power_control_hdl(
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  	u32 tx_pwr_idx;
>  
>  	if (poid_par_priv->type_of_oid != SET_OID)
> @@ -378,7 +370,7 @@ uint oid_rt_pro_set_tx_power_control_hdl(
>  		return RNDIS_STATUS_NOT_ACCEPTED;
>  	Adapter->mppriv.curr_txpoweridx = (u8)tx_pwr_idx;
>  	r8712_SetTxPower(Adapter);
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_pro_query_tx_packet_sent_hdl(
> @@ -839,7 +831,6 @@ uint oid_rt_poll_rx_status_hdl(struct oid_par_priv *poid_par_priv)
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  
>  	if (poid_par_priv->type_of_oid != QUERY_OID)
>  		return RNDIS_STATUS_NOT_ACCEPTED;
> @@ -847,7 +838,7 @@ uint oid_rt_poll_rx_status_hdl(struct oid_par_priv *poid_par_priv)
>  		(unsigned char *)&Adapter->mppriv.rxstat,
>  		sizeof(struct recv_stat));
>  	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_pro_cfg_debug_message_hdl(struct oid_par_priv
> @@ -875,7 +866,6 @@ uint oid_rt_get_thermal_meter_hdl(struct oid_par_priv *poid_par_priv)
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  
>  	if (poid_par_priv->type_of_oid != QUERY_OID)
>  		return RNDIS_STATUS_NOT_ACCEPTED;
> @@ -897,7 +887,7 @@ uint oid_rt_get_thermal_meter_hdl(struct oid_par_priv *poid_par_priv)
>  	*(u32 *)poid_par_priv->information_buf =
>  				 Adapter->mppriv.workparam.io_value;
>  	*poid_par_priv->bytes_rw = sizeof(u32);
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_pro_set_power_tracking_hdl(struct oid_par_priv
> @@ -1091,7 +1081,6 @@ uint oid_rt_pro_dele_sta_info_hdl(struct oid_par_priv *poid_par_priv)
>  				   (poid_par_priv->adapter_context);
>  
>  	unsigned long			irqL;
> -	uint status = RNDIS_STATUS_SUCCESS;
>  
>  	struct sta_info		*psta = NULL;
>  	u8			*macaddr;
> @@ -1113,7 +1102,7 @@ uint oid_rt_pro_dele_sta_info_hdl(struct oid_par_priv *poid_par_priv)
>  		spin_unlock_irqrestore(&(Adapter->stapriv.sta_hash_lock), irqL);
>  	}
>  
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  /*--------------------------------------------------------------------------*/
>  static u32 mp_query_drv_var(struct _adapter *padapter, u8 offset, u32 var)
> @@ -1126,8 +1115,6 @@ uint oid_rt_pro_query_dr_variable_hdl(struct oid_par_priv *poid_par_priv)
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
>  
> -	uint status = RNDIS_STATUS_SUCCESS;
> -
>  	struct DR_VARIABLE_STRUCT *pdrv_var;
>  
>  	if (poid_par_priv->type_of_oid != QUERY_OID)
> @@ -1139,7 +1126,7 @@ uint oid_rt_pro_query_dr_variable_hdl(struct oid_par_priv *poid_par_priv)
>  	pdrv_var->variable = mp_query_drv_var(Adapter, pdrv_var->offset,
>  					      pdrv_var->variable);
>  	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  /*--------------------------------------------------------------------------*/
> @@ -1243,7 +1230,6 @@ uint oid_rt_get_efuse_current_size_hdl(struct oid_par_priv
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  
>  	if (poid_par_priv->type_of_oid != QUERY_OID)
>  		return RNDIS_STATUS_NOT_ACCEPTED;
> @@ -1254,14 +1240,13 @@ uint oid_rt_get_efuse_current_size_hdl(struct oid_par_priv
>  				 r8712_efuse_get_current_size(Adapter);
>  	r8712_efuse_reg_uninit(Adapter);
>  	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_get_efuse_max_size_hdl(struct oid_par_priv *poid_par_priv)
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  
>  	if (poid_par_priv->type_of_oid != QUERY_OID)
>  		return RNDIS_STATUS_NOT_ACCEPTED;
> @@ -1270,7 +1255,7 @@ uint oid_rt_get_efuse_max_size_hdl(struct oid_par_priv *poid_par_priv)
>  	*(int *)poid_par_priv->information_buf =
>  					 r8712_efuse_get_max_size(Adapter);
>  	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_pro_efuse_hdl(struct oid_par_priv *poid_par_priv)
> @@ -1320,7 +1305,6 @@ uint oid_rt_set_bandwidth_hdl(struct oid_par_priv *poid_par_priv)
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  	u32		bandwidth;
>  
>  	if (poid_par_priv->type_of_oid != SET_OID)
> @@ -1332,14 +1316,13 @@ uint oid_rt_set_bandwidth_hdl(struct oid_par_priv *poid_par_priv)
>  		bandwidth = HT_CHANNEL_WIDTH_40;
>  	Adapter->mppriv.curr_bandwidth = (u8)bandwidth;
>  	r8712_SwitchBandwidth(Adapter);
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_set_crystal_cap_hdl(struct oid_par_priv *poid_par_priv)
>  {
>  	struct _adapter *Adapter = (struct _adapter *)
>  				   (poid_par_priv->adapter_context);
> -	uint status = RNDIS_STATUS_SUCCESS;
>  	u32		crystal_cap = 0;
>  
>  	if (poid_par_priv->type_of_oid != SET_OID)
> @@ -1351,7 +1334,7 @@ uint oid_rt_set_crystal_cap_hdl(struct oid_par_priv *poid_par_priv)
>  		return RNDIS_STATUS_NOT_ACCEPTED;
>  	Adapter->mppriv.curr_crystalcap = crystal_cap;
>  	r8712_SetCrystalCap(Adapter);
> -	return status;
> +	return RNDIS_STATUS_SUCCESS;
>  }
>  
>  uint oid_rt_set_rx_packet_type_hdl(struct oid_par_priv
> diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
> index 274c359..4ac4a1b 100644
> --- a/drivers/staging/rtl8712/rtl871x_recv.c
> +++ b/drivers/staging/rtl8712/rtl871x_recv.c
> @@ -605,8 +605,6 @@ sint r8712_wlanhdr_to_ethhdr(union recv_frame *precvframe)
>  	u8	bsnaphdr;
>  	u8	*psnap_type;
>  	struct ieee80211_snap_hdr *psnap;
> -
> -	sint ret = _SUCCESS;
>  	struct _adapter	*adapter = precvframe->u.hdr.adapter;
>  	struct mlme_priv *pmlmepriv = &adapter->mlmepriv;
>  
> @@ -653,7 +651,7 @@ sint r8712_wlanhdr_to_ethhdr(union recv_frame *precvframe)
>  		len = htons(len);
>  		memcpy(ptr + 12, &len, 2);
>  	}
> -	return ret;
> +	return _SUCCESS;
>  }
>  
>  s32 r8712_recv_entry(union recv_frame *precvframe)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaDAON0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:13:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18182 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAONY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:13:24 -0400
Date: Tue, 1 Apr 2014 17:13:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        Ezequiel =?iso-8859-1?Q?Garc=EDa?= 
	<ezequiel@vanguardiasur.com.ar>,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH 3/3] staging: vt6655: fix checkpatch bracing issues
Message-ID: <20140401141302.GT6991@mwanda>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
 <1396356733-5344-4-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396356733-5344-4-git-send-email-guido@vanguardiasur.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 09:52:13AM -0300, Guido Martínez wrote:
> @@ -624,13 +622,10 @@ device_receive_frame(
>  
>  // Data frame Handle
>  
> -	if (pDevice->bEnablePSMode) {
> -		if (!IS_FC_MOREDATA((skb->data+4))) {
> +	if (pDevice->bEnablePSMode)
> +		if (!IS_FC_MOREDATA((skb->data+4)))
>  			if (pDevice->pMgmt->bInTIMWake == true)
>  				pDevice->pMgmt->bInTIMWake = false;
> -			}
> -		}
> -	}

Use braces for multi-line indents for readability.

> @@ -1502,26 +1501,26 @@ int iwctl_siwauth(struct net_device *dev,
>  		break;
>  	case IW_AUTH_CIPHER_PAIRWISE:
>  		pairwise = wrq->value;
> -		if (pairwise == IW_AUTH_CIPHER_CCMP) {
> +		if (pairwise == IW_AUTH_CIPHER_CCMP)
>  			pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
> -		} else if (pairwise == IW_AUTH_CIPHER_TKIP) {
> +		else if (pairwise == IW_AUTH_CIPHER_TKIP)
>  			pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
> -		} else if (pairwise == IW_AUTH_CIPHER_WEP40 || pairwise == IW_AUTH_CIPHER_WEP104) {
> +		else if (pairwise == IW_AUTH_CIPHER_WEP40 || pairwise == IW_AUTH_CIPHER_WEP104)
>  			pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
> -		} else if (pairwise == IW_AUTH_CIPHER_NONE) {
> -			//do nothing,einsn liu
> -		} else pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
> +		else if (pairwise == IW_AUTH_CIPHER_NONE)
> +			; //do nothing,einsn liu
> +		else
> +		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
>  

The indenting is messed up on the last else statement.

> @@ -276,24 +276,20 @@ PSbSendNullPacket(
>  	PSMgmtObject        pMgmt = pDevice->pMgmt;
>  	unsigned int uIdx;
>  
> -	if (!pDevice->bLinkPass) {
> +	if (!pDevice->bLinkPass)
>  		return false;
> -	}
> +
>  #ifdef TxInSleep
> -	if (!pDevice->bEnablePSMode && !pDevice->fTxDataInSleep) {
> +	if (!pDevice->bEnablePSMode && !pDevice->fTxDataInSleep)
>  		return false;
> -	}
>  #else
> -	if (!pDevice->bEnablePSMode) {
> +	if (!pDevice->bEnablePSMode)
>  		return false;
> -	}
>  #endif
> -	if (pDevice->bEnablePSMode) {
> -		for (uIdx = 0; uIdx < TYPE_MAXTD; uIdx++) {
> +	if (pDevice->bEnablePSMode)
> +		for (uIdx = 0; uIdx < TYPE_MAXTD; uIdx++)
>  			if (pDevice->iTDUsed[uIdx] != 0)
>  				return false;
> -		}
> -	}


Multi-line indent.


> @@ -4285,14 +4252,9 @@ vMgrRxManagePacket(
>  
>  	case WLAN_FSTYPE_BEACON:
>  		// Frame Clase = 0
> -<<<<<<< HEAD
> -		//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx beacon\n");
> -		if (pMgmt->eScanState != WMAC_NO_SCANNING) {
> -=======
>  		if (pMgmt->eScanState != WMAC_NO_SCANNING)
> ->>>>>>> f3c59ed... staging: vt6655: remove dead code
>  			bInScan = true;
> -		}
> +
>  		s_vMgrRxBeacon(pDevice, pMgmt, pRxPacket, bInScan);
>  		break;
>  
> @@ -4357,16 +4319,11 @@ bMgrPrepareBeaconToSend(
>  	PSDevice            pDevice = (PSDevice)hDeviceContext;
>  	PSTxMgmtPacket      pTxPacket;
>  
> -<<<<<<< HEAD
> -//    pDevice->bBeaconBufReady = false;
> -	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x) {
> -=======
>  	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x)
> ->>>>>>> f3c59ed... staging: vt6655: remove dead code
>  		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
> -	} else {
> +	else
>  		pMgmt->wCurrCapInfo &= ~WLAN_SET_CAP_INFO_PRIVACY(1);
> -	}
> +

Wat?

regards,
dan carpenter


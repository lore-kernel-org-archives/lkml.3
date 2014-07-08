Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaGHHnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:43:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37157 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbaGHHnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:43:40 -0400
Date: Tue, 8 Jul 2014 10:43:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, rmfrfs@gmail.com,
        peter.senna@gmail.com, linux-kernel@vger.kernel.org,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: Re: [PATCH] staging: rtl8192u: fix checkpatch error/warning in
 r819xU_phy.c
Message-ID: <20140708074330.GD25880@mwanda>
References: <1404799458-8574-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404799458-8574-1-git-send-email-sanjeev_sharma@mentor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 11:34:18AM +0530, sanjeev sharma wrote:
> From: sanjeevs1 <sanjeev_sharma@mentor.com>
        ^^^^^^^^^
No.

> 
> This is a patch to the r819xU_phy.c file that fixes up all the Error/Warning found by the checkpatch.pl tool

Split it into one thing per patch.

> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/rtl8192u/r819xU_phy.c | 76 +++++++++++++++++------------------
>  1 file changed, 36 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
> index 02554c9..1dd1c1e 100644
> --- a/drivers/staging/rtl8192u/r819xU_phy.c
> +++ b/drivers/staging/rtl8192u/r819xU_phy.c
> @@ -101,16 +101,15 @@ void rtl8192_setBBreg(struct net_device *dev, u32 reg_addr, u32 bitmask,
>  	} else {
>  		write_nic_dword(dev, reg_addr, data);
>  	}
> -	return;
>  }
>  
>  /******************************************************************************
>   * function:  This function reads specific bits from BB register
>   * input:     net_device	*dev
> - *            u32	 	reg_addr   //target addr to be readback
> - *            u32	 	bitmask    //taget bit pos to be readback
> - * output:    none
> - * return:    u32	 	data       //the readback register value
> + * u32		reg_addr   //target addr to be readback
> + * u32		bitmask    //taget bit pos to be readback
> + * output:	none
> + * return:	u32		data       //the readback register value
>   * notice:
>   ******************************************************************************/
>  u32 rtl8192_QueryBBReg(struct net_device *dev, u32 reg_addr, u32 bitmask)
> @@ -192,7 +191,7 @@ static u32 rtl8192_phy_RFSerialRead(struct net_device *dev,
>  
>  
>  	/* TODO: we should not delay such a long time. Ask for help from SD3 */
> -	usleep_range(1000, 1000);
> +	usleep_range(1000, 2000);

No.

>  
>  	ret = rtl8192_QueryBBReg(dev, pPhyReg->rfLSSIReadBack,
>  				 bLSSIReadBackData);
> @@ -281,7 +280,6 @@ static void rtl8192_phy_RFSerialWrite(struct net_device *dev,
>  					 priv->RfReg0Value[eRFPath] << 16);
>  		}
>  	}
> -	return;
>  }
>  
>  /******************************************************************************
> @@ -332,7 +330,6 @@ void rtl8192_phy_SetRFReg(struct net_device *dev, RF90_RADIO_PATH_E eRFPath,
>  			rtl8192_phy_RFSerialWrite(dev, eRFPath, reg_addr, data);
>  		}
>  	}
> -	return;
>  }
>  
>  /******************************************************************************
> @@ -481,9 +478,9 @@ static void phy_FwRFSerialWrite(struct net_device *dev,
>  /******************************************************************************
>   * function:  This function reads BB parameters from header file we generate,
>   *            and do register read/write
> - * input:     net_device 	*dev
> - * output:    none
> - * return:    none
> + * input:	net_device	*dev
> + * output:	none
> + * return:	none
>   * notice:    BB parameters may change all the time, so please make
>   *            sure it has been synced with the newest.
>   *****************************************************************************/
> @@ -513,7 +510,6 @@ void rtl8192_phy_configmac(struct net_device *dev)
>  		rtl8192_setBBreg(dev, pdwArray[i], pdwArray[i+1],
>  				 pdwArray[i+2]);
>  	}
> -	return;
>  }
>  
>  /******************************************************************************
> @@ -559,7 +555,6 @@ void rtl8192_phyConfigBB(struct net_device *dev, u8 ConfigType)
>  				 rtl819XAGCTAB_Array[i+1]);
>  		}
>  	}
> -	return;
>  }
>  
>  /******************************************************************************
> @@ -746,11 +741,11 @@ u8 rtl8192_phy_checkBBAndRF(struct net_device *dev, HW90_BLOCK_E CheckBlock,
>  					     bMask12Bits, WriteData[i]);
>  			/* TODO: we should not delay for such a long time.
>  			   Ask SD3 */
> -			usleep_range(1000, 1000);
> +			usleep_range(1000, 2000);
>  			reg = rtl8192_phy_QueryRFReg(dev, eRFPath,
>  						     WriteAddr[HW90_BLOCK_RF],
>  						     bMask12Bits);
> -			usleep_range(1000, 1000);
> +			usleep_range(1000, 2000);

Don't do this without a better explanation and testing.

>  			break;
>  
>  		default:
> @@ -846,7 +841,6 @@ static void rtl8192_BB_Config_ParaFile(struct net_device *dev)
>  	priv->bCckHighPower = (u8)rtl8192_QueryBBReg(dev,
>  						     rFPGA0_XA_HSSIParameter2,
>  						     0x200);
> -	return;
>  }
>  
>  /******************************************************************************
> @@ -864,7 +858,6 @@ void rtl8192_BBConfig(struct net_device *dev)
>  	 * implemented, so use file first.
>  	 * FIXME: should implement it for hardcode? */
>  	rtl8192_BB_Config_ParaFile(dev);
> -	return;
>  }
>  
>  
> @@ -907,13 +900,11 @@ void rtl8192_phy_getTxPower(struct net_device *dev)
>  	read_nic_byte(dev, rOFDM0_RxDetector3, &priv->framesync);
>  	read_nic_byte(dev, rOFDM0_RxDetector2, &tmp);
>  	priv->framesyncC34 = tmp;
> -	RT_TRACE(COMP_INIT, "Default framesync (0x%x) = 0x%x \n",
> +	RT_TRACE(COMP_INIT, "Default framesync (0x%x) = 0x%x\n",
>  		rOFDM0_RxDetector3, priv->framesync);
>  
>  	/* Read SIFS (save the value read fome MACPHY_REG.txt) */
>  	read_nic_word(dev, SIFS, &priv->SifsTime);
> -
> -	return;
>  }
>  
>  /******************************************************************************
> @@ -942,7 +933,6 @@ void rtl8192_phy_setTxPower(struct net_device *dev, u8 channel)
>  			 __func__);
>  		break;
>  	}
> -	return;
>  }
>  
>  /******************************************************************************
> @@ -956,14 +946,13 @@ void rtl8192_phy_RFConfig(struct net_device *dev)
>  	struct r8192_priv *priv = ieee80211_priv(dev);
>  
>  	switch (priv->rf_chip) {
> -		case RF_8256:
> -			PHY_RF8256_Config(dev);
> -			break;
> -		default:
> -			RT_TRACE(COMP_ERR, "error chip id\n");
> -			break;
> +	case RF_8256:
> +		PHY_RF8256_Config(dev);
> +		break;
> +	default:
> +		RT_TRACE(COMP_ERR, "error chip id\n");
> +		break;
>  	}
> -	return;
>  }
>  
>  /******************************************************************************
> @@ -974,7 +963,6 @@ void rtl8192_phy_RFConfig(struct net_device *dev)
>   ******************************************************************************/
>  void rtl8192_phy_updateInitGain(struct net_device *dev)
>  {
> -	return;
>  }
>  
>  /******************************************************************************
> @@ -1094,7 +1082,6 @@ static void rtl8192_SetTxPowerLevel(struct net_device *dev, u8 channel)
>  		RT_TRACE(COMP_ERR, "unknown rf chip ID in %s()\n", __func__);
>  		break;
>  	}
> -	return;
>  }
>  
>  /******************************************************************************
> @@ -1190,10 +1177,12 @@ bool rtl8192_SetRFPowerState(struct net_device *dev,
>  				/* If Rf off reason is from IPS,
>  				   LED should blink with no link */
>  				if (pMgntInfo->RfOffReason == RF_CHANGE_BY_IPS)
> -					Adapter->HalFunc.LedControlHandler(Adapter, LED_CTL_NO_LINK);
> +					Adapter->HalFunc.LedControlHandler
> +					(Adapter, LED_CTL_NO_LINK);

The original was more readable.

>  				else
>  					/* Turn off LED if RF is not ON. */
> -					Adapter->HalFunc.LedControlHandler(Adapter, LED_CTL_POWER_OFF);
> +					Adapter->HalFunc.LedControlHandler
> +					(Adapter, LED_CTL_POWER_OFF);

No.

regards,
dan carpenter



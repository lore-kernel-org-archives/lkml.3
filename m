Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbaDVKVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:21:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21479 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbaDVKV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:21:26 -0400
Date: Tue, 22 Apr 2014 13:21:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navin.patidar@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] staging: rtl8188eu: Simplify led blinking strategy
 code.
Message-ID: <20140422102105.GH26890@mwanda>
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com>
 <1397983638-10752-5-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397983638-10752-5-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor white space complaints.

On Sun, Apr 20, 2014 at 02:17:13PM +0530, navin patidar wrote:
> @@ -1334,7 +316,7 @@ static void SwLedControlMode4(struct adapter *padapter, enum LED_CTL_MODE LedAct
>  			else
>  				pLed->BlinkingLedState = RTW_LED_ON;
>  			_set_timer(&(pLed->BlinkTimer), LED_BLINK_SCAN_INTERVAL_ALPHA);
> -		}
> +		 }
>  		break;
>  	case LED_CTL_TX:
>  	case LED_CTL_RX:
> @@ -1345,6 +327,10 @@ static void SwLedControlMode4(struct adapter *padapter, enum LED_CTL_MODE LedAct

A stray space character was accidentally added here.  You can fix minor
things like that in a later patch.

>  				_cancel_timer_ex(&(pLed->BlinkTimer));
>  				pLed->bLedNoLinkBlinkInProgress = false;
>  			}
> +			if (pLed->bLedLinkBlinkInProgress) {
> +				_cancel_timer_ex(&(pLed->BlinkTimer));
> +				pLed->bLedLinkBlinkInProgress = false;
> +			}
>  			pLed->bLedBlinkInProgress = true;
>  			pLed->CurrLedState = LED_BLINK_TXRX;
>  			pLed->BlinkTimes = 2;
> @@ -1357,22 +343,15 @@ static void SwLedControlMode4(struct adapter *padapter, enum LED_CTL_MODE LedAct
>  		break;
>  	case LED_CTL_START_WPS: /* wait until xinpin finish */
>  	case LED_CTL_START_WPS_BOTTON:
> -		if (pLed1->bLedWPSBlinkInProgress) {
> -			pLed1->bLedWPSBlinkInProgress = false;
> -			_cancel_timer_ex(&(pLed1->BlinkTimer));
> -
> -			pLed1->BlinkingLedState = RTW_LED_OFF;
> -			pLed1->CurrLedState = RTW_LED_OFF;
> -
> -			if (pLed1->bLedOn)
> -				_set_timer(&(pLed->BlinkTimer), 0);
> -		}
> -
> -		if (!pLed->bLedWPSBlinkInProgress) {
> +		 if (!pLed->bLedWPSBlinkInProgress) {

And another here.

>  			if (pLed->bLedNoLinkBlinkInProgress) {
>  				_cancel_timer_ex(&(pLed->BlinkTimer));
>  				pLed->bLedNoLinkBlinkInProgress = false;
>  			}
> +			if (pLed->bLedLinkBlinkInProgress) {
> +				_cancel_timer_ex(&(pLed->BlinkTimer));
> +				 pLed->bLedLinkBlinkInProgress = false;
> +			}
>  			if (pLed->bLedBlinkInProgress) {
>  				_cancel_timer_ex(&(pLed->BlinkTimer));
>  				pLed->bLedBlinkInProgress = false;
> @@ -1383,56 +362,44 @@ static void SwLedControlMode4(struct adapter *padapter, enum LED_CTL_MODE LedAct
>  			}
>  			pLed->bLedWPSBlinkInProgress = true;
>  			pLed->CurrLedState = LED_BLINK_WPS;
> -			if (pLed->bLedOn) {
> +			if (pLed->bLedOn)
>  				pLed->BlinkingLedState = RTW_LED_OFF;
> -				_set_timer(&(pLed->BlinkTimer), LED_BLINK_SLOWLY_INTERVAL);
> -			} else {
> +			else
>  				pLed->BlinkingLedState = RTW_LED_ON;
> -				_set_timer(&(pLed->BlinkTimer), LED_BLINK_NORMAL_INTERVAL);
> -			}
> -		}
> +			_set_timer(&(pLed->BlinkTimer), LED_BLINK_SCAN_INTERVAL_ALPHA);
> +		 }
>  		break;
> -	case LED_CTL_STOP_WPS:	/* WPS connect success */
> -		if (pLed->bLedWPSBlinkInProgress) {
> +	case LED_CTL_STOP_WPS:
> +		if (pLed->bLedNoLinkBlinkInProgress) {
>  			_cancel_timer_ex(&(pLed->BlinkTimer));
> -			pLed->bLedWPSBlinkInProgress = false;
> +			pLed->bLedNoLinkBlinkInProgress = false;
>  		}
> -
> -		pLed->bLedNoLinkBlinkInProgress = true;
> -		pLed->CurrLedState = LED_BLINK_SLOWLY;
> -		if (pLed->bLedOn)
> -			pLed->BlinkingLedState = RTW_LED_OFF;
> -		else
> -			pLed->BlinkingLedState = RTW_LED_ON;
> -		_set_timer(&(pLed->BlinkTimer), LED_BLINK_NO_LINK_INTERVAL_ALPHA);
> -
> -		break;
> -	case LED_CTL_STOP_WPS_FAIL:		/* WPS authentication fail */
> -		if (pLed->bLedWPSBlinkInProgress) {
> +		if (pLed->bLedLinkBlinkInProgress) {
>  			_cancel_timer_ex(&(pLed->BlinkTimer));
> -			pLed->bLedWPSBlinkInProgress = false;
> +			 pLed->bLedLinkBlinkInProgress = false;

Another here.

regards,
dan carpenter


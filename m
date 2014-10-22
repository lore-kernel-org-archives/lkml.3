Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbaJVJN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:13:27 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27491 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbaJVJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:13:24 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f956d000005ed7-bd-544775314e88
Content-transfer-encoding: 8BIT
Message-id: <1413969200.32084.0.camel@AMDC1943>
Subject: Re: [PATCH RESEND 3/3] extcon: max77693: Fix extcon UART on Trats2
 board
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Wed, 22 Oct 2014 11:13:20 +0200
In-reply-to: <54477456.2040702@samsung.com>
References: <1413967540-27626-1-git-send-email-k.kozlowski@samsung.com>
 <1413967540-27626-3-git-send-email-k.kozlowski@samsung.com>
 <54477456.2040702@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsVy+t/xa7qGpe4hBv+uSFlsnLGe1eL6l+es
	Fmeb3rBb3P96lNHi8q45bBZrj9xlt7jduILN4nQ3qwOHx51re9g85p0M9OjbsorR4/MmuQCW
	KC6blNSczLLUIn27BK6MYxtfsRXslarom8HTwLhDtIuRk0NCwETi/sKrLBC2mMSFe+vZuhi5
	OIQEljJKXJ6wiBUkwSsgKPFj8j2gIg4OZgF5iSOXskHCzALqEpPmLWIGsYUEPjNK7JnlCFGu
	L/F9yw82EFtYIFjix46FjCA2m4CxxOblS8DiIgIaEjP/XmEE2cUssJxJ4uGreWCDWARUJeYs
	fQpmcwpoS1zZehzqoGWMEhcP/GUCOUJCQFmisd9tAqPALCTnzUI4bxaS8xYwMq9iFE0tTS4o
	TkrPNdIrTswtLs1L10vOz93ECAnurzsYlx6zOsQowMGoxMPrwOYeIsSaWFZcmXuIUYKDWUmE
	9146UIg3JbGyKrUoP76oNCe1+BAjEwenVAOjZqHe3K0X3Gw99T3WSvVFTb1+T34nWxnv5N+r
	NZ5MqXw5n/VpveyFuWFd2+ecWPPmm+B+pitxP1M5tt/9uXjLx1gF88LAa4lKi7S+Vxp6rjUy
	j1Cr7eT8FZk8daJ0W7yS0rLfAmIc75f1JIbeEI1ruvOh4mXJm68FbV9zQn/PTuxK3bTvaNo+
	JZbijERDLeai4kQAEv4I8UwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-22 at 18:09 +0900, Chanwoo Choi wrote:
> On 10/22/2014 05:45 PM, Krzysztof Kozlowski wrote:
> > When JIG was set to "boot on" mode, the UART connection did not work
> > because it was assigned to Dock-Car cable (path: audio), not JIG-UART-ON
> > cable.
> > 
> > This was introduced in 39bf369e4ed3 ("extcon: max77693: Add support dock
> > device and buttons") while adding dock features.
> > 
> > Assign the JIG-UART-ON back to UART path.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> I want to change the name of this patch because I don't prefer to use board name on extcon driver patch.
> before - extcon: max77693: Fix extcon UART on Trats2 board
> after - extcon: max77693: Fix cable name of JIG_UART_ON

No problem, thanks!

> 
> Applied it.
> 
> Thanks,
> Chanwoo Choi
> 
> > ---
> >  drivers/extcon/extcon-max77693.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
> > index 9d21e75a7032..beaa8cd71c3b 100644
> > --- a/drivers/extcon/extcon-max77693.c
> > +++ b/drivers/extcon/extcon-max77693.c
> > @@ -206,7 +206,7 @@ static const char *max77693_extcon_cable[] = {
> >  	[EXTCON_CABLE_JIG_USB_ON]		= "JIG-USB-ON",
> >  	[EXTCON_CABLE_JIG_USB_OFF]		= "JIG-USB-OFF",
> >  	[EXTCON_CABLE_JIG_UART_OFF]		= "JIG-UART-OFF",
> > -	[EXTCON_CABLE_JIG_UART_ON]		= "Dock-Car",
> > +	[EXTCON_CABLE_JIG_UART_ON]		= "JIG-UART-ON",
> >  	[EXTCON_CABLE_DOCK_SMART]		= "Dock-Smart",
> >  	[EXTCON_CABLE_DOCK_DESK]		= "Dock-Desk",
> >  	[EXTCON_CABLE_DOCK_AUDIO]		= "Dock-Audio",
> > @@ -506,9 +506,6 @@ static int max77693_muic_dock_handler(struct max77693_muic_info *info,
> >  		extcon_set_cable_state(info->edev, "Dock-Smart", attached);
> >  		extcon_set_cable_state(info->edev, "MHL", attached);
> >  		goto out;
> > -	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* Dock-Car */
> > -		strcpy(dock_name, "Dock-Car");
> > -		break;
> >  	case MAX77693_MUIC_ADC_AUDIO_MODE_REMOTE:	/* Dock-Desk */
> >  		strcpy(dock_name, "Dock-Desk");
> >  		break;
> > @@ -643,6 +640,11 @@ static int max77693_muic_jig_handler(struct max77693_muic_info *info,
> >  		strcpy(cable_name, "JIG-UART-OFF");
> >  		path = CONTROL1_SW_UART;
> >  		break;
> > +	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* ADC_JIG_UART_ON */
> > +		/* PATH:AP_UART */
> > +		strcpy(cable_name, "JIG-UART-ON");
> > +		path = CONTROL1_SW_UART;
> > +		break;
> >  	default:
> >  		dev_err(info->dev, "failed to detect %s jig cable\n",
> >  			attached ? "attached" : "detached");
> > @@ -682,13 +684,13 @@ static int max77693_muic_adc_handler(struct max77693_muic_info *info)
> >  	case MAX77693_MUIC_ADC_FACTORY_MODE_USB_OFF:
> >  	case MAX77693_MUIC_ADC_FACTORY_MODE_USB_ON:
> >  	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_OFF:
> > +	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:
> >  		/* JIG */
> >  		ret = max77693_muic_jig_handler(info, cable_type, attached);
> >  		if (ret < 0)
> >  			return ret;
> >  		break;
> >  	case MAX77693_MUIC_ADC_RESERVED_ACC_3:		/* Dock-Smart */
> > -	case MAX77693_MUIC_ADC_FACTORY_MODE_UART_ON:	/* Dock-Car */
> >  	case MAX77693_MUIC_ADC_AUDIO_MODE_REMOTE:	/* Dock-Desk */
> >  	case MAX77693_MUIC_ADC_AV_CABLE_NOLOAD:		/* Dock-Audio */
> >  		/*
> > 


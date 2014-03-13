Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaCMNNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:13:36 -0400
Received: from mx0.aculab.com ([213.249.233.131]:48599 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751112AbaCMNNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:13:34 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Hayes Wang'" <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next v3 1/2] r8152: add
 RTL8152_EARLY_AGG_TIMEOUT_SUPER
Thread-Topic: [PATCH net-next v3 1/2] r8152: add
 RTL8152_EARLY_AGG_TIMEOUT_SUPER
Thread-Index: AQHPPrSolKsaLpuJVEW9JmxsG/15JZre/YjQ
Date: Thu, 13 Mar 2014 13:12:35 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6DCB6E@AcuExch.aculab.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
 <1394712342-15778-1-Taiwan-albertk@realtek.com>
 <1394712342-15778-2-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-2-Taiwan-albertk@realtek.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang
...

I should have spotted this before.

>  /* USB_RX_EARLY_AGG */
> -#define EARLY_AGG_SUPPER	0x0e832981
> +#define EARLY_AGG_SUPER	((((rx_buf_sz - 1522) / 4) << 16) | \
> +	(u32)(CONFIG_RTL8152_EARLY_AGG_TIMEOUT_SUPER <= 0 ? 85 * 125 : \
> +	min(CONFIG_RTL8152_EARLY_AGG_TIMEOUT_SUPER * 125, 0xffff)))
>  #define EARLY_AGG_HIGH		0x0e837a12
>  #define EARLY_AGG_SLOW		0x0e83ffff
> 
> @@ -1978,7 +1980,7 @@ static void r8153_set_rx_agg(struct r8152 *tp)
>  			ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH,
>  					RX_THR_SUPPER);
>  			ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_EARLY_AGG,
> -					EARLY_AGG_SUPPER);
> +					EARLY_AGG_SUPER);
>  		} else {
>  			ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH,
>  					RX_THR_HIGH);

It looks as though rx_buf_sz should be a parameter to EARLY_AGG_SUPER.

	David




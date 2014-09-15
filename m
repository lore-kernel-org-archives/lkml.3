Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaIOILu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:11:50 -0400
Received: from mail.peak-system.com ([213.157.13.214]:48976 "EHLO
	mail.peak-system.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaIOILs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:11:48 -0400
Message-ID: <54169D10.6040104@peak-system.com>
Date: Mon, 15 Sep 2014 10:02:24 +0200
From: Stephane Grosjean <s.grosjean@peak-system.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0)
 Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC: "Christopher R. Baker" <cbaker@rec.ri.cmu.edu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: can: sja1000: peak_pcmcia.c:  Cleaning up missing
 null-terminate in conjunction with strncpy
References: <1410715833-15809-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1410715833-15809-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-AxigenSpam-Level: 1
X-CTCH-RefID: str=0001.0A0C0205.54169D11.0288,ss=1,fgs=0
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
X-AxigenVirus-Level: 1
X-AXIGEN-KAV-Info: clean: Scanned with Kaspersky Anti Virus 8.0.3.83
X-AXIGEN-KAS-Info: Not spam
X-AXIGEN-KAS-Info: Version: 4.4.2 (May 20 2011 12:01:19)
X-AXIGEN-KAS-Info: Envelope from: 
X-AXIGEN-KAS-Info: {HEADERS: 7-bit header Content-Type found with 8-bit header
 Content-Transfer-Encoding}
X-AXIGEN-KAS-Info: Rate: 10
X-AXIGEN-KAS-Info: Status: not_detected
X-AXIGEN-KAS-Info: Method: none
X-AXIGEN-KAS-Info: DBG v.5. 2188, 818. R:128,1,128,6,7,128,1,128,0.
 M:4,24,55,145,160,169,174,193,194, CF:0,814,1. Date: +0200
X-AXIGEN-KAS-Spam-Level: Not Spam
X-AXIGEN-KAS-Spam-Confidence: 10%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>

Le 14/09/2014 19:30, Rickard Strandqvist a écrit :
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/net/can/sja1000/peak_pcmcia.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/sja1000/peak_pcmcia.c b/drivers/net/can/sja1000/peak_pcmcia.c
> index dd56133..fc9f8b01 100644
> --- a/drivers/net/can/sja1000/peak_pcmcia.c
> +++ b/drivers/net/can/sja1000/peak_pcmcia.c
> @@ -487,7 +487,7 @@ static void pcan_free_channels(struct pcan_pccard *card)
>   		if (!netdev)
>   			continue;
>   
> -		strncpy(name, netdev->name, IFNAMSIZ);
> +		strlcpy(name, netdev->name, IFNAMSIZ);
>   
>   		unregister_sja1000dev(netdev);
>   

--
PEAK-System Technik GmbH, Otto-Roehm-Strasse 69, D-64293 Darmstadt 
Geschaeftsleitung: A.Gach/U.Wilhelm,St.Nr.:007/241/13586 FA Darmstadt 
HRB-9183 Darmstadt, Ust.IdNr.:DE 202220078, WEE-Reg.-Nr.: DE39305391 
Tel.+49 (0)6151-817320 / Fax:+49 (0)6151-817329, info@peak-system.com
--

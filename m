Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaFATzY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 15:55:24 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:30184
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752512AbaFATzX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 15:55:23 -0400
X-Greylist: delayed 2625 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2014 15:55:23 EDT
From: Dimitrios Michailidis <dm@chelsio.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: ethernet: chelsio: cxgb4: t4_hw.c:  Cleaning up
 uninitialized variables
Thread-Topic: [PATCH] net: ethernet: chelsio: cxgb4: t4_hw.c:  Cleaning up
 uninitialized variables
Thread-Index: AQHPfZWwMhwOV5+Pi0CT7ZdjnoMvxJtcnPkQ
Date: Sun, 1 Jun 2014 19:11:24 +0000
Message-ID: <CBA48B605613B640864883107238931C13AC20@nice.asicdesigners.com>
References: <1401626055-15144-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401626055-15144-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.163.161]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist wrote:
> There is a risk that the variable will be used without being initialized.

There isn't actual risk here, this variable is not used uninitialized AFAICS.

> This was largely found by using a static code analysis program called cppcheck.

It seems this is a false inference by the tool.  I think the preferred method to suppress false tool warnings is to use uninitialized_var.
 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> index bba6768..326c005 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> @@ -571,7 +571,7 @@ int t4_seeprom_wp(struct adapter *adapter, bool
> enable)
>   */
>  int get_vpd_params(struct adapter *adapter, struct vpd_params *p)
>  {
> -	u32 cclk_param, cclk_val;
> +	u32 cclk_param, cclk_val = 0;
>  	int i, ret, addr;
>  	int ec, sn, pn;
>  	u8 *vpd, csum;
> --
> 1.7.10.4


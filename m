Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762719Ab3IEA4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 20:56:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762285Ab3IEA4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 20:56:49 -0400
Date: Wed, 4 Sep 2013 20:56:37 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org
Subject: Re: staging: r8188eu: Add files for new driver - part 14
Message-ID: <20130905005637.GD5727@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org
References: <20130903185951.92CE2661198@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903185951.92CE2661198@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 06:59:51PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=615a4d12e55690269ce07e183553cb2752e1fa29
 > Commit:     615a4d12e55690269ce07e183553cb2752e1fa29
 > Parent:     7ef8ded0cfdb690e37581af85eea35fa67cdb38d
 > Author:     Larry Finger <Larry.Finger@lwfinger.net>
 > AuthorDate: Wed Aug 21 22:33:56 2013 -0500
 > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 > CommitDate: Thu Aug 22 10:20:01 2013 -0700
 > 
 >     staging: r8188eu: Add files for new driver - part 14
 >     
 >     This commit adds files hal/rtl8188e_hal_init.c, hal/rtl8188e_mp.c,
 >     hal/rtl8188e_phycfg.c, and hal/rtl8188e_rf6052.c.
 
 > +void Hal_ReadAntennaDiversity88E(struct adapter *pAdapter, u8 *PROMContent, bool AutoLoadFail)
 > +{
 > +	struct hal_data_8188e	*pHalData = GET_HAL_DATA(pAdapter);
 > +	struct registry_priv	*registry_par = &pAdapter->registrypriv;
 > +
 > +	if (!AutoLoadFail) {
 > +		/*  Antenna Diversity setting. */
 > +		if (registry_par->antdiv_cfg == 2) { /*  2:By EFUSE */
 > +			pHalData->AntDivCfg = (PROMContent[EEPROM_RF_BOARD_OPTION_88E]&0x18)>>3;
 > +			if (PROMContent[EEPROM_RF_BOARD_OPTION_88E] == 0xFF)
 > +				pHalData->AntDivCfg = (EEPROM_DEFAULT_BOARD_OPTION&0x18)>>3;;
 > +		} else {
 > +			pHalData->AntDivCfg = registry_par->antdiv_cfg;  /*  0:OFF , 1:ON, 2:By EFUSE */
 > +		}
 > +
 > +		if (registry_par->antdiv_type == 0) {
 > +			/* If TRxAntDivType is AUTO in advanced setting, use EFUSE value instead. */
 > +			pHalData->TRxAntDivType = PROMContent[EEPROM_RF_ANTENNA_OPT_88E];
 > +			if (pHalData->TRxAntDivType == 0xFF)
 > +				pHalData->TRxAntDivType = CG_TRX_HW_ANTDIV; /*  For 88EE, 1Tx and 1RxCG are fixed.(1Ant, Tx and RxCG are both on aux port) */
 > +		} else {
 > +			pHalData->TRxAntDivType = registry_par->antdiv_type;
 > +		}
 > +
 > +		if (pHalData->TRxAntDivType == CG_TRX_HW_ANTDIV || pHalData->TRxAntDivType == CGCS_RX_HW_ANTDIV)
 > +			pHalData->AntDivCfg = 1; /*  0xC1[3] is ignored. */
 > +	} else {
 > +		pHalData->AntDivCfg = 0;
 > +		pHalData->TRxAntDivType = pHalData->TRxAntDivType; /*  The value in the driver setting of device manager. */

                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I suspect this should be setting itself to something more meaningful ?
registry_par->antdiv_type maybe ?

What is 'device manager' in this context ?

	Dave


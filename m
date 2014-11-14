Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161627AbaKNTCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:02:42 -0500
Received: from mailsec109.isp.belgacom.be ([195.238.20.105]:23560 "EHLO
	mailsec109.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161184AbaKNTCl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:02:41 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=hkFBDakPHWYIOok4y3pcivnmCJQbEK2MeX2RAJ8hs1E= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=IJv9LcIfAAAA:8 a=3cbR1qjfxt248F5kRaMA:9
 a=QEXdDO2ut3YA:10 a=4xDA9G98_CFVIJ_7:21 a=UyE1A0K5uo-cE5ke:21
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoMMAPtQZlTD7hTT/2dsb2JhbAAZAUGDDoEugwa2PQabCgKBHRYBAQEBAX2EAgEBAQMBIwRSBQsFBAIYAgIYDgICVwYTEYgnDZ4wRZxxhwKPMAEBCAIBH4EthRGKFhszB4J3gVQFq16JaIN9PDCCSwEBAQ
Date: Fri, 14 Nov 2014 20:02:38 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <2104595537.56209.1415991758726.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <1415990835.5912.20.camel@perches.com>
References: <1415990202-28673-1-git-send-email-fabf@skynet.be> <1415990835.5912.20.camel@perches.com>
Subject: Re: [PATCH 1/1 net-next] net: dsa: replace count*size kmalloc by
 kmalloc_array
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 14 November 2014 at 19:47 Joe Perches <joe@perches.com> wrote:
>
>
> On Fri, 2014-11-14 at 19:36 +0100, Fabian Frederick wrote:
> > kmalloc_array manages count*sizeof overflow.
>
> Fundamentally correct, but is this necessary or useful?
> sizeof(s8) isn't often going to be anything other than 1.
Absolutely, I thought it was a struct :)

There must be a reason for so many cases though ...

Regards,
Fabian

>
> Would the kernel even work without that assumption?
>
>
> > diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> []
> > @@ -526,7 +526,8 @@ static int dsa_of_setup_routing_table(struct
> > dsa_platform_data *pd,
> > 
> >     /* First time routing table allocation */
> >     if (!cd->rtable) {
> > -           cd->rtable = kmalloc(pd->nr_chips * sizeof(s8), GFP_KERNEL);
> > +           cd->rtable = kmalloc_array(pd->nr_chips, sizeof(s8),
> > +                                      GFP_KERNEL);
> >             if (!cd->rtable)
> >                     return -ENOMEM;
> > 
>
> Maybe all of these could be simplified
>
> $ git grep -E "\*\s*sizeof\s*\(\s*[us]8\s*\)"
> arch/arm/common/edma.c:                                   (edma_cc->num_tc +
> 1) * sizeof(s8),
> drivers/acpi/utils.c:                               (element->buffer.length *
> sizeof(u8));
> drivers/acpi/utils.c:                           tail += element->buffer.length
> * sizeof(u8);
> drivers/char/tpm/tpm_i2c_stm_st33.c:        kmalloc(TPM_BUFSIZE * sizeof(u8),
> GFP_KERNEL);
> drivers/char/tpm/tpm_i2c_stm_st33.c:        kmalloc(TPM_BUFSIZE * sizeof(u8),
> GFP_KERNEL);
> drivers/gpu/drm/r128/r128_state.c:      mask_size = depth->n * sizeof(u8);
> drivers/gpu/drm/r128/r128_state.c:              mask_size = depth->n *
> sizeof(u8);
> drivers/iio/common/st_sensors/st_sensors_spi.c: memcpy(data, tb->rx_buf,
> len*sizeof(u8));
> drivers/infiniband/hw/amso1100/c2_mq.h: u8 pad[64 - sizeof(u16) - 2 *
> sizeof(u8) - sizeof(u32) - sizeof(u16)];
> drivers/input/tablet/aiptek.c:  const int sizeof_buf = 3 * sizeof(u8);
> drivers/input/tablet/aiptek.c:  const int sizeof_buf = 3 * sizeof(u8);
> drivers/md/dm-crypt.c:  memset(&cc->key, 0, cc->key_size * sizeof(u8));
> drivers/md/dm-crypt.c:  cc = kzalloc(sizeof(*cc) + key_size * sizeof(u8),
> GFP_KERNEL);
> drivers/media/dvb-frontends/dib7000p.c: tx = kzalloc(2*sizeof(u8),
> GFP_KERNEL);
> drivers/media/dvb-frontends/dib7000p.c: rx = kzalloc(2*sizeof(u8),
> GFP_KERNEL);
> drivers/media/dvb-frontends/dib8000.c:  client.i2c_write_buffer = kzalloc(4 *
> sizeof(u8), GFP_KERNEL);
> drivers/media/dvb-frontends/dib8000.c:  client.i2c_read_buffer = kzalloc(4 *
> sizeof(u8), GFP_KERNEL);
> drivers/media/dvb-frontends/dib9000.c:  client.i2c_write_buffer = kzalloc(4 *
> sizeof(u8), GFP_KERNEL);
> drivers/media/dvb-frontends/dib9000.c:  client.i2c_read_buffer = kzalloc(4 *
> sizeof(u8), GFP_KERNEL);
> drivers/media/pci/ttpci/av7110_ipack.c: if (!(p->buf =
> vmalloc(size*sizeof(u8)))) {
> drivers/mtd/inftlmount.c:                               s->nb_blocks *
> sizeof(u8));
> drivers/net/wireless/ath/ath10k/htt.h:   *  b) num_chars * sizeof(u8) aligned
> to 4bytes */
> drivers/net/wireless/b43/ppr.c: BUILD_BUG_ON(sizeof(struct b43_ppr) !=
> B43_PPR_RATES_NUM * sizeof(u8));
> drivers/net/wireless/iwlwifi/pcie/trans.c:                   
>  trans_pcie->n_no_reclaim_cmds * sizeof(u8));
> drivers/net/wireless/rtlwifi/efuse.c:   memset(data, 0xff, PGPKT_DATA_SIZE *
> sizeof(u8));
> drivers/net/wireless/rtlwifi/efuse.c:   memset(tmpdata, 0xff, PGPKT_DATA_SIZE
> * sizeof(u8));
> drivers/net/wireless/rtlwifi/efuse.c:   u8 originaldata[8 * sizeof(u8)];
> drivers/net/wireless/rtlwifi/efuse.c:   u8 originaldata[8 * sizeof(u8)];
> drivers/net/wireless/rtlwifi/efuse.c:           memset(originaldata, 0xff,  8
> * sizeof(u8));
> drivers/net/wireless/rtlwifi/efuse.c:   memset(target_pkt.data, 0xFF,  8 *
> sizeof(u8));
> drivers/power/ds2781_battery.c: ret = w1_ds2781_read(dev_info, val,
> DS2781_VOLT_MSB, 2 * sizeof(u8));
> drivers/power/ds2781_battery.c: ret = w1_ds2781_read(dev_info, val,
> DS2781_TEMP_MSB, 2 * sizeof(u8));
> drivers/rtc/rtc-pcf2123.c:      ret = spi_write(spi, txbuf, 2 * sizeof(u8));
> drivers/rtc/rtc-pcf2123.c:      ret = spi_write(spi, txbuf, 2 * sizeof(u8));
> drivers/rtc/rtc-pcf2123.c:      ret = spi_write_then_read(spi, txbuf, 1 *
> sizeof(u8),
> drivers/rtc/rtc-pcf2123.c:                                      rxbuf, 2 *
> sizeof(u8));
> drivers/thermal/x86_pkg_temp_thermal.c:                 (max_phy_id+1) *
> sizeof(u8), GFP_ATOMIC);
> fs/compat_ioctl.c:      if (__copy_in_user(&tdata->read_write,
> &udata->read_write, 2 * sizeof(u8)))
> net/dsa/dsa.c:          cd->rtable = kmalloc(pd->nr_chips * sizeof(s8),
> GFP_KERNEL);
> net/dsa/dsa.c:          memset(cd->rtable, -1, pd->nr_chips * sizeof(s8));
>
>

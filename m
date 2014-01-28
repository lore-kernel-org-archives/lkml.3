Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaA1SSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:18:00 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61991 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaA1SR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:17:58 -0500
Message-ID: <52E7F451.7040708@gmail.com>
Date: Tue, 28 Jan 2014 20:17:53 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        chf.fritz@googlemail.com, Tero Kristo <t-kristo@ti.com>, nm@ti.com
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
References: <52E697C0.6000202@gmail.com> <52E7614E.8010903@ti.com> <52E76EE0.2060006@ti.com>
In-Reply-To: <52E76EE0.2060006@ti.com>
Content-Type: multipart/mixed;
 boundary="------------080702080303050404040901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080702080303050404040901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



On 28.01.2014 10:48, Tomi Valkeinen wrote:

> I made a somewhat hacky quickfix for beagle. Applying that and the
> clk-divider from the link above makes things work for me. However, as I
> said, the issue with n900 might be different, but it'd be interesting to
> hear if it has any effect.
>
>   Tomi
>

Applying those 2 patches doesn't help, still get exactly the same warning.

Find attached my clk_summary (with my hacky patch applied, otherwise I 
cannot boot the device)

Ivo

--------------080702080303050404040901
Content-Type: text/plain; charset=UTF-8;
 name="clk_summary.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="clk_summary.txt"

   clock                        enable_cnt  prepare_cnt  rate        accuracy
---------------------------------------------------------------------------------
 secure_32k_fck                 0           0            32768      0          
    wdt1_fck                    0           0            32768      0          
    gpt12_fck                   0           0            32768      0          
 mcbsp_clks                     0           5            0          0          
 sys_altclk                     0           0            0          0          
 virt_38_4m_ck                  0           0            38400000   0          
 virt_26000000_ck               0           0            26000000   0          
 virt_19200000_ck               1           1            19200000   0          
    osc_sys_ck                  1           1            19200000   0          
       sys_clkout1              0           0            19200000   0          
       sys_ck                   4           14           19200000   0          
          dpll1_ck              0           1            600000000  0          
             dpll1_x2_ck        0           1            1200000000 0          
                dpll1_x2m2_ck   0           1            1200000000 0          
                   mpu_ck       0           1            1200000000 0          
                      emu_mpu_alwon_ck 0           0            1200000000 0          
                      arm_fck   0           1            600000000  0          
          traceclk_src_fck      0           0            19200000   0          
             traceclk_fck       0           0            19200000   0          
          emu_src_ck            0           1            19200000   0          
             atclk_fck          0           0            19200000   0          
             pclkx2_fck         0           0            19200000   0          
             pclk_fck           0           0            9600000    0          
          gpt9_fck              0           1            19200000   0          
          gpt4_fck              0           1            19200000   0          
          gpt3_fck              0           1            19200000   0          
          gpt2_fck              0           1            19200000   0          
          dss2_alwon_fck        0           2            19200000   0          
          dpll4_ck              2           3            432000000  0          
             dpll4_m6_ck        0           0            144000000  0          
                dpll4_m6x2_ck   0           0            288000000  0          
                   emu_per_alwon_ck 0           0            288000000  0          
             dpll4_m5_ck        0           0            86400000   0          
                dpll4_m5x2_ck   0           0            172800000  0          
                   cam_mclk     0           0            172800000  0          
                      cam_xclkb 0           0            10800000   0          
                      cam_xclka 0           0            9600000    0          
             dpll4_m4_ck        1           1            36000000   0          
                dpll4_m4x2_ck   1           1            72000000   0          
                   dss1_alwon_fck_3430es2 2           4            72000000   0          
             dpll4_m3_ck        0           1            27000000   0          
                dpll4_m3x2_ck   0           1            54000000   0          
                   omap_54m_fck 0           1            54000000   0          
                      dss_tv_fck 0           2            54000000   0          
                      clkout2_src_ck 0           0            54000000   0          
                         sys_clkout2 0           0            54000000   0          
             dpll4_m2_ck        1           1            48000000   0          
                dpll4_m2x2_ck   1           1            96000000   0          
                   omap_96m_alwon_fck 1           2            96000000   0          
                      per_96m_fck 0           6            96000000   0          
                         mcbsp4_fck 0           1            96000000   0          
                         mcbsp3_fck 0           2            96000000   0          
                         mcbsp2_fck 0           2            96000000   0          
                      cm_96m_fck 2           2            96000000   0          
                         omap_48m_fck 2           4            48000000   0          
                            per_48m_fck 1           1            48000000   0          
                               uart3_fck 1           1            48000000   0          
                            core_48m_fck 3           6            48000000   0          
                               uart1_fck 1           1            48000000   0          
                               uart2_fck 1           1            48000000   0          
                               mcspi1_fck 0           1            48000000   0          
                               mcspi2_fck 0           1            48000000   0          
                               mcspi3_fck 0           1            48000000   0          
                               mcspi4_fck 1           1            48000000   0          
                            omap_12m_fck 0           1            12000000   0          
                               core_12m_fck 0           1            12000000   0          
                                  hdq_fck 0           1            12000000   0          
                            usbhost_48m_fck 0           1            48000000   0          
                         omap_96m_fck 1           2            96000000   0          
                            dss_96m_fck 0           2            96000000   0          
                            core_96m_fck 3           10           96000000   0          
                               mcbsp1_fck 0           1            96000000   0          
                               mcbsp5_fck 0           1            96000000   0          
                               i2c1_fck 1           1            96000000   0          
                               i2c2_fck 1           1            96000000   0          
                               i2c3_fck 1           1            96000000   0          
                               mmchs1_fck 0           1            96000000   0          
                               mmchs2_fck 0           1            96000000   0          
                               csi2_96m_fck 0           0            96000000   0          
                               mspro_fck 0           0            96000000   0          
                               mmchs3_fck 0           1            96000000   0          
             dpll4_x2_ck        0           0            864000000  0          
          dpll3_ck              1           1            664000000  0          
             dpll3_m3_ck        0           0            221333333  0          
                dpll3_m3x2_ck   0           0            442666666  0          
                   emu_core_alwon_ck 0           0            442666666  0          
             dpll3_m2_ck        1           2            332000000  0          
                dpll3_m2x2_ck   0           1            664000000  0          
                   corex2_fck   0           1            664000000  0          
                      ssi_ssr_fck_3430es2 0           2            221333333  0          
                         ssi_sst_fck_3430es2 0           1            110666666  0          
                core_ck         1           1            332000000  0          
                   l3_ick       2           3            166000000  0          
                      core_l3_ick 8           10           166000000  0          
                         gpmc_fck 2           2            166000000  0          
                         sdrc_ick 1           1            166000000  0          
                         hsotgusb_ick_3430es2 0           1            166000000  0          
                      l4_ick    7           8            83000000   0          
                         per_l4_ick 17          18           83000000   0          
                            mcbsp4_ick 2           2            83000000   0          
                            mcbsp3_ick 2           2            83000000   0          
                            mcbsp2_ick 1           1            83000000   0          
                            gpt2_ick 1           1            83000000   0          
                            gpt3_ick 1           1            83000000   0          
                            gpt4_ick 1           1            83000000   0          
                            gpt5_ick 1           1            83000000   0          
                            gpt6_ick 1           1            83000000   0          
                            gpt7_ick 1           1            83000000   0          
                            gpt8_ick 1           1            83000000   0          
                            gpt9_ick 1           1            83000000   0          
                            uart4_ick 0           0            83000000   0          
                            uart3_ick 1           1            83000000   0          
                            wdt3_ick 0           1            83000000   0          
                            gpio2_ick 1           1            83000000   0          
                            gpio3_ick 1           1            83000000   0          
                            gpio4_ick 1           1            83000000   0          
                            gpio5_ick 1           1            83000000   0          
                            gpio6_ick 1           1            83000000   0          
                         core_l4_ick 20          21           83000000   0          
                            omapctrl_ick 1           1            83000000   0          
                            mcbsp1_ick 1           1            83000000   0          
                            mcbsp5_ick 1           1            83000000   0          
                            gpt10_ick 1           1            83000000   0          
                            gpt11_ick 1           1            83000000   0          
                            uart1_ick 1           1            83000000   0          
                            uart2_ick 1           1            83000000   0          
                            i2c1_ick 1           1            83000000   0          
                            i2c2_ick 1           1            83000000   0          
                            i2c3_ick 1           1            83000000   0          
                            mcspi1_ick 1           1            83000000   0          
                            mcspi2_ick 1           1            83000000   0          
                            mcspi3_ick 1           1            83000000   0          
                            mcspi4_ick 1           1            83000000   0          
                            hdq_ick 0           1            83000000   0          
                            mmchs1_ick 1           1            83000000   0          
                            mmchs2_ick 1           1            83000000   0          
                            icr_ick 0           0            83000000   0          
                            aes2_ick 0           0            83000000   0          
                            sha12_ick 0           0            83000000   0          
                            des2_ick 0           0            83000000   0          
                            mspro_ick 0           0            83000000   0          
                            mailboxes_ick 1           1            83000000   0          
                            usbtll_ick 1           1            83000000   0          
                            mmchs3_ick 1           1            83000000   0          
                         rm_ick 0           0            41500000   0          
                         cam_ick 1           1            83000000   0          
                         ssi_l4_ick 0           1            83000000   0          
                            ssi_ick_3430es2 0           1            83000000   0          
                         sr_l4_ick 2           2            83000000   0          
                         security_l4_ick2 0           0            83000000   0          
                            aes1_ick 0           0            83000000   0          
                            rng_ick 0           0            83000000   0          
                            sha11_ick 0           0            83000000   0          
                            des1_ick 0           0            83000000   0          
                         dss_ick_3430es2 4           6            83000000   0          
                         usbhost_ick 1           1            83000000   0          
                      security_l3_ick 0           0            166000000  0          
                         pka_ick 0           0            166000000  0          
                      sad2d_ick 0           1            166000000  0          
                      mad2d_ick 0           0            166000000  0          
                      sgx_ick   0           0            166000000  0          
                   dpll1_fck    0           0            166000000  0          
                   dpll2_fck    0           0            332000000  0          
                   sgx_fck      0           0            110666666  0          
             dpll3_x2_ck        0           0            1328000000 0          
          sr1_fck               0           1            19200000   0          
          sr2_fck               0           1            19200000   0          
          wkup_l4_ick           4           4            19200000   0          
             gpt1_ick           1           1            19200000   0          
             gpt12_ick          0           0            19200000   0          
             omap_32ksync_ick   1           1            19200000   0          
             gpio1_ick          1           1            19200000   0          
             wdt1_ick           0           0            19200000   0          
             wdt2_ick           1           1            19200000   0          
             usim_ick           0           0            19200000   0          
          modem_fck             0           0            19200000   0          
          dpll2_ck              1           1            249600000  0          
             dpll2_m2_ck        1           1            249600000  0          
                iva2_ck         1           4            249600000  0          
          usim_fck              0           0            9600000    0          
          dpll5_ck              0           1            120000000  0          
             dpll5_m2_ck        0           2            120000000  0          
                usbhost_120m_fck 0           1            120000000  0          
                usbtll_fck      0           1            120000000  0          
          cpefuse_fck           0           0            19200000   0          
 virt_13m_ck                    0           0            13000000   0          
 virt_12m_ck                    0           0            12000000   0          
 omap_32k_fck                   2           12           32768      0          
    gpt8_fck                    0           1            32768      0          
    gpt7_fck                    0           1            32768      0          
    gpt6_fck                    0           1            32768      0          
    gpt5_fck                    0           1            32768      0          
    per_32k_alwon_fck           0           6            32768      0          
       wdt3_fck                 0           1            32768      0          
       gpio2_dbck               0           1            32768      0          
       gpio3_dbck               0           1            32768      0          
       gpio4_dbck               0           1            32768      0          
       gpio5_dbck               0           1            32768      0          
       gpio6_dbck               0           1            32768      0          
    wkup_32k_fck                1           3            32768      0          
       wdt2_fck                 0           1            32768      0          
       gpio1_dbck               0           1            32768      0          
    gpt1_fck                    1           1            32768      0          
    gpt11_fck                   0           1            32768      0          
    gpt10_fck                   0           1            32768      0          
    ts_fck                      0           0            32768      0          
 dummy_apb_pclk                 0           0            0          0          
 virt_16_8m_ck                  0           0            16800000   0          
 dummy_clk                      0           0            0          0     


--------------080702080303050404040901--

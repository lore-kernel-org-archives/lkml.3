Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaLODre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:47:34 -0500
Received: from mail-by2on0115.outbound.protection.outlook.com ([207.46.100.115]:60640
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751220AbaLODrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:47:32 -0500
From: Dudley Du <dudl@cypress.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, Dudley Du <dudley.dulixin@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v14 00/12] input: cyapa: instruction of cyapa patches
Thread-Topic: [PATCH v14 00/12] input: cyapa: instruction of cyapa patches
Thread-Index: AQHQFbNUBWvnsWuXMEGk2Gsm9ivjwZyNULWAgAKgv9A=
Date: Mon, 15 Dec 2014 03:47:27 +0000
Message-ID: <BN1PR06MB070AB76B648BF8E314E7969D16F0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1418351262-8163-1-git-send-email-dudley.dulixin@gmail.com>
 <20141213101753.GA9290@newt.localdomain>
In-Reply-To: <20141213101753.GA9290@newt.localdomain>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB072;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB072;
x-forefront-prvs: 04267075BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51164003)(51704005)(13464003)(199003)(189002)(4396001)(76576001)(87936001)(46102003)(74316001)(31966008)(99396003)(120916001)(86362001)(122556002)(105586002)(106356001)(68736005)(99286002)(106116001)(101416001)(97736003)(33656002)(62966003)(66066001)(102836002)(77156002)(19580395003)(2656002)(54206007)(20776003)(64706001)(40100003)(15975445007)(107046002)(54606007)(50986999)(92566001)(19580405001)(54356999)(21056001)(76176999);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB072;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremiah,

Thanks for your information.
I will fix the space check warnning.

Are there any other driver check tools that need to be run?

Thanks.
Dudley

> -----Original Message-----
> From: linux-input-owner@vger.kernel.org
> [mailto:linux-input-owner@vger.kernel.org] On Behalf Of Jeremiah Mahler
> Sent: 2014?12?13? 18:18
> To: Dudley Du
> Cc: linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v14 00/12] input: cyapa: instruction of cyapa patches
>
> Dudley,
>
> On Fri, Dec 12, 2014 at 10:27:30AM +0800, Dudley Du wrote:
> > V14 patches have below updates, details of other updates see history list:
> > 1) Correct 9 miss spelling issues of "bufferred" to "buffered".
> > 2) Fix the upgrade issue of removing MOUSE_CYAPA config when make oldconfig
> >    by replase "depends on I2C && CRC_ITU_T" with
> > "depends on I2C"
> > "select CRC_ITU_T"
> >    in patch 9.
> >
> [...]
>
> I found some sparse warnings that should be fixed.
>
>   jeri@newt:~/linux-next$ touch drivers/input/mouse/*.c
>   jeri@newt:~/linux-next$ touch drivers/input/mouse/*.h
>   jeri@newt:~/linux-next$ make C=1
>     CHK     include/config/kernel.release
>     CHK     include/generated/uapi/linux/version.h
>     CHK     include/generated/utsrelease.h
>     CALL    scripts/checksyscalls.sh
>     CHK     include/generated/compile.h
>     CHK     kernel/config_data.h
>     CHECK   drivers/input/mouse/cyapa.c
>   drivers/input/mouse/cyapa.c:43:9: warning: symbol 'cyapa_i2c_read' was
>   not declared. Should it be static?
>   drivers/input/mouse/cyapa.c:80:9: warning: symbol 'cyapa_i2c_write' was
>   not declared. Should it be static?
>   drivers/input/mouse/cyapa.c:289:5: warning: symbol 'cyapa_detect' was
>   not declared. Should it be static?
>     CC [M]  drivers/input/mouse/cyapa.o
>     CHECK   drivers/input/mouse/cyapa_gen3.c
>   drivers/input/mouse/cyapa_gen3.c:299:5: warning: symbol
>   'cyapa_read_byte' was not declared. Should it be static?
>   drivers/input/mouse/cyapa_gen3.c:312:5: warning: symbol
>   'cyapa_write_byte' was not declared. Should it be static?
>   drivers/input/mouse/cyapa_gen3.c:331:9: warning: symbol
>   'cyapa_i2c_reg_write_block' was not declared. Should it be static?
>     CC [M]  drivers/input/mouse/cyapa_gen3.o
>     CHECK   drivers/input/mouse/cyapa_gen5.c
>   drivers/input/mouse/cyapa_gen5.c:334:5: warning: symbol
>   'cyapa_empty_pip_output_data' was not declared. Should it be static?
>   drivers/input/mouse/cyapa_gen5.c:553:6: warning: symbol
>   'cyapa_gen5_sort_tsg_pip_bl_resp_data' was not declared. Should it be
>   static?
>   drivers/input/mouse/cyapa_gen5.c:568:6: warning: symbol
>   'cyapa_gen5_sort_tsg_pip_app_resp_data' was not declared. Should it be
>   static?
>   drivers/input/mouse/cyapa_gen5.c:595:6: warning: symbol
>   'cyapa_gen5_sort_application_launch_data' was not declared. Should it be
>   static?
>   drivers/input/mouse/cyapa_gen5.c:995:6: warning: symbol
>   'cyapa_gen5_sort_bl_exit_data' was not declared. Should it be static?
>   drivers/input/mouse/cyapa_gen5.c:1112:72: warning: Using plain integer
>   as NULL pointer
>     CC [M]  drivers/input/mouse/cyapa_gen5.o
>     LD [M]  drivers/input/mouse/cyapatp.o
>   Kernel: arch/x86/boot/bzImage is ready  (#127)
>     Building modules, stage 2.
>     MODPOST 187 modules
>     CC      drivers/input/mouse/cyapatp.mod.o
>     LDFINAL [M]  drivers/input/mouse/cyapatp.ko
>   jeri@newt:~/linux-next
>
> --
> - Jeremiah Mahler
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

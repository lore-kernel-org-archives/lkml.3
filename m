Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaAQN4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:56:21 -0500
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:18734
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751971AbaAQN4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:56:18 -0500
X-Greylist: delayed 889 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jan 2014 08:56:18 EST
Message-ID: <52D93301.2080609@licor.com>
Date: Fri, 17 Jan 2014 07:41:21 -0600
From: Darryl <ddegraff@licor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: debugging head.S
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.82.105.200]
X-Forefront-PRVS: 0094E3478A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(679001)(779001)(689001)(199002)(189002)(74366001)(23756003)(83506001)(36756003)(54316002)(80022001)(63696002)(64126003)(65956001)(74876001)(87936001)(76796001)(65806001)(85306002)(66066001)(81342001)(74706001)(76786001)(47776003)(50466002)(80976001)(92566001)(93136001)(80316001)(47446002)(83322001)(47736001)(74502001)(33656001)(92726001)(90146001)(56816005)(47976001)(74662001)(81542001)(49866001)(93516002)(50986001)(31966008)(76176001)(51856001)(54356001)(53806001)(69226001)(46102001)(81686001)(59766001)(4396001)(77982001)(79102001)(81816001)(59896001)(76482001)(83072002)(85852003)(56776001)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR08MB011;H:BL2PRD0810HT001.namprd08.prod.outlook.com;CLIP:208.82.105.200;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: licor.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to build 3.12.6 for an OMAP3-based board (debug console on 
UART 3)

Enabling DEBUG in

     arch/arm/boot/compressed/head.S

and with

     CONFIG_DEBUG_LL_INCLUDE="debug/omap2plus.S"

compiling (well, actually, assembling) gives the following (slightly 
reformatted):

     arch/arm/boot/compressed/head.S: Assembler messages:
     arch/arm/boot/compressed/head.S:1237: Error: ARM register expected 
-- `sub ,r3,r1'
     arch/arm/boot/compressed/head.S:1237: Error: ARM register expected 
-- `ldr r3,[,#0]'
     arch/arm/boot/compressed/head.S:1237: Error: ARM register expected 
-- `ldr r1,[,#4]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#0]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#4]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#8]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#0]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#4]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#8]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `ldr ,[,#8]'
     arch/arm/include/debug/omap2plus.S:138: Error: shift expression 
expected -- `add r3,r3,'
     arch/arm/include/debug/omap2plus.S:138: Error: shift expression 
expected -- `add r1,r1,'
     arch/arm/boot/compressed/head.S:1255: Error: ARM register expected 
-- `sub ,r3,r1'
     arch/arm/boot/compressed/head.S:1255: Error: ARM register expected 
-- `ldr r3,[,#0]'
     arch/arm/boot/compressed/head.S:1255: Error: ARM register expected 
-- `ldr r1,[,#4]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#0]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#4]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#8]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#0]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#4]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `str r3,[,#8]'
     arch/arm/include/debug/omap2plus.S:138: Error: ARM register 
expected -- `ldr ,[,#8]'
     arch/arm/include/debug/omap2plus.S:138: Error: shift expression 
expected -- `add r3,r3,'
     arch/arm/include/debug/omap2plus.S:138: Error: shift expression 
expected -- `add r1,r1,'

It looks like the 'addruart' macro in in omap2plus.S is shorted a 
parameter from the macro 'loadsp' macro in head.S, called in 'puts' and 
'putc'.

Am I misusing this in some way?  Any suggestions?

Darryl

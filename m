Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966424AbaLMKR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 05:17:59 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33084 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966327AbaLMKR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 05:17:57 -0500
Date: Sat, 13 Dec 2014 02:17:53 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 00/12] input: cyapa: instruction of cyapa patches
Message-ID: <20141213101753.GA9290@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1418351262-8163-1-git-send-email-dudley.dulixin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418351262-8163-1-git-send-email-dudley.dulixin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Fri, Dec 12, 2014 at 10:27:30AM +0800, Dudley Du wrote:
> V14 patches have below updates, details of other updates see history list:
> 1) Correct 9 miss spelling issues of "bufferred" to "buffered".
> 2) Fix the upgrade issue of removing MOUSE_CYAPA config when make oldconfig
>    by replase "depends on I2C && CRC_ITU_T" with
> 	"depends on I2C"
> 	"select CRC_ITU_T"
>    in patch 9.
> 
[...]

I found some sparse warnings that should be fixed.

  jeri@newt:~/linux-next$ touch drivers/input/mouse/*.c
  jeri@newt:~/linux-next$ touch drivers/input/mouse/*.h
  jeri@newt:~/linux-next$ make C=1
    CHK     include/config/kernel.release
    CHK     include/generated/uapi/linux/version.h
    CHK     include/generated/utsrelease.h
    CALL    scripts/checksyscalls.sh
    CHK     include/generated/compile.h
    CHK     kernel/config_data.h
    CHECK   drivers/input/mouse/cyapa.c
  drivers/input/mouse/cyapa.c:43:9: warning: symbol 'cyapa_i2c_read' was
  not declared. Should it be static?
  drivers/input/mouse/cyapa.c:80:9: warning: symbol 'cyapa_i2c_write' was
  not declared. Should it be static?
  drivers/input/mouse/cyapa.c:289:5: warning: symbol 'cyapa_detect' was
  not declared. Should it be static?
    CC [M]  drivers/input/mouse/cyapa.o
    CHECK   drivers/input/mouse/cyapa_gen3.c
  drivers/input/mouse/cyapa_gen3.c:299:5: warning: symbol
  'cyapa_read_byte' was not declared. Should it be static?
  drivers/input/mouse/cyapa_gen3.c:312:5: warning: symbol
  'cyapa_write_byte' was not declared. Should it be static?
  drivers/input/mouse/cyapa_gen3.c:331:9: warning: symbol
  'cyapa_i2c_reg_write_block' was not declared. Should it be static?
    CC [M]  drivers/input/mouse/cyapa_gen3.o
    CHECK   drivers/input/mouse/cyapa_gen5.c
  drivers/input/mouse/cyapa_gen5.c:334:5: warning: symbol
  'cyapa_empty_pip_output_data' was not declared. Should it be static?
  drivers/input/mouse/cyapa_gen5.c:553:6: warning: symbol
  'cyapa_gen5_sort_tsg_pip_bl_resp_data' was not declared. Should it be
  static?
  drivers/input/mouse/cyapa_gen5.c:568:6: warning: symbol
  'cyapa_gen5_sort_tsg_pip_app_resp_data' was not declared. Should it be
  static?
  drivers/input/mouse/cyapa_gen5.c:595:6: warning: symbol
  'cyapa_gen5_sort_application_launch_data' was not declared. Should it be
  static?
  drivers/input/mouse/cyapa_gen5.c:995:6: warning: symbol
  'cyapa_gen5_sort_bl_exit_data' was not declared. Should it be static?
  drivers/input/mouse/cyapa_gen5.c:1112:72: warning: Using plain integer
  as NULL pointer
    CC [M]  drivers/input/mouse/cyapa_gen5.o
    LD [M]  drivers/input/mouse/cyapatp.o
  Kernel: arch/x86/boot/bzImage is ready  (#127)
    Building modules, stage 2.
    MODPOST 187 modules
    CC      drivers/input/mouse/cyapatp.mod.o
    LDFINAL [M]  drivers/input/mouse/cyapatp.ko
  jeri@newt:~/linux-next

-- 
- Jeremiah Mahler

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3EHVaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:30:04 -0400
Received: from nm4.access.bullet.mail.sp2.yahoo.com ([98.139.44.131]:37148
	"EHLO nm4.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774Ab3EHVaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:30:02 -0400
X-Yahoo-Newman-Id: 689200.52775.bm@smtp106.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: SXSOSUEVM1m3ddQNUWNMnNMD1tG.LcP_p7XmXLXxYEvAekg
 QYlLG1FS7Tz2OMWoj7IVjOPgRAN3ijB.cm7DSPwivbEEzzn2cjDs4WvDMq7S
 r2cHWFfS_HZ7C8EyozNtiaUPeZH0uzZt3yXUSYp9BTtFKptKMFg3TMiNhJoS
 poflj2MVKmedIlMgUr7j42ofVN0m9W_3Faw5kwyXjKcSdhwku31A183b58JY
 3no_taOwDcEheZwVaMAinNGxHkMA6UZCQ6oTo0r9X7_F8yVV7tCBqTI6T1HF
 yT8rFOz0kW3JvlbH57wogeV0OYWg7xU.IgoQx4bKglU574yWBaU3LMwASmcP
 hZZuXfl0FPF1scKAAPncyYaI3eJratMro1ZuujBtWLkuqRYS3Nqy5A9Bp7yn
 eVEOotC_vatuU3gV9VJZrk080Ot7XHr9dgQBYbh0.wjt9PXV2sMCgzZG2.jE
 obWXJ7jmkebz5m6H5OFLxdbRNume9eNM34b8-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp106.sbc.mail.gq1.yahoo.com with SMTP; 08 May 2013 14:30:01 -0700 PDT
Date: Wed, 8 May 2013 14:30:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Build failures due to commit ea4054a2384 (handle huge number of
 modules)
Message-ID: <20130508213007.GA11946@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I started seeing build failures such as the following in the last week or so.

make[2]: [__modpost] Error 1

followed by lots of messages such as

gcc: error: arch/x86/crypto/ablk_helper.mod.c: No such file or directory
gcc: fatal error: no input files

(at least if I run make -i)

After reverting commit ea4054a238 (modpost: handle huge numbers of modules)
everything is fine.

This happens with multiple gcc versions and target platforms (arm, x86_64,
i386, powerpc). Host kernel version is 3.8.10, system is Ubuntu 12.10.

Does anyone else see this problem ? Any idea what might be wrong ?

Thanks,
Guenter

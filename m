Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3GSX5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:57:53 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:12347 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3GSX5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:57:51 -0400
X-AuditID: cbfec37d-b7f036d000004805-9e-51e9d27db1f0
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/18] 3.0.87-stable review
Thread-topic: [ 00/18] 3.0.87-stable review
Thread-index: AQHOhNr2OwQ+lI5xpEaujHdHiGzfSg==
Date: Fri, 19 Jul 2013 23:57:48 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61746B61@sisaex01sj>
References: <20130719021048.965829361@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+wr27tpZeBBsdarS3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mp4e+AlY8E1sYozc+wbGB8IdTFyckgImEj823WHHcIWk7hwbz0biC0ksIxR4urmyi5G
	LiC7l0liw/o9bBDOfEaJ9bcWgFWxCahLfH69A6xbRMBYov/sLDCbWeAYk0RHZ1kXIweHsICW
	xMUbnBAl2hKTp85nAgmLCOhJXN0aAGKyCKhK7D1ZBlLBK2AvsWjbJRaIE6wkvkyZzgRiMwKd
	9v3UGiaI4eISza03WSBOFpBYsuc8M4QtKvHy8T9WkJESAooS21dbQZTrSXz8c5sRwtaWePLu
	AivEKkGJH5PvsUxgFJuFZOosJC2zkLTMQtKygJFlFaNYaXFyQXFSemqFiV5xYm5xaV66XnJ+
	7iZGSMTV7mC8/9XmEKMAB6MSD++FFS8DhVgTy4orcw8xSnAwK4nwFqQBhXhTEiurUovy44tK
	c1KLDzEycXBKNTAanqu5IZP6UL/XgmeLQMv0J2kXXbT8xdSf5yYl/ctb+cZF4CLH+1VFO+7U
	9vTf8V7D62lRs2/7/MxL9vza/Qm+yVXlNbFuL6/xXF5XeHL/6paZjAVuV0olNj8wjn/7/N1Z
	oTiT70/ay9QvbSwX9L693fb8j9g9cql6DiavMiQ2zHcU9xXcvVKJpTgj0VCLuag4EQBGkvQP
	lgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 05:52 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.87 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jul 21 02:10:01 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.87-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Patches applied cleanly to 3.0.86, 3.4.54, 3.9.10, and 3.10.1

3.9.11-rc1 patch failed to build:
x64-64, mipsel, mips, powerpc, and tile: build failed with the following 
error:

    LD      ipc/built-in.o
    CC [M]  fs/cifs/inode.o
fs/cifs/inode.c: In function ‘cifs_all_info_to_fattr’:
fs/cifs/inode.c:560:4: error: implicit declaration of function
‘cifs_dbg’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [fs/cifs/inode.o] Error 1
make[1]: *** [fs/cifs] Error 2
make: *** [fs] Error 2
make: *** Waiting for unfinished jobs....
    CC      security/selinux/hooks.o

I have CONFIG_CIFS=m in my config and CONFIG_CIFS_DEBUG is disabled.
cifs_dbg() is not defined.

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.54-rc1, 3.9.10-rc1, 3.10.2-rc2)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.87-rc1, 3.4.54-rc1, 3.9.10-rc1?, and 3.10.2-rc2)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.87-rc1, 3.4.54-rc1, 3.9.10-rc1?, and 3.10.2-rc2)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.9.y, and 3.10.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, 3.9.y, and 3.10.y
mips: defconfig passed on all, except 3.9.10
mipsel: defconfig passed on all, except 3.9.10
powerpc: wii_defconfig passed on all, except 3.9.10
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all, except 3.9.10

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658

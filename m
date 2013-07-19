Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3GSXQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:16:53 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:21352 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3GSXQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:16:51 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-13-51e9c8e12985
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/72] 3.10.2-stable review
Thread-topic: [ 00/72] 3.10.2-stable review
Thread-index: AQHOhJUx+Zg2iQCPiU6jixKTKeTZ9g==
Date: Fri, 19 Jul 2013 23:16:47 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6174690B@sisaex01sj>
References: <20130719052559.852627424@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e+wn+6jEy8DDV4fZLSYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugStjRc9O5oILYhUvZq1gb2C8I9TFyMkhIWAisWX6FSYIW0ziwr31bF2MXBxCAssYJVad
	3sgK4fQySSxatBwqM59RYu7V6cwgLWwC6hKfX+9gB7FFBIwl+s/OArOZBY4xSXR0lnUxcnAI
	C2hJtL0PBTFFBLQlnj/MhajWk3i3+yPYFBYBVYm7j3eygti8AvYSK/cdBosLCVhJvP7/ng3E
	ZgQ67vupNUwQ08UlmltvskAcLSCxZM95ZghbVOLl43+sIKskBBQltq+2gijXk/j45zYjhK0t
	8eTdBahVghI/Jt9jmcAoNgvJ1FlIWmYhaZmFpGUBI8sqRrHS4uSC4qT01ApDveLE3OLSvHS9
	5PzcTYyQuKvawXjnq80hRgEORiUe3gsrXgYKsSaWFVfmHmKU4GBWEuEtSAMK8aYkVlalFuXH
	F5XmpBYfYmTi4JRqYIyO/PbNwb9os8Lzu8LX1svuttr3VbioTZunIXSF93P/ObNiM9xKMry1
	tr8P3v33/lT/763Sv4w++1mpKT6eKRs6afNUQSGOggip7zeb7fsWOrvMjyw8WB8WanG/QzTm
	Td/j1THb37LPd9uy73Rn+Nv7fV+niIrJzuufb5pz8rfWVrujJjfOWyqxFGckGmoxFxUnAgA6
	9OUGmQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 09:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.2 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jul 21 05:25:08 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.2-rc1.gz
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

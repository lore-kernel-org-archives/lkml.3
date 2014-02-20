Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaBTTdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:33:21 -0500
Received: from nm36.bullet.mail.ne1.yahoo.com ([98.138.229.29]:28500 "EHLO
	nm36.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755493AbaBTTdT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:33:19 -0500
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 210415.82625.bm@omp1029.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=dCifNt2XdvbNuMfYxfrzOONQ2Gah0H1EjlPoWsE8HrNt+qCVlP72F4b67LfRfd+dpx/c4CRhb6ytFBmes2l5SRXg14h+te1adDL6kW+GvnlpzP0Nc13g+pmjiGeb2hHw7VXqHpFniIdhgjZOi82bJpSpGm5EXvTLJo7gb0UywlU=;
X-YMail-OSG: CjIDAH8VM1niBOIueXSHrFlYK0jwNNwn3MxOGpP9bb5Y0Yl
 m0dAVsS3jsRt5LysWVE9KJN_vGkr1hmWaFhi1imZPCsZEFNKRyqX5j3h51qL
 E1jYIOu8WYeo12QjRH4ntM77_QooW.emrhyGhStIXEtHxO.uMkATcOmFrRU1
 cibCNTJ._Nma.xLm3hvUeyoUrUfGOKmutVm.dk6w3UWG1ZF9RI_xowxb_l0d
 XRv.Sl1pSrAc2gHdhlKfyxdvfxb5VeH1bYWraLCtFp6sq.zQ24o6I3bVRnX_
 Aorvm.FonXUb1sRnt5CkPSHUSiIoYVuAIOxiEh0ByDC_uZ4xg.gc.VxWIdXC
 zPFpK1pEnvgSShIHAEiiX3R8c9Pqr._c.931OAfE8px4dIVUXOJzgITrS0B0
 bBdoTlDWvxvTJcuS27SSkJnpVhnDTnfqF0AVanOIYCCpidb3mH5bshlorpUz
 JBzObCZpZMssyKO.DlJyMmk5NzXMamb.EFFaycmn6dw3.Bf1gJIoJim7TjsY
 lgMgsT4WEMSBC19FGAK43RE2jQbetDhF0hW_m5xV7Kia948dsQIWsnOO6CCf
 M3VKvQnMHVGISUQk275ymKw--
X-Rocket-MIMEInfo: 002.001,CgpIaSwKCkkgaGF2ZSBhbiBvbGQgTG9naXRlY2ggd2ViY2FtLCB3aXRoIFVTQiBJRHMgMDQ2ZDowOGIzLiBXaGVuIEkgdHJ5IHRvIHVzZSB0aGlzIGNhbWVyYSBub3csIEkgc2VlIHRoaXMgZXJyb3IgaW4gdGhlIGRtZXNnIGxvZzoKClsgMjg4My44NTI0NjRdIHB3YzogaXNvY19pbml0KCkgc3VibWl0X3VyYiAwIGZhaWxlZCB3aXRoIGVycm9yIC0yOAoKClRoaXMgZXJyb3IgaXMgYXBwYXJlbnRseSBFTk9TUEMsIHdoaWNoIG1hZGUgbWUgc3VzcGVjdCB0aGF0IEkgd2FzIHRyeWluZyB0byB1c2UgYSBtb2RlIHQBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
Message-ID: <1392924626.38711.YahooMailNeo@web120304.mail.ne1.yahoo.com>
Date: Thu, 20 Feb 2014 11:30:26 -0800 (PST)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: PWC webcam and setpwc tool no longer working with 3.12.11 kernel
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,

I have an old Logitech webcam, with USB IDs 046d:08b3. When I try to use this camera now, I see this error in the dmesg log:

[ 2883.852464] pwc: isoc_init() submit_urb 0 failed with error -28


This error is apparently ENOSPC, which made me suspect that I was trying to use a mode that would require compression. However, when I tried using setpwc to configure the camera's options I received more errors:
$ setpwc -c 3
setpwc v1.3, (C) 2003-2006 by folkert@vanheusden.com
Error while doing ioctl VIDIOCPWCSCQUAL: Inappropriate ioctl for device


Has the kernel-to-userspace interface for PWC devices changed? Because how else could this IOCTL be "inappropriate"? Is there an alternative to setpwc, please?

Thanks,
Chris

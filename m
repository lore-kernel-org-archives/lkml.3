Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967071Ab3DRKjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:39:11 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:55688 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966959Ab3DRKjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:39:09 -0400
MIME-Version: 1.0
X-Originating-IP: [85.143.161.18]
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Thu, 18 Apr 2013 14:38:53 +0400
X-Google-Sender-Auth: ClPwfWMo4uI9-i2hRvM_PM82Y7c
Message-ID: <CACaajQv+HhzStC-U1RGz4ZWdn0-w4X3MyMM9GTJPOFeyrxtP3w@mail.gmail.com>
Subject: mdadm raid1 regression
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. I'm using linux 3.8.6 and mdadm 3.2.6 (from git).
I have many raid1 arrays that have data offset 2048 (metadata 1.2,
created with various mdadm versions but mostly 3.2.1 on linux 2.6.32).
If i create raid1 with never mdadm on 3.8.6 i have data offset 8192?? Why?

My problem:
Sometimes i'm doing mdadm --zero-superblock on both parts of array and
re-create it. On older systems i have no errors. On new (linux 3.8.6
and mdadm 3.2.6) i get corrupted ext3 fs and partition table. Why this
happening?
P.S. If i use mdadm 3.2.2 i get data offset 4096 that not breaks data,
but inconsistent with older versions.
P.P.S. I'm try to specify --data-offset when create array but as i see
- its ignored and data offset still have 8192).


Thanks!
--
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru

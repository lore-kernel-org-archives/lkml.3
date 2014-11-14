Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935427AbaKNXgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:36:49 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65460 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635AbaKNXgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:36:44 -0500
From: Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Igor Alekseev <igor.alekseev@itep.ru>,
        Dmitry Kalinkin <dmitry.kalinkin@gmail.com>
Subject: [PATCH 0/3] mmap() for vme_user and CR/CSR fix for master
Date: Sat, 15 Nov 2014 02:36:15 +0300
Message-Id: <1416008178-9393-1-git-send-email-dmitry.kalinkin@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

mmap() on VME bridge devices is a feature present in many existing Linux and
UNIX drivers.  The proposed solution follows the approach so that mmap()
offsets are coherent with read() and write() offsets, which seems to be the
only manner compatible with the current vme_user API.  It also ends up adding
vme_master_mmap call to the VME subsystem API. On one hand this might come
useful for a board driver that will be able to expose one of its windows to the
user that way. On the other hand it introduces dependency on vma_area_struct
into vme.h, which doesn't seem very right.

Also I'm bringing up a bugfix by Martyn Welch that was published on the list,
but for some reason didn't make it to the kernel.

Cheers,
Dmitry

Dmitry Kalinkin (2):
  staging: vme: use image mutex for ioctl()
  staging: vme: mmap() support for vme_user

Martyn Welch (1):
  vme: tsi148: Master windows support USERx and CR/CSR accesses, not
    slaves

 drivers/staging/vme/devices/vme_user.c | 94 ++++++++++++++++++++++++++++++++--
 drivers/vme/bridges/vme_tsi148.c       | 11 ++--
 drivers/vme/vme.c                      | 26 ++++++++++
 include/linux/vme.h                    |  1 +
 4 files changed, 120 insertions(+), 12 deletions(-)

-- 
1.9.1


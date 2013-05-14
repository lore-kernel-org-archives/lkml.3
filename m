Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab3ENOtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:49:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab3ENOtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:49:42 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, chuck.anderson@oracle.com
Subject: [PATCH 0/2 v2] cpu: fix leaks and udev race in register_cpu()
Date: Tue, 14 May 2013 16:46:05 +0200
Message-Id: <1368542767-2126-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. move "crash_notes" and "crash_notes_size" to static attributes to
guarantee that it's destroyed with CPU on unregister.

2. fixes race between hotplugged CPU and onlining it via udev,
described at https://lkml.org/lkml/2012/4/30/193

Igor Mammedov (2):
  cpu: fix "crash_notes" and "crash_notes_size" leaks in register_cpu()
  cpu: make sure that cpu/online file created before KOBJ_ADD is
    emitted

 drivers/base/cpu.c |   59 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 39 insertions(+), 20 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3EMWJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 18:09:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab3EMWJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 18:09:04 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, konrad.wilk@oracle.com,
        chuck.anderson@oracle.com, imammedo@redhat.com
Subject: [RFC 0/2] cpu: fix leak and udev race in register_cpu()
Date: Tue, 14 May 2013 00:05:30 +0200
Message-Id: <1368482732-25554-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <20130513133128.GJ6811@phenom.dumpdata.com>
References: <20130513133128.GJ6811@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a crude attempt fix race the way suggested by Greg,
probably done wrong but hopefully in the right direction.

1. move "crash_notes" to static attributes to guarantee that it's
destroyed with CPU on unregister.

2. fixes race between hotplugged CPU and onlining it via udev, described here
https://lkml.org/lkml/2012/4/30/193

Igor Mammedov (2):
  cpu: fix crash_notes leak
  cpu: make sure that cpu/online file created before KOBJ_ADD is
    emitted

 drivers/base/cpu.c |   55 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 38 insertions(+), 17 deletions(-)


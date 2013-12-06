Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3LFAhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:37:50 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56872 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab3LFAhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:37:47 -0500
Subject: [PATCH v2 0/2] Remove ksets from sysfs eagerly
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Veaceslav Falico <vfalico@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zdenek Kabelac <zkabelac@redhat.com>
Date: Thu, 05 Dec 2013 17:37:43 -0700
Message-ID: <20131206003508.28684.1337.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes ksets from sysfs immediately in kset_unregister() to help
prevent module unload/reload problems.  It also adds more variability
to the CONFIG_DEBUG_KOBJECT_RELEASE option by delaying release functions
for a somewhat random time, to change the order in which they can be
called.

---

Bjorn Helgaas (2):
      kobject: delay kobject release for random time
      kobject: remove kset from sysfs immediately in kset_unregister()


 Documentation/kobject.txt |    5 ++++-
 lib/kobject.c             |   11 ++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

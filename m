Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3FAF0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 01:26:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:43167 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab3FAF0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 01:26:13 -0400
Message-ID: <1370064348.3766.37.camel@pasglop>
Subject: Re: [PATCH v3 0/8] Nvram-to-pstore
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Sat, 01 Jun 2013 15:25:48 +1000
In-Reply-To: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420>
References: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another question...

Should the core pstore fail to unlink partitions that don't have
an ->erase callback ? IE. Why would you let anyone erase the OFW
common partition for example ? That means that userspace tools
can no longer manipulate it but we certainly don't want to remove
it from the nvram itself.

That leads to a deeper concern. Looking at how efi-pstore works,
it looks like they create a file for each var.

This looks like something valuable we could do for something like
the common partition since typically it's made of name,value pairs.

However, pstore is a flat space, while we have patitions which
themselves can be organized in name,value pairs (some at least)

I wonder if it's time to introduce pstore directories... Or do
we stick to our special tools to interpret/change the name,value
pairs ?

Also do we want to add an ability to resize partitions ? Possibly
based on how much is written to them ?

Cheers,
Ben.



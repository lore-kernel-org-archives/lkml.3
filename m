Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787Ab3FSSxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:53:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55659 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934961Ab3FSSxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:53:30 -0400
Message-ID: <1371668008.2038.37.camel@joe-AO722>
Subject: getxattr: kzalloc/vmalloc mismatch
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 19 Jun 2013 11:53:28 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems the kzalloc could be kmalloc instead.

(it's filled by xattr_getsecurity)

in fs/xattr.c:

static ssize_t
getxattr(struct dentry *d, const char __user *name, void __user *value,
	 size_t size)
{
[]
	if (size) {
		if (size > XATTR_SIZE_MAX)
			size = XATTR_SIZE_MAX;
		kvalue = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
		if (!kvalue) {
			vvalue = vmalloc(size);
			if (!vvalue)
				return -ENOMEM;
			kvalue = vvalue;
		}
	}


